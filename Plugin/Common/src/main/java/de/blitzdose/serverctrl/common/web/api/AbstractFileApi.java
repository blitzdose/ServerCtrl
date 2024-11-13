package de.blitzdose.serverctrl.common.web.api;

import java.io.BufferedInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public abstract class AbstractFileApi {

    public static boolean isPluginFolder(String path) {
        return path.startsWith("plugins\\ServerCtrl") || path.startsWith("plugins/ServerCtrl");
    }

    public abstract List<AbstractFile> listFiles(String system, String path);

    public abstract List<AbstractFile> getTempFiles(String system);

    public abstract String createTempZip(String system, String path, String token, List<String> names);

    public abstract AbstractFile getFile(String system, String path);

    public abstract BufferedInputStream readFileAsStream(String system, String path) throws FileNotFoundException;

    public abstract void writeFileAsStream(String system, String path, InputStream inputStream) throws IOException;

    public abstract boolean createFile(String system, String path);

    public abstract boolean deleteFile(String system, String path);

    public abstract boolean renameFile(String system, String path, String newPath);

    public abstract boolean extractFile(String system, String path);

    public abstract boolean createDirs(String system, String path);

    public abstract boolean isValidFile(String system, String path);


    public abstract List<String> getEditableFiles(String system);
    public abstract void setEditableFiles(String system, List<String> editableFiles);

    /**
     * @param type 0 = File; 1 = Directory
     */
    public record AbstractFile(String name, long size, int type, long lastModified, String path) {

        public boolean isDirectory() {
                return this.type == 1;
            }

            public boolean isFile() {
                return this.type == 0;
            }
        }
}
