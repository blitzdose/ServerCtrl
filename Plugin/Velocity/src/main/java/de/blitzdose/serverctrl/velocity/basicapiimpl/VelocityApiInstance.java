package de.blitzdose.serverctrl.velocity.basicapiimpl;

import com.velocitypowered.api.proxy.Player;
import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.web.api.AbstractPlayerApi;
import de.blitzdose.serverctrl.common.web.api.AbstractServerApi;
import de.blitzdose.serverctrl.velocity.ServerCtrl;
import net.kyori.adventure.text.serializer.legacy.LegacyComponentSerializer;
import net.kyori.adventure.text.serializer.plain.PlainTextComponentSerializer;
import org.spongepowered.configurate.CommentedConfigurationNode;
import org.spongepowered.configurate.serialize.SerializationException;

import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

public class VelocityApiInstance extends ApiInstance {

    private final ServerCtrl plugin;

    public VelocityApiInstance(ServerCtrl plugin) {
        this.plugin = plugin;
    }

    @Override
    public void sendMessage(String message) {
        LegacyComponentSerializer serializer = LegacyComponentSerializer.builder().build();
        plugin.getServer().sendMessage(serializer.deserialize(message));
    }

    @Override
    public List<String> configGetStringList(String key) {
        CommentedConfigurationNode configuration = plugin.getConfig();
        try {
            return configuration.node((Object[]) key.split("[.]")).getList(String.class);
        } catch (SerializationException e) {
            return List.of();
        }
    }

    @Override
    public String configGetString(String key) {
        CommentedConfigurationNode configuration = plugin.getConfig();
        return configuration.node((Object[]) key.split("[.]")).getString();
    }

    @Override
    public int configGetInt(String key) {
        CommentedConfigurationNode configuration = plugin.getConfig();
        return configuration.node((Object[]) key.split("[.]")).getInt();
    }

    @Override
    public boolean configGetBoolean(String key) {
        CommentedConfigurationNode configuration = plugin.getConfig();
        return configuration.node((Object[]) key.split("[.]")).getBoolean();
    }

    @Override
    public boolean configContains(String key) {
        CommentedConfigurationNode configuration = plugin.getConfig();
        return !configuration.node((Object[]) key.split("[.]")).isNull();
    }

    @Override
    public void configUpdate(String key, Object value) {
        CommentedConfigurationNode configuration = plugin.getConfig();
        try {
            configuration.node((Object[]) key.split("[.]")).set(value);
            plugin.saveConfig(configuration);
        } catch (SerializationException ignored) { }

    }

    @Override
    public void shutdownServer() {
        plugin.getServer().getCommandManager().executeImmediatelyAsync(plugin.getServer().getConsoleCommandSource(), "shutdown");
    }

    @Override
    public void reloadServer() {
        plugin.getServer().getCommandManager().executeImmediatelyAsync(plugin.getServer().getConsoleCommandSource(), "velocity reload");
    }

    @Override
    public void restartServer() {

    }

    @Override
    public void sendCommand(String command) throws ExecutionException, InterruptedException {
        if (!plugin.getServer().getCommandManager().hasCommand(command.split(" ")[0])) {
            sendMessage("§4Command not found");
        } else {
            plugin.getServer().getCommandManager().executeImmediatelyAsync(plugin.getServer().getConsoleCommandSource(), command);
        }
    }

    @Override
    public int getOnlinePlayerCount() {
        return plugin.getServer().getPlayerCount();
    }

    @Override
    public List<AbstractPlayerApi.Player> getOnlinePlayers() {
        Collection<Player> onlinePlayers = plugin.getServer().getAllPlayers();
        return onlinePlayers.stream().map(player -> new AbstractPlayerApi.Player(player.getUsername(), player.getUniqueId(), false)).toList();
    }

    @Override
    public Set<String> getUsers() {
        CommentedConfigurationNode users = plugin.getConfig().node((Object[]) "Webserver.users".split("[.]"));
        if (users.isNull()) {
            return null;
        } else {
            return users.childrenMap().keySet().stream().map(Object::toString).collect(Collectors.toSet());
        }
    }

    @Override
    public AbstractServerApi.ServerData getServerData() {
        PlainTextComponentSerializer serializer = PlainTextComponentSerializer.plainText();
        return new AbstractServerApi.ServerData(
                serializer.serialize(plugin.getServer().getConfiguration().getMotd()),
                plugin.getServer().getBoundAddress().getPort(),
                plugin.getServer().getVersion().getVersion(),
                plugin.getServer().getConfiguration().getShowMaxPlayers(),
                plugin.getServer().getConfiguration().isOnlineMode(),
                true,
                true,
                false,
                true,
                AbstractServerApi.ServerData.ServerType.VELOCITY
        );
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
