package de.blitzdose.serverctrl.standalone;

import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.logging.LoggingSaver;
import de.blitzdose.serverctrl.common.logging.LoggingType;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.auth.Role;
import de.blitzdose.serverctrl.common.web.auth.UserManager;
import de.blitzdose.serverctrl.consolesaver.ConsoleSaver;
import de.blitzdose.serverctrl.standalone.impl.Logger;
import de.blitzdose.serverctrl.standalone.impl.LoggingSaverImpl;
import de.blitzdose.serverctrl.standalone.impl.SystemDataLogger;
import de.blitzdose.serverctrl.standalone.impl.UserManagerImpl;
import de.blitzdose.serverctrl.standalone.impl.api.*;
import io.javalin.util.JavalinBindException;
import org.bouncycastle.operator.OperatorCreationException;
import org.bukkit.Bukkit;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import org.bukkit.event.player.PlayerQuitEvent;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.util.Arrays;
import java.util.stream.Collectors;

public class ServerCtrl extends JavaPlugin implements Listener {

    private Logger logger;
    private LoggingSaver loggingSaver;
    private ConsoleSaver consoleSaver;
    private SystemDataLogger dataLogger;
    private UserManagerImpl userManager;

    private Webserver webserver;

    @Override
    public void onEnable() {
        getConfig().options().copyDefaults(true);
        saveConfig();

        logger = new Logger(this);
        loggingSaver = new LoggingSaverImpl();
        consoleSaver = new ConsoleSaver("/plugins/ServerCtrl/log/console.log");
        dataLogger = new SystemDataLogger();
        userManager = new UserManagerImpl(this);

        Bukkit.getPluginManager().registerEvents(this, this);

        logger.log("was coded by blitzdose");
        logger.log("Version: §f" + this.getDescription().getVersion());

        getVersion();

        new Thread(this::startWebserver).start();


        Bukkit.getScheduler().runTaskTimerAsynchronously(this, dataLogger, 20L, 20L);
    }

    private void startWebserver() {
        BackupApiImpl backupApi = new BackupApiImpl();
        ConsoleApiImpl consoleApi = new ConsoleApiImpl(this, consoleSaver);
        FileApiImpl fileApi = new FileApiImpl(this);
        PlayerApiImpl playerApi = new PlayerApiImpl();
        PluginApiImpl pluginApi = new PluginApiImpl(this);
        ServerApiImpl serverApi = new ServerApiImpl(this);
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
                    this.getClassLoader(),
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
        if (!getConfig().contains("Webserver.users.admin")) {
            String password = UserManager.generateNewToken().replaceAll("_", "").substring(0, 12);
            userManager.createUser("admin", password);
            userManager.setRoles("admin", Arrays.stream(Role.values()).collect(Collectors.toList()));
            logger.log("Admin account created. Username: §fadmin §aPassword: §f" + password);
            reloadConfig();
        }
    }

    private void throwError(String error, boolean terminate) {
        logger.error(error);
        if (terminate) {
            getServer().getPluginManager().disablePlugin(this);
        }
    }

    @EventHandler
    public void onPlayerJoin(PlayerJoinEvent e) {
        loggingSaver.addLogEntry(LoggingType.PLAYER_JOINED, e.getPlayer().getName());
    }

    @EventHandler
    public void onPlayerQuit(PlayerQuitEvent e){
        loggingSaver.addLogEntry(LoggingType.PLAYER_QUIT, e.getPlayer().getName());
    }

    private void getVersion() {
        Bukkit.getScheduler().runTaskAsynchronously(this, () -> {
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

    @Override
    public void onDisable() {
        consoleSaver.clearLogFile();
        webserver.stop();
    }
}