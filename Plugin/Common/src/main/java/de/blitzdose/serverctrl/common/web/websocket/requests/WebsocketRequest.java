package de.blitzdose.serverctrl.common.web.websocket.requests;

import org.jetbrains.annotations.Nullable;
import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.Array;
import java.util.List;
import java.util.Random;

public record WebsocketRequest(RequestMethod method, Object data, long identifier) {
    public WebsocketRequest(RequestMethod method, @Nullable Object data) {
        this(method, data, new Random().nextLong());
    }

    public WebsocketRequest(RequestMethod method, @Nullable Object data, long identifier) {
        this.method = method;
        this.data = data != null ? data : new JSONObject();
        this.identifier = identifier;
    }

    public <T> T data(Class<T> clazz) {
        return clazz.cast(data);
    }

    @SuppressWarnings("unchecked")
    public <T> T[] dataAsArray(Class<T> clazz) {
        List<Object> array = ((JSONArray) data).toList();
        return array
                .stream()
                .map(clazz::cast)
                .toList()
                .toArray((T[]) Array.newInstance(clazz, array.size()));
    }

    public String serialize() {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("method", this.method.toString());
        jsonObject.put("data", this.data);
        jsonObject.put("identifier", identifier);
        return jsonObject.toString();
    }

    public static WebsocketRequest deserialize(byte[] data) {
        String dataStr = new String(data);
        JSONObject jsonObject = new JSONObject(dataStr);

        return new WebsocketRequest(
                RequestMethod.valueOf(jsonObject.getString("method")),
                jsonObject.get("data"),
                jsonObject.getLong("identifier")
        );
    }
}
