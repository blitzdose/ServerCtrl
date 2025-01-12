package de.blitzdose.serverctrl.common.web;

import de.blitzdose.serverctrl.common.logging.Logger;
import de.blitzdose.serverctrl.common.logging.LoggingSaver;
import de.blitzdose.serverctrl.common.web.api.*;
import de.blitzdose.serverctrl.common.web.auth.AccessManager;
import de.blitzdose.serverctrl.common.web.auth.Role;
import de.blitzdose.serverctrl.common.web.auth.UserManager;
import io.javalin.Javalin;
import io.javalin.community.ssl.SslPlugin;
import io.javalin.http.Context;
import io.javalin.http.staticfiles.Location;
import io.javalin.jetty.JettyServer;
import io.javalin.util.JavalinLogger;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.config.Configurator;
import org.eclipse.jetty.http.HttpStatus;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.File;
import java.security.Key;
import java.security.KeyStore;
import java.security.cert.Certificate;
import java.util.Base64;

import static io.javalin.apibuilder.ApiBuilder.*;

public class Webserver {
    Javalin app;
    int port;
    boolean frontend;
    boolean ssl;
    public static Logger logger;
    public static LoggingSaver loggingSaver;
    public static UserManager userManager;
    public static AbstractBackupApi abstractBackupApi;
    public static AbstractConsoleApi abstractConsoleApi;
    public static AbstractFileApi abstractFileApi;
    public static AbstractPlayerApi abstractPlayerApi;
    public static AbstractPluginApi abstractPluginApi;
    public static AbstractServerApi abstractServerApi;
    public static AbstractSystemApi abstractSystemApi;

