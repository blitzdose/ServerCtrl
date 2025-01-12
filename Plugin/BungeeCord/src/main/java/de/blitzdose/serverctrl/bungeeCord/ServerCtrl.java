package de.blitzdose.serverctrl.bungeeCord;

import de.blitzdose.basicapiimpl.Logger;
import de.blitzdose.basicapiimpl.LoggingSaverImpl;
import de.blitzdose.basicapiimpl.SystemDataLogger;
import de.blitzdose.basicapiimpl.UserManagerImpl;
import de.blitzdose.basicapiimpl.api.*;
import de.blitzdose.serverctrl.bungeeCord.basicapiimpl.BungeeApiInstance;
import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.logging.LoggingSaver;
import de.blitzdose.serverctrl.common.logging.LoggingType;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.auth.Role;
import de.blitzdose.serverctrl.common.web.auth.UserManager;
import de.blitzdose.serverctrl.consolesaver.filterconsolesaver.FilterConsoleSaver;
import io.javalin.util.JavalinBindException;
import net.md_5.bungee.api.event.PlayerDisconnectEvent;
import net.md_5.bungee.api.event.PostLoginEvent;
import net.md_5.bungee.api.plugin.Listener;
import net.md_5.bungee.api.plugin.Plugin;
import net.md_5.bungee.config.Configuration;
import net.md_5.bungee.config.ConfigurationProvider;
import net.md_5.bungee.config.YamlConfiguration;
import net.md_5.bungee.event.EventHandler;
import org.bouncycastle.operator.OperatorCreationException;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.util.Arrays;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.stream.Collectors;

public final class ServerCtrl extends Plugin implements Listener {

    private BungeeApiInstance bungeeApiInstance;

    private Logger logger;
    private LoggingSaver loggingSaver;
    private FilterConsoleSaver filterConsoleSaver;
    private SystemDataLogger dataLogger;
    private UserManagerImpl userManager;

    private Webserver webserver;

    @Override
    public void onEnable() {
        try {
            makeConfig();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        bungeeApiInstance = new BungeeApiInstance(this);

        logger = new Logger(bungeeApiInstance);
        loggingSaver = new LoggingSaverImpl();
        filterConsoleSaver = new FilterConsoleSaver("/plugins/ServerCtrl/log/console.log", getProxy().getLogger(), Level.parse( System.getProperty( "net.md_5.bungee.file-log-level", "INFO" )));
        dataLogger = new SystemDataLogger();
        userManager = new UserManagerImpl(bungeeApiInstance);

        getProxy().getPluginManager().registerListener(this, this);

        logger.log("was coded by blitzdose");
        logger.log("Version: §f" + this.getDescription().getVersion());

        getVersion();

        new Thread(this::startWebserver).start();

        getProxy().getScheduler().schedule(this, dataLogger, 1L, 1L, TimeUnit.SECONDS);
    }

    private void startWebserver() {
        BackupApiImpl backupApi = new BackupApiImpl(bungeeApiInstance);
        ConsoleApiImpl consoleApi = new ConsoleApiImpl(bungeeApiInstance, filterConsoleSaver);
        FileApiImpl fileApi = new FileApiImpl(bungeeApiInstance);
        PlayerApiImpl playerApi = new PlayerApiImpl(bungeeApiInstance);
        PluginApiImpl pluginApi = new PluginApiImpl(bungeeApiInstance);
        ServerApiImpl serverApi = new ServerApiImpl(bungeeApiInstance);
        SystemApiImpl systemApi = new SystemApiImpl(dataLogger);

        int port = pluginApi.getPort();
        boolean https = pluginApi.isHTTPS();
        try {
            createAdminUserIfNotExists();

            if (https && !new File(pluginApi.getKeystorePath()).exists()) {
                CertManager.generateAndSaveSelfSignedCertificate("ServerCtrl", pluginApi.getKeystorePath(), pluginApi.getRootCAPath());
                logger.log("HTTPS Certificate created");
            }

            boolean debug = getConfig().getBoolean("Webserver.debugging");
            boolean frontend = getConfig().getBoolean("Webserver.frontend");
            webserver = new Webserver(port,
                    getClass().getClassLoader(),
                    frontend,
                    https,
                    debug,
                    logger,
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
            logger.log("Webserver started on Port: §f" + port);

        } catch (JavalinBindException | GeneralSecurityException | IOException | OperatorCreationException e) {
            throwError(e.getMessage(), true);
        }
    }

    private void createAdminUserIfNotExists() {
        if (!bungeeApiInstance.configContains("Webserver.users.admin")) {
            String password = UserManager.generateNewToken().replaceAll("_", "").substring(0, 12);
            userManager.createUser("admin", password);
            userManager.setRoles("admin", Arrays.stream(Role.values()).collect(Collectors.toList()));
            logger.log("Admin account created. Username: §fadmin §aPassword: §f" + password);
        }
    }

    private void throwError(String error, boolean terminate) {
        logger.error(error);
        if (terminate) {
            onDisable();
            getProxy().getPluginManager().unregisterListener(this);
        }
    }

    @EventHandler
    public void onPlayerJoin(PostLoginEvent e) {
        loggingSaver.addLogEntry(LoggingType.PLAYER_JOINED, e.getPlayer().getName());
    }

    @EventHandler
    public void onPlayerQuit(PlayerDisconnectEvent e){
        loggingSaver.addLogEntry(LoggingType.PLAYER_QUIT, e.getPlayer().getName());
    }

    private void getVersion() {
        getProxy().getScheduler().runAsync(this, () -> {
            try {
                HttpURLConnection urlConnection = (HttpURLConnection) new URL("https://github.com/blitzdose/ServerCtrl/releases/latest").openConnection();
                urlConnection.setUseCaches(false);
                urlConnection.setInstanceFollowRedirects(false);
                urlConnection.setRequestProperty("cache-control", "no-cache");
                urlConnection.setRequestProperty("pragma", "no-cache");

                if (urlConnection.getResponseCode() == 302) {
                    String[] latestUrl = urlConnection.getHeaderField("location").split("/");
                    String version = latestUrl[latestUrl.length-1];

                    if (!this.getDescription().getVersion().equalsIgnoreCase(version)) {
                        logger.info("Update available");
                    }
                } else {
                    throw new IOException("Wrong HTTP response code: " + urlConnection.getResponseCode());
                }
            } catch (IOException exception) {
                logger.error("Cannot look for updates: " + exception.getMessage());
            }
        });
    }


    public void makeConfig() throws IOException {
        if (!getDataFolder().exists()) {
            getDataFolder().mkdir();
        }

        File configFile = new File(getDataFolder(), "config.yml");

        if (!configFile.exists()) {
            FileOutputStream outputStream = new FileOutputStream(configFile);
            InputStream in = getResourceAsStream("config.yml");
            in.transferTo(outputStream);
            in.close();
            outputStream.close();
        }
    }

    public Configuration getConfig() {
        try {
            return ConfigurationProvider.getProvider(YamlConfiguration.class).load(new File(this.getDataFolder(), "config.yml"));
        } catch (IOException e) {
            return ConfigurationProvider.getProvider(YamlConfiguration.class).load("");
        }
    }

    public void saveConfig(Configuration configuration) {
        try {
            ConfigurationProvider.getProvider(YamlConfiguration.class).save(configuration, new File(this.getDataFolder(), "config.yml"));
        } catch (IOException ignored) { }
    }

    @Override
    public void onDisable() {
        filterConsoleSaver.clearLogFile();
        webserver.stop();
    }
}
