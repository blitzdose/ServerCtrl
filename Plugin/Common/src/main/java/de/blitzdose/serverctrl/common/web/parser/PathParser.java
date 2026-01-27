package de.blitzdose.serverctrl.common.web.parser;

public class PathParser {
    public static String parsePath(String path, boolean file) {
        if (path == null) {
            return null;
        }
        if (path.contains("\\")) {
            return null;
        }
        path = path.replace("../", "");
        path = path.replace("/..", "");
        path = path.replace("//", "/");
        if (path.startsWith("/")) {
            path = path.replaceFirst("/", "");
        }
        if (path.isEmpty()) {
            path = "./";
        }
        if (!path.endsWith("/") && !file) {
            path = path + "/";
        }
        return path;
    }

}