    public Webserver(int port,
                     ClassLoader classLoaderMain,
                     boolean frontend,
                     boolean ssl,
                     boolean debug,
                     Logger logger,
                     LoggingSaver loggingSaver,
                     UserManager userManager,
                     AbstractBackupApi abstractBackupApi,
                     AbstractConsoleApi abstractConsoleApi,
                     AbstractFileApi abstractFileApi,
                     AbstractPlayerApi abstractPlayerApi,
                     AbstractPluginApi abstractPluginApi,
                     AbstractServerApi abstractServerApi,
                     AbstractSystemApi abstractSystemApi
    ) {
        this.port = port;
        this.frontend = frontend;
        this.ssl = ssl;
        Webserver.logger = logger;
        Webserver.loggingSaver = loggingSaver;
        Webserver.userManager = userManager;
        Webserver.abstractBackupApi = abstractBackupApi;
        Webserver.abstractConsoleApi = abstractConsoleApi;
        Webserver.abstractFileApi = abstractFileApi;
        Webserver.abstractPlayerApi = abstractPlayerApi;
        Webserver.abstractPluginApi = abstractPluginApi;
        Webserver.abstractServerApi = abstractServerApi;
        Webserver.abstractSystemApi = abstractSystemApi;

        if (!debug) {
            JavalinLogger.enabled = false;
            Configurator.setLevel("org.eclipse.jetty", Level.OFF);
        }

        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        Thread.currentThread().setContextClassLoader(classLoaderMain);

        SslPlugin plugin;
        if (ssl) {
            plugin = new SslPlugin(conf -> {
                try {
                    String[] keypair = getCertsFromKeystore();
                    conf.pemFromString(keypair[0], keypair[1]);
                } catch (Exception e) {
                    logger.error("Could not load HTTPS certificate");
                }
                conf.insecure = false;
                conf.secure = true;
                conf.securePort = port;
                conf.sniHostCheck = false;
                conf.http2 = false;
                conf.redirect = true;
            });
            app = Javalin.create(javalinConfig -> javalinConfig.registerPlugin(plugin));
        } else {
            plugin = null;
        }

        Thread.currentThread().setContextClassLoader(classLoader);

        app = Javalin.create(config -> {
            if (plugin != null) config.registerPlugin(plugin);
            config.staticFiles.add(staticFileConfig -> {
                staticFileConfig.hostedPath = "/";
                staticFileConfig.directory = "/html";
                staticFileConfig.location = Location.CLASSPATH;
                staticFileConfig.directory = "G:\\Projekte\\server_ctrl\\App\\build\\web";
                staticFileConfig.location = Location.EXTERNAL;
            });
            config.router.apiBuilder(() -> {
                path("/{system}/api", () -> {
                    path("system", () -> {
                        get("data", SystemApi::getData, Role.ANYONE);
                        get("historicData", SystemApi::getHistoricData, Role.ANYONE);
                    });
                    path("server", () -> {
                        get("icon", ServerApi::getIcon, Role.ANYONE);
                        get("name", ServerApi::getName);
                        post("name", ServerApi::setName, Role.PLUGINSETTINGS);
                        get("data", ServerApi::getData, Role.ANYONE);
                        get("settings", ServerApi::getSettings, Role.SERVERSETTINGS);
                        post("settings", ServerApi::setSettings, Role.SERVERSETTINGS);
                        post("restart", ServerApi::restart, Role.CONSOLE);
                        post("reload", ServerApi::reload, Role.CONSOLE);
                        post("stop", ServerApi::stop, Role.CONSOLE);
                    });
                    path("plugin", () -> {
                        get("settings", PluginApi::getSettings, Role.PLUGINSETTINGS);
                        post("settings", PluginApi::setSettings, Role.PLUGINSETTINGS);
                        path("certificate", () -> {
                            post("upload", PluginApi::setCertificate, Role.PLUGINSETTINGS);
                            post("generate", PluginApi::generateCertificate, Role.PLUGINSETTINGS);
                        });
                    });
                    path("player", () -> {
                        post("online", PlayerApi::getOnline, Role.ANYONE);
                        get("count", PlayerApi::countPlayers, Role.ANYONE);
                    });
                    path("user", () -> {
                        post("login", ctx -> UserApi.login(ctx, userManager));
                        post("logout", ctx -> UserApi.logout(ctx, userManager));
                        get("current", ctx -> UserApi.getCurrent(ctx, userManager));
                        get("permissions", ctx -> UserApi.getPermissions(ctx, userManager));
                        post("password", ctx -> UserApi.changePassword(ctx, userManager));
                        post("inittotp", ctx -> UserApi.initTOTP(ctx, userManager));
                        post("verifytotp", ctx -> UserApi.verifyTOTP(ctx, userManager));
                        post("removetotp", ctx -> UserApi.removeTOTP(ctx, userManager));
                        get("hastotp", ctx -> UserApi.hasTOTP(ctx, userManager));
                    });
                    path("account", () -> {
                        get("all", AccountApi::getAccounts, Role.ADMIN);
                        get("all-permissions", AccountApi::getAllPermissions, Role.ADMIN);
                        post("permissions", AccountApi::setPermissions, Role.ADMIN);
                        get("permissions", AccountApi::getPermissions, Role.ADMIN);
                        post("reset-password", AccountApi::resetPassword, Role.ADMIN);
                        post("delete", AccountApi::delete, Role.ADMIN);
                        post("create", AccountApi::create, Role.ADMIN);
                    });
                    path("console", () -> {
                        get("log", ConsoleApi::getLog, Role.CONSOLE);
                        post("command", ConsoleApi::command, Role.ANYONE);
                    });
                    path("log", () -> {
                        post("log", LogApi::getLog, Role.LOG);
                        get("count", LogApi::countLogs, Role.LOG);
                    });
                    path("files", () -> {
                        post("list", FilesApi::listFiles, Role.FILES);
                        post("count", FilesApi::countFiles, Role.FILES);
                        post("download", FilesApi::downloadFilePost, Role.FILES);
                        get("download", FilesApi::downloadFileGet, Role.FILES);
                        post("upload", FilesApi::uploadFile, Role.FILES);
                        post("extract-file", FilesApi::extractFile, Role.FILES);
                        post("delete", FilesApi::deleteFile, Role.FILES);
                        post("create-file", FilesApi::createFile, Role.FILES);
                        post("create-dir", FilesApi::createDir, Role.FILES);
                        post("rename", FilesApi::renameFile, Role.FILES);
                        post("download-multiple", FilesApi::downloadMultiple, Role.FILES);
                        post("delete-multiple", FilesApi::deleteMultiple, Role.FILES);
                        get("editable-files", FilesApi::getEditableFiles, Role.FILES, Role.PLUGINSETTINGS);
                        post("editable-files", FilesApi::setEditableFiles, Role.FILES, Role.PLUGINSETTINGS);
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

        app.beforeMatched(new AccessManager(userManager));
        userManager.replaceOldHashes();
    }

    private String[] getCertsFromKeystore() throws Exception {
        Base64.Encoder encoder = Base64.getEncoder();

        KeyStore keyStore = KeyStore.getInstance(new File("plugins/ServerCtrl/cert.jks"), "2-X>5h5^-!/'c(ELoT;)8O7I=-I<NMs)/{t8e~#0754>l=4".toCharArray());
        Key key = keyStore.getKey("cert", "2-X>5h5^-!/'c(ELoT;)8O7I=-I<NMs)/{t8e~#0754>l=4".toCharArray());
        Certificate certificate = keyStore.getCertificate("cert");
        Certificate rootCA = keyStore.getCertificate("rootca");

        String certPem = "-----BEGIN CERTIFICATE-----\n";
        certPem += encoder.encodeToString(certificate.getEncoded());
        certPem += "\n-----END CERTIFICATE-----\n";

        certPem += "-----BEGIN CERTIFICATE-----\n";
        certPem +=encoder.encodeToString(rootCA.getEncoded());
        certPem += "\n-----END CERTIFICATE-----";

        String keyPem = "-----BEGIN PRIVATE KEY-----\n";
        keyPem += encoder.encodeToString(key.getEncoded());
        keyPem += "\n-----END PRIVATE KEY-----";

        return new String[]{certPem, keyPem};
    }

    public void mainHandler(Context context) {
        if (context.path().startsWith("/view/login") ||
                context.path().startsWith("/view/css") ||
                context.path().startsWith("/view/js")) {
            return;
        }
        String token = context.cookie("token");
        if (token != null) {
            int result = userManager.authenticateUser(token);
            if (result == UserManager.SUCCESS) {
                return;
            }
        }
        context.redirect("/view/login/");
    }

    public void start()  {
        if (ssl) {
            app.start();
        } else {
            app.start(port);
        }
        JettyServer jettyServer = app.jettyServer();
        if (jettyServer != null) {
            jettyServer.server().setStopAtShutdown(true);
        }
    }

    public void stop() {
        app.stop();
        File file = new File("plugins/ServerCtrl/tmp");
        file.delete();
    }

    public static void returnJson(Context context, JSONObject jsonObject) {
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

    public static void return404(Context context) {
        context.status(HttpStatus.NOT_FOUND_404);
        context.result();
    }
}