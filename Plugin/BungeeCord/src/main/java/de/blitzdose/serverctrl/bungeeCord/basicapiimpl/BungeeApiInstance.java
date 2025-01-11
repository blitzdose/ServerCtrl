package de.blitzdose.serverctrl.bungeeCord.basicapiimpl;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.bungeeCord.ServerCtrl;
import de.blitzdose.serverctrl.common.web.api.AbstractPlayerApi;
import de.blitzdose.serverctrl.common.web.api.AbstractServerApi;
import net.md_5.bungee.api.chat.ComponentBuilder;
import net.md_5.bungee.api.config.ListenerInfo;
import net.md_5.bungee.api.connection.ProxiedPlayer;
import net.md_5.bungee.config.Configuration;

import java.net.InetSocketAddress;
import java.util.*;

public class BungeeApiInstance extends ApiInstance {

    private final ServerCtrl plugin;

    public BungeeApiInstance(ServerCtrl plugin) {
        this.plugin = plugin;
    }

    @Override
    public void sendMessage(String message) {
        plugin.getProxy().getConsole().sendMessage(new ComponentBuilder(message).create());
    }

    @Override
    public List<String> configGetStringList(String key) {
        Configuration configuration = plugin.getConfig();
        return configuration.getStringList(key);
    }

    @Override
    public String configGetString(String key) {
        Configuration configuration = plugin.getConfig();
        if (!configuration.contains(key)) {
            return null;
        }
        return configuration.getString(key);
    }

    @Override
    public int configGetInt(String key) {
        Configuration configuration = plugin.getConfig();
        return configuration.getInt(key);
    }

    @Override
    public boolean configGetBoolean(String key) {
        Configuration configuration = plugin.getConfig();
        return configuration.getBoolean(key);
    }

    @Override
    public boolean configContains(String key) {
        Configuration configuration = plugin.getConfig();
        return configuration.contains(key);
    }

    @Override
    public void configUpdate(String key, Object value) {
        Configuration configuration = plugin.getConfig();
        configuration.set(key, value);
        plugin.saveConfig(configuration);
    }

    @Override
    public void shutdownServer() {
        plugin.getProxy().getPluginManager().dispatchCommand(plugin.getProxy().getConsole(), "end");
    }

    @Override
    public void reloadServer() {
        plugin.getProxy().getPluginManager().dispatchCommand(plugin.getProxy().getConsole(), "greload");
    }

    @Override
    public void restartServer() {

    }

    @Override
    public void sendCommand(String command) {
        if (!plugin.getProxy().getPluginManager().isExecutableCommand(command.split(" ")[0], plugin.getProxy().getConsole())) {
            plugin.getProxy().getLogger().info("§4Command not found");
        } else {
            plugin.getProxy().getPluginManager().dispatchCommand(plugin.getProxy().getConsole(), command);
        }
    }

    @Override
    public int getOnlinePlayerCount() {
        return plugin.getProxy().getOnlineCount();
    }

    @Override
    public List<AbstractPlayerApi.Player> getOnlinePlayers() {
        Collection<ProxiedPlayer> onlinePlayers = plugin.getProxy().getPlayers();
        return onlinePlayers.stream().map(player -> new AbstractPlayerApi.Player(player.getName(), player.getUniqueId(), false)).toList();
    }

    @Override
    public Set<String> getUsers() {
        Configuration users = plugin.getConfig().getSection("Webserver.users");
        if (users == null) {
            return null;
        } else {
            return new HashSet<>(users.getKeys());
        }
    }

    @Override
    public AbstractServerApi.ServerData getServerData() {
        Optional<ListenerInfo> optionalListener = plugin.getProxy().getConfig().getListeners().stream().findFirst();
        if (optionalListener.isPresent()) {
            ListenerInfo listener = optionalListener.get();
            int port = -1;
            if (listener.getSocketAddress() instanceof InetSocketAddress inetSocketAddress) {
                port = inetSocketAddress.getPort();
            }
            return new AbstractServerApi.ServerData(
                    listener.getMotd(),
                    port,
                    plugin.getProxy().getVersion(),
                    listener.getMaxPlayers(),
                    plugin.getProxy().getConfig().isOnlineMode(),
                    true,
                    true,
                    false,
                    true,
                    AbstractServerApi.ServerData.ServerType.BUNGEE
            );
        } else {
            return null;
        }
    }

    @Override
    public Properties getServerProperties() {
        return null;
    }

    @Override
    public boolean setServerProperties(Properties properties) {
        return false;
    }

    @Override
    public List<String> getWorldPaths(List<UUID> worlds) {
        return null;
    }

    @Override
    public Map<String, UUID> getWorlds() {
        return null;
    }
}
