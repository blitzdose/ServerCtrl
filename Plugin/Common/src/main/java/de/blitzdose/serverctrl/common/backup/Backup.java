package de.blitzdose.serverctrl.common.backup;

import org.jetbrains.annotations.Nullable;

import java.io.File;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Backup {
    public enum State {
        WAITING,
        RUNNING,
        FINISHED,
        ERROR
    }

    public enum Type {
        FULL,
        WORLD
    }

    public static class BackupState {
        public final Integer id;
        public final Type type;
        public double percentageComplete;
        public State state;
        public final String fileName;
        public final long timestamp;
        public long size = 0;

        private static final Pattern FILENAME_PATTERN = Pattern.compile(
                "^(?<id>\\d+)_(?<type>[FW])_(?<timestamp>\\d{4}-\\d{2}-\\d{2}_\\d{2}-\\d{2}-\\d{2})[.]tar[.]gz$"
        );
        private static final DateTimeFormatter TS_FORMAT =
                DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");

        public BackupState(Type type) {
            this.id = newId();
            this.type = type;
            this.percentageComplete = 0.0f;
            this.state = State.WAITING;
            this.timestamp = LocalDateTime.now().toEpochSecond(ZoneOffset.UTC);
            this.fileName = generateFilename();
        }

        private String generateFilename() {
            return String.format("%d_%s_%s.tar.gz", this.id, this.type == Type.FULL ? "F" : "W", TS_FORMAT.format(LocalDateTime.ofEpochSecond(timestamp, 0, ZoneOffset.UTC)));
        }

        public BackupState(Integer id, Type type, double percentageComplete, State state, String fileName, long timestamp, long size) {
            this.id = id;
            this.type = type;
            this.percentageComplete = percentageComplete;
            this.state = state;
            this.fileName = fileName;
            this.timestamp = timestamp;
            this.size = size;
        }

        @Nullable
        public static BackupState parseFromFile(File file) {
            Matcher m = FILENAME_PATTERN.matcher(file.getName());
            if (!m.matches()) {
                return null;
            }
            Integer id = Integer.parseInt(m.group("id"));
            char typeChar = m.group("type").charAt(0);
            Type type = Type.FULL;
            if (typeChar == 'W') {
                type = Type.WORLD;
            }
            LocalDateTime timestamp = LocalDateTime.parse(m.group("timestamp"), TS_FORMAT);
            return new BackupState(id, type, 1.0, State.FINISHED, file.getName(), timestamp.toEpochSecond(ZoneOffset.UTC), file.length());
        }

        private Integer newId() {
            return new Random().nextInt(0, Integer.MAX_VALUE);
        }
    }

    public static final Map<Integer, BackupState> backupThreads = new HashMap<>();
}
