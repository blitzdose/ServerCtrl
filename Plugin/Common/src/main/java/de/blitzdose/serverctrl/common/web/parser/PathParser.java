package de.blitzdose.serverctrl.common.web.parser;

import java.nio.file.Path;

public class PathParser {
    public static String parsePath(String path, boolean file) {
        if (path == null) {
            return null;
        }
        path = path
                .replace("\0", "")
                .replace('\\', '/')
                .replace(":", "")
                .replaceAll("/+", "/");

        String clean = Path.of("/", path).normalize().toString().replace('\\', '/');

        String result = "." + clean;
        if (!file && !result.endsWith("/")) {
            result += "/";
        }
        return result;
    }

}
