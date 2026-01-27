package de.blitzdose.serverctrl.embedded.api;

import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.instance.ApiInstance;
import de.blitzdose.serverctrl.embedded.models.Player;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;

public class PlayerApiImpl {

    private final ApiInstance instance;

    public PlayerApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    public WebsocketResponse getPlayerCount() {
        return new WebsocketResponse(true, instance.getOnlinePlayerCount());
    }

    public WebsocketResponse getOnline() {
        JSONArray data = new JSONArray();
        List<Player> players = instance.getOnlinePlayers();
        for (Player player : players) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("uuid", player.getUuid().toString());
            jsonObject.put("name", player.getName());
            jsonObject.put("textureLink", player.getTextureLink());
            jsonObject.put("isOp", player.isOp());
            data.put(jsonObject);
        }

        return new WebsocketResponse(true, data);
    }
}
