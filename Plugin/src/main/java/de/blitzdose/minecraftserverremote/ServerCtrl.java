package de.blitzdose.minecraftserverremote;

import de.blitzdose.minecraftserverremote.crypt.CertManager;
import de.blitzdose.minecraftserverremote.logging.ConsoleSaver;
import de.blitzdose.minecraftserverremote.logging.Logger;
import de.blitzdose.minecraftserverremote.logging.LoggingSaver;
import de.blitzdose.minecraftserverremote.logging.LoggingType;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import de.blitzdose.minecraftserverremote.web.webserver.auth.Role;
import de.blitzdose.minecraftserverremote.web.webserver.auth.UserManager;
import io.javalin.util.JavalinBindException;
import org.bouncycastle.operator.OperatorCreationException;
import org.bukkit.Bukkit;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import org.bukkit.event.player.PlayerQuitEvent;
import org.bukkit.plugin.Plugin;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.security.GeneralSecurityException;
import java.util.Arrays;
import java.util.stream.Collectors;

public final class ServerCtrl extends JavaPlugin implements Listener {

    static Plugin plugin;

    ConsoleSaver consoleSaver;
    Webserver webserver;

    @Override
    public void onEnable() {
        consoleSaver = new ConsoleSaver();

        getConfig().options().copyDefaults(true);
        saveConfig();

        plugin = this;

        Bukkit.getPluginManager().registerEvents(this, this);

        Logger.log("was coded by blitzdose");
        Logger.log("Version: §f" + this.getDescription().getVersion());

        getVersion();

        new Thread(this::startWebserver).start();

        //Bukkit.getScheduler().runTaskTimerAsynchronously(this, new ConsoleSaver(), 20L, 20L);
    }

    private void startWebserver() {
        Object port = getConfig().get("Webserver.port");
        boolean https = getPlugin().getConfig().getBoolean("Webserver.https");
        if (port instanceof Integer) {
            try {
                createAdminUser();
                if (https && !new File("plugins/ServerCtrl/cert.jks").exists()) {
                    try {
                        CertManager.generateAndSaveSelfSignedCertificate("ServerCtrl", "plugins/ServerCtrl/cert.jks", "plugins/ServerCtrl/rootCA.cer");
                        Logger.log("HTTPS Certificate created");
                    } catch (GeneralSecurityException | IOException | OperatorCreationException e) {
                        e.printStackTrace();
                    }
                }
                boolean debug = getConfig().getBoolean("Webserver.debugging");
                webserver = new Webserver((Integer) port, this.getClassLoader(), getPlugin().getConfig().getBoolean("Webserver.frontend"), https, debug);
                webserver.start();
                Logger.log("Webserver started on Port: §f" + port);
            } catch (JavalinBindException e) {
                throwError(e.getMessage(), true);
            }
        } else {
            throwError("Config invalid", true);
        }
    }

    private void createAdminUser() {
        if (!plugin.getConfig().contains("Webserver.users.admin")) {
            String password = UserManager.generateNewToken().replaceAll("_", "").substring(0, 12);
            UserManager userManager = new UserManager();
            userManager.createUser("admin", password);
            userManager.setRoles("admin", Arrays.stream(Role.values()).collect(Collectors.toList()));
            Logger.log("Admin account created. Username: §fadmin §aPassword: §f" + password);
            reloadConfig();
        }
    }

    private void throwError(String error, boolean terminate) {
        Logger.error(error);
        if (terminate) {
            getServer().getPluginManager().disablePlugin(this);
        }
    }

    public static Plugin getPlugin() {
        return plugin;
    }

    @Override
    public void onDisable() {
        consoleSaver.clearLogFile();
        webserver.stop();
    }

    private void getVersion() {
        Bukkit.getScheduler().runTaskAsynchronously(plugin, () -> {
            try {
                URLConnection urlConnection = new URL("https://api.spigotmc.org/legacy/update.php?resource=" + 72231).openConnection();
                urlConnection.setUseCaches(false);
                urlConnection.setRequestProperty("cache-control", "no-cache");
                urlConnection.setRequestProperty("pragma", "no-cache");

                String version = new BufferedReader(new InputStreamReader(urlConnection.getInputStream())).readLine();
                if (!this.getDescription().getVersion().equalsIgnoreCase(version)) {
                    Logger.info("Update available");
                }
            } catch (IOException exception) {
                Logger.error("Cannot look for updates: " + exception.getMessage());
            }
        });
    }

    @EventHandler
    public void onPlayerJoin(PlayerJoinEvent e) {
        LoggingSaver.addLogEntry(LoggingType.PLAYER_JOINED, e.getPlayer().getName());
    }

    @EventHandler
    public void onPlayerQuit(PlayerQuitEvent e){
        LoggingSaver.addLogEntry(LoggingType.PLAYER_QUIT, e.getPlayer().getName());
    }

}
