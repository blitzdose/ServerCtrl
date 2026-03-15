package de.blitzdose.serverctrl.embedded.models;

import java.util.UUID;

public class Player {
    static private final String API_HEAD_LINK = "https://api.mineatar.io/face/";

    private final String name;
    private final UUID uuid;
    private final boolean isOp;
    private final String textureLink;

    public Player(String name, UUID uuid, boolean isOp) {
        this.name = name;
        this.uuid = uuid;
        this.isOp = isOp;
        this.textureLink = API_HEAD_LINK + this.uuid.toString().replaceAll("-", "") + "?scale=50";
    }

    public String getName() {
        return name;
    }

    public UUID getUuid() {
        return uuid;
    }

    public boolean isOp() {
        return isOp;
    }

    public String getTextureLink() {
        return textureLink;
    }
}