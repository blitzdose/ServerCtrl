package de.blitzdose.webserver;

import de.blitzdose.api.BackendApiInstance;
import de.blitzdose.clientConnection.ProvisionedClientDao;
import de.blitzdose.clientConnection.ProvisionedClientMapper;
import de.blitzdose.clientConnection.websocket.WebsocketAccessManager;
import de.blitzdose.clientConnection.websocket.WebsocketClientManager;
import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.encryption.LocalEncryption;
import de.blitzdose.encryption.LocalEncryptionDao;
import de.blitzdose.encryption.LocalEncryptionManager;
import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.crypt.CryptManager;
import de.blitzdose.serverctrl.common.crypt.GeneratedCert;
import de.blitzdose.serverctrl.common.logging.Logger;
import de.blitzdose.webserver.api.*;
import de.blitzdose.webserver.auth.*;
import de.blitzdose.webserver.auth.session.PublicKeyManager;
import de.blitzdose.webserver.auth.session.UserManager;
import de.blitzdose.webserver.files.FileTransferManager;
import de.blitzdose.webserver.logging.SecurityLogType;
import io.javalin.Javalin;
import io.javalin.community.ssl.SslPlugin;
import io.javalin.http.Context;
import io.javalin.http.staticfiles.Location;
import io.javalin.jetty.JettyServer;
import io.javalin.util.JavalinLogger;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.config.Configurator;
import org.eclipse.jetty.http.HttpCookie;
import org.eclipse.jetty.http.HttpStatus;
import org.eclipse.jetty.server.session.SessionHandler;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.sqlobject.SqlObjectPlugin;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.security.KeyStore;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;

import static io.javalin.apibuilder.ApiBuilder.*;

public class WebServer {
    private final Javalin app;
    private final WebserverConfig webserverConfig;
    private final Logger logger;
    public static BackendApiInstance backendApiInstance;
    public static FileTransferManager fileTransferManager;

    public static WebsocketClientManager websocketClientManager;
    public static UserManager userManager;
    public static PublicKeyManager publicKeyManager;
    public static LocalEncryptionManager localEncryptionManager;

