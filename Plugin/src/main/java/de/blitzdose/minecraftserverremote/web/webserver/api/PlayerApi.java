package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import io.javalin.http.Context;
import org.bukkit.Bukkit;
import org.bukkit.entity.Player;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class PlayerApi {

    static private final String API_HEAD_LINK = "https://crafatar.com/avatars/";

    public static void getOnline(Context context) {
        JSONObject requestJson = new JSONObject(context);
        int limit = -1;
        if (requestJson.has("limit")) {
            limit = requestJson.getInt("limit");
        }
        int position = 0;
        if (requestJson.has("position")) {
            position = requestJson.getInt("position");
        }

        JSONArray jsonArray = new JSONArray();
        List<Player> players = new ArrayList<>(Bukkit.getServer().getOnlinePlayers());

        for (int i=position; i<(limit == -1 ? players.size() : limit + position); i++) {
            if (i >= players.size()) {
                break;
            }
            Player player = players.get(i);

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
        returnJson.put("count", Bukkit.getOnlinePlayers().size());
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }
}
