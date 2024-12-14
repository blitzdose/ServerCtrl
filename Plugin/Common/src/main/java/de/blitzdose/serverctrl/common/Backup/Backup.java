package de.blitzdose.serverctrl.common.Backup;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class Backup {
    public enum State {
        WAITING,
        RUNNING,
        FINISHED,
        ERROR
    }

    public static class BackupState {
        public Integer id;
        public double percentageComplete;
        public State state;
        private String fileName;
        public String date;
        public long timestamp;
        public long size = 0;

        public BackupState() {
            this.id = newId();
            this.percentageComplete = 0.0f;
            this.state = State.WAITING;
        }

        public BackupState(Integer id, double percentageComplete, State state, String fileName) {
            this.id = id;
            this.percentageComplete = percentageComplete;
            this.state = state;
            this.fileName = fileName;
            this.date = getDateString();
            this.timestamp = getTimestamp();
        }

        public  BackupState(Integer id, double percentageComplete, State state, String fileName, long size) {
            this.id = id;
            this.percentageComplete = percentageComplete;
            this.state = state;
            this.fileName = fileName;
            this.date = getDateString();
            this.timestamp = getTimestamp();
            this.size = size;
        }

        private Integer newId() {
            return new Random().nextInt(0, Integer.MAX_VALUE);
        }

        private String getDateString() {
            try {
                String dateStr = fileName.split("_")[1];
                String timeStr = fileName.split("_")[2].split("\\.")[0];
                DateTimeFormatter f = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");
                LocalDateTime localDateTime = LocalDateTime.from(f.parse(dateStr + "_" + timeStr));
                return localDateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm:ss"));
            } catch (Exception e) {
                return "Jan 01, 1970 00:00:00";
            }
        }

        private long getTimestamp() {
            try {
                String dateStr = fileName.split("_")[1];
                String timeStr = fileName.split("_")[2].split("\\.")[0];
                DateTimeFormatter f = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");
                LocalDateTime localDateTime = LocalDateTime.from(f.parse(dateStr + "_" + timeStr));
                return localDateTime.toEpochSecond(ZoneOffset.UTC);
            } catch (Exception e) {
                return 0;
            }
        }

        public String getFileName() {
            return fileName;
        }

        public void setFileName(String fileName) {
            this.fileName = fileName;
            this.date = getDateString();
            this.timestamp = getTimestamp();
        }
    }

    public static final Map<Integer, BackupState> backupThreads = new HashMap<>();
}
