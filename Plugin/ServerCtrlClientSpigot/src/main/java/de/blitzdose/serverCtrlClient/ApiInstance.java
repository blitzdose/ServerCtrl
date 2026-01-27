package de.blitzdose.serverCtrlClient;

import de.blitzdose.serverctrl.embedded.models.Player;
import de.blitzdose.serverctrl.embedded.models.ServerData;
import org.bukkit.Bukkit;
import org.bukkit.World;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.plugin.Plugin;

import java.io.*;
import java.util.*;
import java.util.concurrent.ExecutionException;

public class ApiInstance extends de.blitzdose.serverctrl.embedded.instance.ApiInstance {

    private final Plugin plugin;

    public ApiInstance(Plugin plugin) {
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
    }

    @Override
    public List<String> configGetKeys(String key) {
        ConfigurationSection section = plugin.getConfig().getConfigurationSection(key);
        if (section == null) return List.of();
        return section.getKeys(false).stream().toList();
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
    public List<Player> getOnlinePlayers() {
        Collection<? extends org.bukkit.entity.Player> onlinePlayers = Bukkit.getServer().getOnlinePlayers();
        return onlinePlayers.stream().parallel().map(player -> new Player(player.getName(), player.getUniqueId(), player.isOp())).toList();
    }

    @Override
    public ServerData getServerData() {
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
                Boolean.parseBoolean(props.getProperty("enable-command-block")),
                ServerData.ServerType.SPIGOT
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

    @Override
    public boolean isPluginFolder(String path) {
        return path.startsWith("plugins\\ServerCtrl") || path.startsWith("plugins/ServerCtrl");
    }

    @Override
    public String getPluginFolder() {
        return "plugins/ServerCtrlClient";
    }

    @Override
    public boolean isBackupFolder(String path) {
        return path.startsWith("plugins\\ServerCtrlClient\\Backups") || path.startsWith("plugins/ServerCtrlClient/Backups");
    }

    @Override
    public String getConsoleLogPath() {
        return "plugins/ServerCtrlClient/log/console.log";
    }
}
