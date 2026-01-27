package de.blitzdose.serverctrl.embedded.models;

public record AbstractFile(String name, long size, boolean isFile, long lastModified, String path) {
    public boolean isDirectory() {
        return !isFile;
    }
}