package de.blitzdose.serverctrl.common.web.parser;

import org.json.JSONObject;

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
}