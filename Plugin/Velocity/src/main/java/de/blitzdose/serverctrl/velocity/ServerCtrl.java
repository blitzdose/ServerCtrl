package de.blitzdose.serverctrl.velocity;

import com.google.inject.Inject;
import com.velocitypowered.api.event.Subscribe;
import com.velocitypowered.api.event.connection.DisconnectEvent;
import com.velocitypowered.api.event.connection.LoginEvent;
import com.velocitypowered.api.event.proxy.ProxyInitializeEvent;
import com.velocitypowered.api.event.proxy.ProxyShutdownEvent;
import com.velocitypowered.api.plugin.Plugin;
import com.velocitypowered.api.plugin.annotation.DataDirectory;
import com.velocitypowered.api.proxy.ProxyServer;
import de.blitzdose.basicapiimpl.LoggingSaverImpl;
import de.blitzdose.basicapiimpl.SystemDataLogger;
import de.blitzdose.basicapiimpl.UserManagerImpl;
import de.blitzdose.basicapiimpl.api.*;
import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.logging.LoggingSaver;
import de.blitzdose.serverctrl.common.logging.LoggingType;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.auth.Role;
import de.blitzdose.serverctrl.common.web.auth.UserManager;
import de.blitzdose.serverctrl.consolesaver.appenderconsolesaver.AppenderConsoleSaver;
import de.blitzdose.serverctrl.velocity.basicapiimpl.VelocityApiInstance;
import io.javalin.util.JavalinBindException;
import org.bouncycastle.operator.OperatorCreationException;
import org.slf4j.Logger;
import org.spongepowered.configurate.CommentedConfigurationNode;
import org.spongepowered.configurate.yaml.NodeStyle;
import org.spongepowered.configurate.yaml.YamlConfigurationLoader;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.GeneralSecurityException;
import java.time.Duration;
import java.util.Arrays;
import java.util.stream.Collectors;

import static de.blitzdose.serverctrl.velocity.ServerCtrl.VERSION;

@Plugin(
    id = "serverctrl",
    name = "ServerCtrl",
    version = VERSION
    ,authors = {"blitzdose"}
)
public class ServerCtrl {

    public static final String VERSION = "4.1.3";

    @Inject public Logger logger;
    @Inject private ProxyServer server;
    @Inject private @DataDirectory Path dataDirectory;

    private VelocityApiInstance velocityApiInstance;

    public de.blitzdose.basicapiimpl.Logger apiLogger;
    private LoggingSaver loggingSaver;
    private AppenderConsoleSaver appenderConsoleSaver;
    private SystemDataLogger dataLogger;
    private UserManagerImpl userManager;

    private Webserver webserver;

