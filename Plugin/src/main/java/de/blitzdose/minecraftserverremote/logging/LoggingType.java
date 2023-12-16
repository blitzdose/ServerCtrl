package de.blitzdose.minecraftserverremote.logging;

public enum LoggingType {
    LOGIN_SUCCESS("[Login Successfully]"),
    LOGIN_FAIL("[Login failed]"),
    COMMAND_SEND("[Command send]"),
    DOWNLOADED_FILES("[Downloaded File(s)]"),
    UPLOADED_FILES("[Uploaded File(s)]"),
    PLAYER_JOINED("[Player join]"),
    PLAYER_QUIT("[Player quit]");

    private final String s;
    LoggingType(String s) {
        this.s = s;
    }

    public String getTag() {
        return s;
    }
}
