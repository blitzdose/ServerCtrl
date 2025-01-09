package de.blitzdose.basicapiimpl.api;

import de.blitzdose.serverctrl.common.web.api.AbstractPlayerApi;
import org.bukkit.Bukkit;

import java.util.Collection;
import java.util.List;

public class PlayerApiImpl extends AbstractPlayerApi {

    @Override
    public int getPlayerCount(String system) {
        return Bukkit.getOnlinePlayers().size();
    }

    @Override
    public List<Player> getOnlinePlayer(String system) {
        Collection<? extends org.bukkit.entity.Player> onlinePlayers = Bukkit.getServer().getOnlinePlayers();
        return onlinePlayers.stream().map(player -> new Player(player.getName(), player.getUniqueId(), player.isOp())).toList();
    }
}
