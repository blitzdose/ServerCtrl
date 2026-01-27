package de.blitzdose.serverctrl.common.web.websocket;

import org.json.JSONObject;

import java.nio.charset.StandardCharsets;

public record ProvisioningPack(String name, String accessToken, String cert, String publicURL) {

    public byte[] generatePackFile() {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("name", name);
        jsonObject.put("accessToken", accessToken);
        jsonObject.put("cert", cert);
        jsonObject.put("publicURL", publicURL);
        return jsonObject.toString().getBytes(StandardCharsets.UTF_8);
    }

    public static ProvisioningPack parsePackFile(byte[] packFile) {
        JSONObject jsonObject = new JSONObject(new String(packFile, StandardCharsets.UTF_8));
        return new ProvisioningPack(jsonObject.getString("name"), jsonObject.getString("accessToken"), jsonObject.getString("cert"), jsonObject.getString("publicURL"));
    }
}
