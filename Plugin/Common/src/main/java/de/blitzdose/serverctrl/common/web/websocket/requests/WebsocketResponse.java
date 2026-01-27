package de.blitzdose.serverctrl.common.web.websocket.requests;

import org.jetbrains.annotations.Nullable;
import org.json.JSONObject;

import java.util.Objects;
import java.util.Random;

public final class WebsocketResponse {
    private final boolean success;
    private final Object data;
    private long identifier;

    public WebsocketResponse(boolean success, @Nullable Object data) {
        this(success, data, new Random().nextLong());
    }

    public WebsocketResponse(boolean success, @Nullable Object data, long identifier) {
        this.success = success;
        this.data = data != null ? data : new JSONObject();
        this.identifier = identifier;
    }

    public void setIdentifier(long identifier) {
        this.identifier = identifier;
    }

    public String serialize() {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("success", success);
        jsonObject.put("data", data);
        jsonObject.put("identifier", identifier);
        return jsonObject.toString();
    }

    public static WebsocketResponse deserialize(byte[] data) {
        String dataStr = new String(data);
        JSONObject jsonObject = new JSONObject(dataStr);
        return new WebsocketResponse(jsonObject.getBoolean("success"), jsonObject.get("data"), jsonObject.getLong("identifier"));
    }

    public boolean success() {
        return success;
    }

    public <T> T data(Class<T> clazz) {
        return clazz.cast(data);
    }

    public long identifier() {
        return identifier;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (WebsocketResponse) obj;
        return this.success == that.success &&
                Objects.equals(this.data, that.data) &&
                this.identifier == that.identifier;
    }

    @Override
    public int hashCode() {
        return Objects.hash(success, data, identifier);
    }

    @Override
    public String toString() {
        return "WebsocketResponse[" +
                "success=" + success + ", " +
                "data=" + data + ", " +
                "identifier=" + identifier + ']';
    }

}