    @Subscribe
    public void onProxyInitialization(ProxyInitializeEvent event) {
        try {
            makeConfig();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        velocityApiInstance = new VelocityApiInstance(this);

        apiLogger = new de.blitzdose.basicapiimpl.Logger(velocityApiInstance);
        loggingSaver = new LoggingSaverImpl();

        appenderConsoleSaver = new AppenderConsoleSaver("/plugins/ServerCtrl/log/console.log", false);
        dataLogger = new SystemDataLogger();
        userManager = new UserManagerImpl(velocityApiInstance);

        apiLogger.log("was coded by blitzdose");
        apiLogger.log("Version: §f" + VERSION);

        getVersion();

        new Thread(this::startWebserver).start();

        server.getScheduler().buildTask(this, dataLogger).delay(Duration.ofSeconds(1)).repeat(Duration.ofSeconds(1)).schedule();
    }

    @Subscribe
    public void onPlayerJoin(LoginEvent e) {
        loggingSaver.addLogEntry(LoggingType.PLAYER_JOINED, e.getPlayer().getUsername());
    }

    @Subscribe
    public void onPlayerQuit(DisconnectEvent e) {
        loggingSaver.addLogEntry(LoggingType.PLAYER_JOINED, e.getPlayer().getUsername());
    }

    private void startWebserver() {
        BackupApiImpl backupApi = new BackupApiImpl(velocityApiInstance);
        ConsoleApiImpl consoleApi = new ConsoleApiImpl(velocityApiInstance, appenderConsoleSaver);
        FileApiImpl fileApi = new FileApiImpl(velocityApiInstance);
        PlayerApiImpl playerApi = new PlayerApiImpl(velocityApiInstance);
        PluginApiImpl pluginApi = new PluginApiImpl(velocityApiInstance);
        ServerApiImpl serverApi = new ServerApiImpl(velocityApiInstance);
        SystemApiImpl systemApi = new SystemApiImpl(dataLogger);

        int port = pluginApi.getPort();
        boolean https = pluginApi.isHTTPS();
        try {
            createAdminUserIfNotExists();

            if (https && !new File(pluginApi.getKeystorePath()).exists()) {
                CertManager.generateAndSaveSelfSignedCertificate("ServerCtrl", pluginApi.getKeystorePath(), pluginApi.getRootCAPath());
                apiLogger.log("HTTPS Certificate created");
            }

            boolean debug = getConfig().node("Webserver.debugging").getBoolean();
            boolean frontend = getConfig().node("Webserver.debugging").getBoolean();
            webserver = new Webserver(port,
                    getClass().getClassLoader(),
                    frontend,
                    https,
                    debug,
                    apiLogger,
                    loggingSaver,
                    userManager,
                    backupApi,
                    consoleApi,
                    fileApi,
                    playerApi,
                    pluginApi,
                    serverApi,
                    systemApi
            );
            webserver.start();
            apiLogger.log("Webserver started on Port: §f" + port);

        } catch (JavalinBindException | GeneralSecurityException | IOException | OperatorCreationException e) {
            throwError(e.getMessage(), true);
        }
    }

    private void createAdminUserIfNotExists() {
        if (!velocityApiInstance.configContains("Webserver.users.admin")) {
            String password = UserManager.generateNewToken().replaceAll("_", "").substring(0, 12);
            userManager.createUser("admin", password);
            userManager.setRoles("admin", Arrays.stream(Role.values()).collect(Collectors.toList()));
            apiLogger.log("Admin account created. Username: §fadmin §aPassword: §f" + password);
        }
    }

    private void throwError(String error, boolean terminate) {
        apiLogger.error(error);
        if (terminate) {
            onDisable(null);
        }
    }

    public void makeConfig() throws IOException {
        if (!dataDirectory.toFile().exists()) {
            dataDirectory.toFile().mkdir();
        }

        File configFile = new File(dataDirectory.toFile(), "config.yml");

        if (!configFile.exists()) {
            try (InputStream stream = this.getClass().getClassLoader().getResourceAsStream("config.yml")) {
                if (stream == null) return;
                Files.copy(stream, configFile.toPath());
            }
        }
    }

    public CommentedConfigurationNode getConfig() {
        try {
            return YamlConfigurationLoader.builder().file(new File(dataDirectory.toFile(), "config.yml")).build().load();
        } catch (IOException e) {
            return CommentedConfigurationNode.root();
        }
    }

    public void saveConfig(CommentedConfigurationNode configuration) {
        try {
            YamlConfigurationLoader.builder().file(new File(dataDirectory.toFile(), "config.yml")).indent(2).nodeStyle(NodeStyle.BLOCK).build().save(configuration);
        } catch (IOException ignored) { }
    }

    private void getVersion() {
        server.getScheduler().buildTask(this, () -> {
            try {
                HttpURLConnection urlConnection = (HttpURLConnection) new URL("https://github.com/blitzdose/ServerCtrl/releases/latest").openConnection();
                urlConnection.setUseCaches(false);
                urlConnection.setInstanceFollowRedirects(false);
                urlConnection.setRequestProperty("cache-control", "no-cache");
                urlConnection.setRequestProperty("pragma", "no-cache");

                if (urlConnection.getResponseCode() == 302) {
                    String[] latestUrl = urlConnection.getHeaderField("location").split("/");
                    String version = latestUrl[latestUrl.length-1];

                    if (!VERSION.equalsIgnoreCase(version)) {
                        apiLogger.info("Update available");
                    }
                } else {
                    throw new IOException("Wrong HTTP response code: " + urlConnection.getResponseCode());
                }
            } catch (IOException exception) {
                apiLogger.error("Cannot look for updates: " + exception.getMessage());
            }
        }).schedule();
    }

    public ProxyServer getServer() {
        return server;
    }

    @Subscribe
    public void onDisable(ProxyShutdownEvent e) {
        appenderConsoleSaver.clearLogFile();
        webserver.stop();
    }
}
