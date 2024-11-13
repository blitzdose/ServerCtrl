package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.web.Webserver;
import io.javalin.http.Context;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;

public class PlayerApi {

    static private final String API_HEAD_LINK = "https://crafatar.com/avatars/";

    public static void getOnline(Context context) {
        JSONObject requestJson = new JSONObject(context.body());
        int limit = -1;
        if (requestJson.has("limit")) {
            limit = requestJson.getInt("limit");
        }
        int position = 0;
        if (requestJson.has("position")) {
            position = requestJson.getInt("position");
        }

        JSONArray jsonArray = new JSONArray();
        List<AbstractPlayerApi.Player> players = Webserver.abstractPlayerApi.getOnlinePlayer(context.pathParam("system"));

        for (int i=position; i<(limit == -1 ? players.size() : limit + position); i++) {
            if (i >= players.size()) {
                break;
            }
            AbstractPlayerApi.Player player = players.get(i);

            String textureUrl = API_HEAD_LINK + player.getUniqueId().toString().replaceAll("-", "") + "?overlay";
            JSONObject playerJson = new JSONObject();

            playerJson.put("uuid", player.getUniqueId().toString());
            playerJson.put("name", player.getName());
            playerJson.put("texturelink", textureUrl);
            playerJson.put("isOp", String.valueOf(player.isOp()));

            jsonArray.put(playerJson);
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("Player", jsonArray);
        jsonObject.put("success", true);

        Webserver.returnJson(context, jsonObject);
    }

    public static void countPlayers(Context context) {
        JSONObject returnJson = new JSONObject();
        returnJson.put("count", Webserver.abstractPlayerApi.getPlayerCount(context.pathParam("system")));
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }
}
