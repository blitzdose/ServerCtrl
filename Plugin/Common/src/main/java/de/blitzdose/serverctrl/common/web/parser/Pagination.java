package de.blitzdose.serverctrl.common.web.parser;

import org.json.JSONObject;

import java.util.List;
import java.util.Map;

public record Pagination(int limit, int position) {
    public static Pagination parse(JSONObject requestJson) {
        int limit = -1;
        if (requestJson.has("limit")) {
            limit = requestJson.getInt("limit");
        }
        int position = 0;
        if (requestJson.has("position")) {
            position = requestJson.getInt("position");
        }
        return new Pagination(limit, position);
    }

    public static Pagination parse(Map<String, List<String>> queryMap) {
        int limit = -1;
        if (queryMap.containsKey("limit")) {
            limit = Integer.parseInt(queryMap.get("limit").get(0));
        }
        int position = 0;
        if (queryMap.containsKey("position")) {
            position = Integer.parseInt(queryMap.get("position").get(0));
        }
        return new Pagination(limit, position);
    }
}