    public WebServer(
            WebserverConfig webserverConfig,
            Logger logger,
            BackendApiInstance backendApiInstance
    ) {
        Thread.currentThread().setContextClassLoader(getClass().getClassLoader());

        this.webserverConfig = webserverConfig;
        this.logger = logger;

        WebServer.backendApiInstance = backendApiInstance;
        WebServer.fileTransferManager = new FileTransferManager();

        if (!this.webserverConfig.debugging()) {
            JavalinLogger.enabled = false;
            Configurator.setLevel("org.eclipse.jetty", Level.OFF);
            Configurator.setLevel("org.apache.shiro.session.mgt.AbstractValidatingSessionManager", Level.OFF);
        }

        Jdbi jdbi = Jdbi.create("jdbc:sqlite:" + backendApiInstance.getDataDBPath());
        jdbi.installPlugin(new SqlObjectPlugin());
        jdbi.useExtension(UserDao.class, UserDao::createTable);
        jdbi.useExtension(ProvisionedClientDao.class, ProvisionedClientDao::createTable);
        jdbi.useExtension(LocalEncryptionDao.class, LocalEncryptionDao::createTable);

        jdbi.registerArgument(new RoleSetsArgumentFactory());
        jdbi.registerArgument(new PublicKeysArgumentFactory());
        jdbi.registerRowMapper(new UserMapper());
        jdbi.registerRowMapper(new ProvisionedClientMapper());

        websocketClientManager = new WebsocketClientManager(jdbi);
        localEncryptionManager = new LocalEncryptionManager(jdbi);
        localEncryptionManager.insertIfNotExists(new LocalEncryption(CryptManager.generateSecurePassword(128)));

        userManager = new UserManager(jdbi);

        if (userManager.getUserByUsername("admin") == null) {
            try {
                String password = CryptManager.generateSecurePassword(12);
                userManager.createUser(
                        "admin",
                        password
                );
                User user = userManager.getUserByUsername("admin");
                userManager.setSuperAdmin(user, true);
                logger.info(String.format("Generated password for user admin: %s", password));
            } catch (UserManager.UserManagerException.UserExistsException |
                     UserManager.UserManagerException.InvalidUsernameException ignored) {
            }
        }

        publicKeyManager = new PublicKeyManager(userManager);

        SslPlugin plugin;
        if (this.webserverConfig.https()) {
            plugin = new SslPlugin(conf -> {
                CertManager.KeyStoreManager keyStoreManager = CertManager.withKeyStoreManager(backendApiInstance.getKeystorePath(), localEncryptionManager.getPassword());
                try {
                    GeneratedCert certificate = keyStoreManager.getCertificateFromKeystore(CertManager.CertificateType.CERTIFICATE);
                    conf.pemFromString(CertManager.Converter.X509Certificate.toPEM(certificate.certificate()), CertManager.Converter.PrivateKey.toPEM(certificate.privateKey()));
                } catch (Exception e1) {
                    logger.error("Could not load HTTPS certificate: " + e1.getMessage());
                    logger.info("Generating new certificate...");
                    try {
                        KeyStore keyStore = keyStoreManager.generator().generateCertificate("127.0.0.1");
                        keyStoreManager.saveKeyStore(keyStore);
                        CertManager.saveCertificateToFile(keyStoreManager.getCertificateFromKeystore(CertManager.CertificateType.ROOT_CA).certificate(), backendApiInstance.getRootCAPath());
                        GeneratedCert certificate = keyStoreManager.getCertificateFromKeystore(CertManager.CertificateType.CERTIFICATE);
                        conf.pemFromString(CertManager.Converter.X509Certificate.toPEM(certificate.certificate()), CertManager.Converter.PrivateKey.toPEM(certificate.privateKey()));
                    } catch (Exception e2) {
                        logger.error("Generation failed");
                        throw new RuntimeException(e2);
                    }
                }
                conf.insecure = false;
                conf.secure = true;
                conf.securePort = this.webserverConfig.port();
                conf.sniHostCheck = false;
                conf.http2 = false;
                conf.redirect = true;
            });
        } else {
            plugin = null;
        }

        app = Javalin.create(config -> {
            SessionHandler sessionHandler = new SessionHandler();
            sessionHandler.setHttpOnly(true);
            sessionHandler.setSameSite(HttpCookie.SameSite.LAX);
            sessionHandler.getSessionCookieConfig().setMaxAge(2592000);
            config.jetty.modifyServletContextHandler(handler -> handler.setSessionHandler(sessionHandler));

            if (plugin != null) config.registerPlugin(plugin);
            if (this.webserverConfig.frontend()) {
                config.staticFiles.add(staticFileConfig -> {
                    staticFileConfig.hostedPath = "/";
                    staticFileConfig.directory = "/html";
                    staticFileConfig.location = Location.CLASSPATH;
                    //staticFileConfig.directory = "G:\\Projekte\\server_ctrl\\App\\build\\web";
                    //staticFileConfig.location = Location.EXTERNAL;
                });
            }
            config.router.apiBuilder(() -> {
                ws("/ws", ws -> {
                    ws.onConnect(WebsocketHandler::onConnect);
                    ws.onClose(WebsocketHandler::onClose);
                    ws.onError(WebsocketHandler::onError);
                    ws.onBinaryMessage(WebsocketHandler::onMessage);
                });
                path("/api", () -> {
                    path("system", () -> {
                        get("data", SystemApi::getData, Role.ANYONE);
                        get("historicData", SystemApi::getHistoricData, Role.ANYONE);
                    });
                    path("server", () -> {
                        get("icon", ServerApi::getIcon, Role.ANYONE);
                        get("name", ServerApi::getName, Role.ANYONE);
                        post("name", ServerApi::setName, WebserverManagerRole.SUPERADMIN);
                        get("data", ServerApi::getData, Role.ANYONE);
                        get("settings", ServerApi::getSettings, Role.SERVERSETTINGS);
                        post("settings", ServerApi::setSettings, Role.SERVERSETTINGS);
                        post("restart", ServerApi::restart, Role.CONSOLE);
                        post("reload", ServerApi::reload, Role.CONSOLE);
                        post("stop", ServerApi::stop, Role.CONSOLE);
                    });
                    path("provisioning", () -> {
                        get("add", ProvisioningApi::add, WebserverManagerRole.SUPERADMIN);
                        get("list", ProvisioningApi::list, WebserverManagerRole.SUPERADMIN);
                        post("delete", ProvisioningApi::delete, WebserverManagerRole.SUPERADMIN);
                    });
                    path("plugin", () -> {
                        get("settings", PluginApi::getSettings, WebserverManagerRole.SUPERADMIN);
                        post("settings", PluginApi::setSettings, WebserverManagerRole.SUPERADMIN);
                        path("certificate", () -> {
                            post("upload", PluginApi::setCertificate, WebserverManagerRole.SUPERADMIN);
                            post("generate", PluginApi::generateCertificate, WebserverManagerRole.SUPERADMIN);
                        });
                    });
                    path("player", () -> {
                        post("online", PlayerApi::getOnline, Role.ANYONE);
                        get("count", PlayerApi::countPlayers, Role.ANYONE);
                    });
                    path("user", () -> {
                        post("login", UserApi::login);
                        get("challenge", UserApi::challenge);
                        post("pubkeylogin", UserApi::pubkeyLogin);
                        post("logout", UserApi::logout, WebserverManagerRole.ANYONE);
                        get("current", UserApi::getCurrent, WebserverManagerRole.ANYONE);
                        get("permissions", UserApi::getPermissions, WebserverManagerRole.ANYONE);
                        post("password", UserApi::changePassword, WebserverManagerRole.ANYONE);
                        post("inittotp", UserApi::initTOTP, WebserverManagerRole.ANYONE);
                        post("verifytotp", UserApi::verifyTOTP, WebserverManagerRole.ANYONE);
                        post("removetotp", UserApi::removeTOTP, WebserverManagerRole.ANYONE);
                        get("hastotp", UserApi::hasTOTP, WebserverManagerRole.ANYONE);
                        post("pubkey", UserApi::addPubkey, WebserverManagerRole.ANYONE);
                    });
                    path("account", () -> {
                        get("all", AccountApi::getAccounts, WebserverManagerRole.SUPERADMIN);
                        get("all-permissions", AccountApi::getAllPermissions, WebserverManagerRole.SUPERADMIN);
                        post("permissions", AccountApi::setPermissions, WebserverManagerRole.SUPERADMIN);
                        get("permissions", AccountApi::getPermissions, WebserverManagerRole.SUPERADMIN);
                        post("reset-password", AccountApi::resetPassword, WebserverManagerRole.SUPERADMIN);
                        post("delete", AccountApi::delete, WebserverManagerRole.SUPERADMIN);
                        post("create", AccountApi::create, WebserverManagerRole.SUPERADMIN);
                        post("superadmin", AccountApi::setSuperAdmin, WebserverManagerRole.SUPERADMIN);
                    });
                    path("console", () -> {
                        get("log", ConsoleApi::getLog, Role.CONSOLE);
                        post("command", ConsoleApi::command, Role.CONSOLE);
                    });
                    path("log", () -> {
                        post("log", LogApi::getLog, WebserverManagerRole.SUPERADMIN);
                        get("count", LogApi::countLogs, WebserverManagerRole.SUPERADMIN);
                    });
                    path("files", () -> {
                        post("list", FilesApi::listFiles, Role.FILES);
                        get("count", FilesApi::countFiles, Role.FILES);
                        get("download", FilesApi::downloadFile, Role.FILES);
                        post("upload", FilesApi::uploadFile, Role.FILES);
                        post("extract-file", FilesApi::extractFile, Role.FILES);
                        post("delete", FilesApi::deleteFile, Role.FILES);
                        post("create-file", FilesApi::createFile, Role.FILES);
                        post("create-dir", FilesApi::createDir, Role.FILES);
                        post("rename", FilesApi::renameFile, Role.FILES);
                        get("download-multiple", FilesApi::downloadMultiple, Role.FILES);
                        post("delete-multiple", FilesApi::deleteMultiple, Role.FILES);
                        get("editable-files", FilesApi::getEditableFiles);
                        post("editable-files", FilesApi::setEditableFiles);

                        post("internal-upload/{transferID}", fileTransferManager::handleUpload, InternalRole.INTERNAL);
                        get("internal-download/{transferID}", fileTransferManager::handleDownload, InternalRole.INTERNAL);
                    });
                    path("backup", () -> {
                        path("worlds", () -> {
                            get("list", BackupApi.Worlds::listWorlds, Role.ADMIN);
                        });
                        get("list", BackupApi::list, Role.ADMIN);
                        path("create", () -> {
                            post("world", BackupApi.Worlds::startCreateWorldsBackup, Role.ADMIN);
                            post("full", BackupApi::startCreateFullBackup, Role.ADMIN);
                        });
                        post("delete", BackupApi::delete, Role.ADMIN);
                        get("download", BackupApi::download, Role.ADMIN);
                    });
                });
            });
        });

        app.beforeMatched(new AccessManager(userManager, websocketClientManager));
        app.wsBeforeUpgrade(new WebsocketAccessManager(websocketClientManager));

        app.exception(UserManager.UserManagerException.class, (e, ctx) -> {
            if (e instanceof UserManager.UserManagerException.WrongCredentialsException) {
                WebServer.returnUnauthorized(ctx);
                WebServer.securityLog(SecurityLogType.LOGIN_FAIL, e.getUsername(), "Login failed for user");
            } else if (e instanceof UserManager.UserManagerException.WrongTOTPException) {
                ctx.status(HttpStatus.PAYMENT_REQUIRED_402);
                ctx.result();
            } else {
                WebServer.returnUnauthorized(ctx);
            }
        });

        app.exception(WebsocketException.SystemNotFoundException.class, (e, context) -> {
           return404(context);
        });

        app.exception(WebsocketException.SystemNotConnectedException.class, (e, context) -> {
            context.status(HttpStatus.GONE_410);
            context.result();
        });

        app.exception(WebsocketException.TimeoutException.class, (e, context) -> {
            context.status(HttpStatus.REQUEST_TIMEOUT_408);
            context.result();
        });

        app.exception(WebsocketException.RequestNotSuccessfulException.class, (e, context) -> {
            returnFailedJson(context);
        });

        app.exception(ClassCastException.class, (e, context) -> {
            returnFailedJson(context);
        });

        app.exception(Exception.class, (e, context) -> {
            if (this.webserverConfig.debugging()) {
                e.printStackTrace();
            }
            returnFailedJson(context);
        });
    }

