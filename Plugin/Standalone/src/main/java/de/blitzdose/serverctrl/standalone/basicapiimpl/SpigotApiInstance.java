package de.blitzdose.serverctrl.standalone.basicapiimpl;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.web.api.AbstractPlayerApi;
import de.blitzdose.serverctrl.common.web.api.AbstractServerApi;
import org.bukkit.Bukkit;
import org.bukkit.World;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.entity.Player;
import org.bukkit.plugin.Plugin;

import java.io.*;
import java.util.*;
import java.util.concurrent.ExecutionException;

public class SpigotApiInstance extends ApiInstance {

    final Plugin plugin;

    public SpigotApiInstance(Plugin plugin) {
        this.plugin = plugin;
    }

    @Override
    public void sendMessage(String message) {
        Bukkit.getConsoleSender().sendMessage(message);
    }

    @Override
    public List<String> configGetStringList(String key) {
        return plugin.getConfig().getStringList(key);
    }

    @Override
    public String configGetString(String key) {
        return plugin.getConfig().getString(key);
    }

    @Override
    public int configGetInt(String key) {
        return plugin.getConfig().getInt(key);
    }

    @Override
    public boolean configGetBoolean(String key) {
        return plugin.getConfig().getBoolean(key);
    }

    @Override
    public boolean configContains(String key) {
        return plugin.getConfig().contains(key);
    }

    @Override
    public void configUpdate(String key, Object value) {
        plugin.getConfig().set(key, value);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void shutdownServer() {
        Bukkit.getScheduler().scheduleSyncDelayedTask(plugin, () -> Bukkit.getServer().shutdown(), 20L);
    }

    @Override
    public void reloadServer() {
        Bukkit.getScheduler().scheduleSyncDelayedTask(plugin, () -> Bukkit.getServer().reload(), 20L);
    }

    @Override
    public void restartServer() {
        Bukkit.getScheduler().scheduleSyncDelayedTask(plugin, () -> Bukkit.getServer().spigot().restart(), 20L);
    }

    @Override
    public void sendCommand(String command) throws ExecutionException, InterruptedException {
        Bukkit.getScheduler().callSyncMethod(plugin, () -> Bukkit.dispatchCommand( Bukkit.getServer().getConsoleSender(), command)).get();
    }

    @Override
    public int getOnlinePlayerCount() {
        return Bukkit.getOnlinePlayers().size();
    }

    @Override
    public List<AbstractPlayerApi.Player> getOnlinePlayers() {
        Collection<? extends Player> onlinePlayers = Bukkit.getServer().getOnlinePlayers();
        return onlinePlayers.stream().map(player -> new AbstractPlayerApi.Player(player.getName(), player.getUniqueId(), player.isOp())).toList();
    }

    @Override
    public Set<String> getUsers() {
        ConfigurationSection users = plugin.getConfig().getConfigurationSection("Webserver.users");
        if (users == null) {
            return null;
        } else {
            return users.getKeys(false);
        }
    }

    @Override
    public AbstractServerApi.ServerData getServerData() {
        Properties props = new Properties();
        try(BufferedReader is = new BufferedReader(new FileReader("server.properties"))) {
            props.load(is);
        } catch (IOException ignored) { }

        return new AbstractServerApi.ServerData(
                plugin.getServer().getMotd(),
                plugin.getServer().getPort(),
                plugin.getServer().getVersion(),
                plugin.getServer().getMaxPlayers(),
                plugin.getServer().getOnlineMode(),
                plugin.getServer().getAllowEnd(),
                plugin.getServer().getAllowNether(),
                plugin.getServer().hasWhitelist(),
                Boolean.parseBoolean(props.getProperty("enable-command-block")),
                AbstractServerApi.ServerData.ServerType.SPIGOT
        );
    }

    @Override
    public Properties getServerProperties() {
        Properties props = new Properties();
        try(BufferedReader is = new BufferedReader(new FileReader("server.properties"))) {
            props.load(is);
            return props;
        } catch (IOException ignored) {
            return null;
        }
    }

    @Override
    public boolean setServerProperties(Properties properties) {
        try(FileWriter writer = new FileWriter("server.properties")) {
            properties.store(writer, "#Minecraft server properties");
        } catch (IOException e) {
            return false;
        }
        return true;
    }

    @Override
    public List<String> getWorldPaths(List<UUID> worlds) {
        return worlds.stream().map(Bukkit::getWorld).filter(Objects::nonNull).map(World::getWorldFolder).map(File::getPath).toList();
    }

    @Override
    public Map<String, UUID> getWorlds() {
        Map<String, UUID> worlds = new HashMap<>();
        for (World world : Bukkit.getWorlds()) {
            worlds.put(world.getName(), world.getUID());
        }
        return worlds;
    }
}
