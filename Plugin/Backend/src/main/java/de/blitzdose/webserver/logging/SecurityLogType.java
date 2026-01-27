package de.blitzdose.webserver.logging;

public enum SecurityLogType {
    LOGIN_SUCCESS("[Login Successfully]"),
    LOGIN_FAIL("[Login failed]"),
    COMMAND_SEND("[Command send]"),
    DOWNLOADED_FILES("[Downloaded File(s)]"),
    UPLOADED_FILES("[Uploaded File(s)]");

    private final String s;
    SecurityLogType(String s) {
        this.s = s;
    }

    public String getTag() {
        return s;
    }
}