    public void start()  {
        if (this.webserverConfig.https()) {
            app.start();
        } else {
            app.start(this.webserverConfig.port());
        }
        JettyServer jettyServer = app.jettyServer();
        if (jettyServer != null) {
            jettyServer.server().setStopAtShutdown(true);
        }
        logger.info("Started successfully on port: " + this.webserverConfig.port());
    }

    public void stop() {
        app.stop();
    }

    public static <T> T getData(Context context, Class<T> clazz) {
        JSONObject jsonObject = new JSONObject(context.body());
        return  clazz.cast(jsonObject.get("data"));
    }

    public static void returnFailedJson(Context context) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("success", false);
        WebServer.returnJson(context, jsonObject);
    }

    public static void returnSuccessfulJson(Context context, JSONObject jsonObject) {
        jsonObject.put("success", true);
        returnJson(context, jsonObject);
    }

    private static void returnJson(Context context, JSONObject jsonObject) {
        context.contentType("application/json; charset=utf-8");
        context.header("Access-Control-Allow-Origin", "*");
        context.result(jsonObject.toString());
    }

    public static void returnImage(Context context, byte[] image) {
        context.contentType("image/png");
        context.header("Access-Control-Allow-Origin", "*");
        context.result(image);
    }

    public static void returnFile(Context context, String name, long size, BufferedInputStream inputStream) {
        context.contentType("application/octet-stream");
        context.header("Access-Control-Allow-Origin", "*");
        context.header("Content-Disposition", "attachment; filename=\"" + name + "\"");
        context.header("Content-Length", String.valueOf(size));
        try {
            inputStream.transferTo(context.res().getOutputStream());
            inputStream.close();
        } catch (Exception ignored) { }

    }

    public static void returnUnauthorized(Context context) {
        context.status(HttpStatus.UNAUTHORIZED_401);
        context.result();
    }

    public static void return404(Context context) {
        context.status(HttpStatus.NOT_FOUND_404);
        context.result();
    }

    public static void securityLog(SecurityLogType type, Context context, String message) {
        User user = Objects.requireNonNull(context.attribute("user"));
        String username = user.getUsername();
        securityLog(type, username, message);
    }

    public static void securityLog(SecurityLogType type, String username, String message) {
        message =  "[" + username + "] " + message;

        try {
            File file = new File(backendApiInstance.getLogPath());
            if (!file.exists()) {
                new File(backendApiInstance.getLogPath().substring(0, backendApiInstance.getLogPath().lastIndexOf("/"))).mkdirs();
                file.createNewFile();
            }

            DateFormat formatter = new SimpleDateFormat("dd.MM.yy HH:mm:ss");
            String time =  formatter.format(new Date());

            FileWriter writer = new FileWriter(file, true);
            writer.append("[").append(time).append("] ").append(type.getTag()).append(" ").append(message).append("\n");
            writer.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
