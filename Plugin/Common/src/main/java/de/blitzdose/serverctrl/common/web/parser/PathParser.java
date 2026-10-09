package de.blitzdose.serverctrl.common.web.parser;

import org.jetbrains.annotations.Nullable;

import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;

public class PathParser {
    public static Path parsePath(String path) {
        return parsePath(Paths.get("./"), path);
    }

    public static @Nullable Path parsePath(Path base, String path) {
        if (path == null) {
            return null;
        }
        if (path.matches("^[A-Za-z]:[\\\\/].*")) {
            return null;
        }
        path = path.replaceFirst("^[\\\\/]+", "");

        final Path userPath;
        try {
            userPath = Paths.get(path);
        } catch (InvalidPathException e) {
            return null;
        }

        if (userPath.isAbsolute()) {
            return null;
        }

        base = base.toAbsolutePath().normalize();
        Path candidate = base.resolve(userPath).normalize();

        if (!candidate.startsWith(base)) {
            return null;
        }

        return candidate;
    }

    public static String toRelativePath(Path path, Path base) {
        Path absoluteBase = base.toAbsolutePath().normalize();
        Path absolutePath = path.toAbsolutePath().normalize();

        if (!absolutePath.startsWith(absoluteBase)) {
            throw new IllegalArgumentException("Path is outside the base directory");
        }

        return "/" + absoluteBase.relativize(absolutePath)
                .toString()
                .replace('\\', '/');
    }
}
