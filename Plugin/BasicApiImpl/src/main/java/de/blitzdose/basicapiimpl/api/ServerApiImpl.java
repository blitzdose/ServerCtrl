package de.blitzdose.basicapiimpl.api;

import de.blitzdose.serverctrl.common.web.api.AbstractServerApi;
import org.apache.commons.io.FileUtils;
import org.bukkit.Bukkit;
import org.bukkit.plugin.Plugin;

import java.io.*;
import java.util.Properties;

public class ServerApiImpl extends AbstractServerApi {

    private final Plugin plugin;

    public ServerApiImpl(Plugin plugin) {
        this.plugin = plugin;
    }

    @Override
    public byte[] getServerIcon(String system) {
        try {
            return FileUtils.readFileToByteArray(new File("server-icon.png"));
        } catch (IOException e) {
            return null;
        }
    }

    @Override
    public String getServerName(String system) {
        return plugin.getConfig().getString("Webserver.servername");
    }

    @Override
    public void setServerName(String system, String name) {
        plugin.getConfig().set("Webserver.servername", name);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public ServerData getServerData(String system) {
        Properties props = new Properties();
        try(BufferedReader is = new BufferedReader(new FileReader("server.properties"))) {
            props.load(is);
        } catch (IOException ignored) { }

        return new ServerData(
                plugin.getServer().getMotd(),
                plugin.getServer().getPort(),
                plugin.getServer().getVersion(),
                plugin.getServer().getMaxPlayers(),
                plugin.getServer().getOnlineMode(),
                plugin.getServer().getAllowEnd(),
                plugin.getServer().getAllowNether(),
                plugin.getServer().hasWhitelist(),
                Boolean.parseBoolean(props.getProperty("enable-command-block"))
        );
    }

    @Override
    public Properties getServerProperties(String system) {
        Properties props = new Properties();
        try(BufferedReader is = new BufferedReader(new FileReader("server.properties"))) {
            props.load(is);
            return props;
        } catch (IOException ignored) {
            return null;
        }
    }

    @Override
    public boolean setServerProperties(String system, Properties properties) {
        try(FileWriter writer = new FileWriter("server.properties")) {
            properties.store(writer, "#Minecraft server properties");
        } catch (IOException e) {
            return false;
        }
        return true;
    }

    @Override
    public void stopServer(String system) {
        Bukkit.getScheduler().scheduleSyncDelayedTask(plugin, () -> Bukkit.getServer().shutdown(), 20L);
    }

    @Override
    public void restartServer(String system) {
        Bukkit.getScheduler().scheduleSyncDelayedTask(plugin, () -> Bukkit.getServer().spigot().restart(), 20L);
    }

    @Override
    public void reloadServer(String system) {
        Bukkit.getScheduler().scheduleSyncDelayedTask(plugin, () -> Bukkit.getServer().reload(), 20L);
    }
}
