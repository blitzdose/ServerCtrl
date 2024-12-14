package de.blitzdose.serverctrl.standalone.impl.api;

import de.blitzdose.serverctrl.common.web.api.AbstractFileApi;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.bukkit.plugin.Plugin;

import java.io.*;
import java.util.Arrays;
import java.util.List;

public class FileApiImpl extends AbstractFileApi {

    private final Plugin plugin;

    public FileApiImpl(Plugin plugin) {
        this.plugin = plugin;
    }

    @Override
    public boolean isPluginFolder(String path) {
        return path.startsWith("plugins\\ServerCtrl") || path.startsWith("plugins/ServerCtrl");
    }

    @Override
    public List<AbstractFile> listFiles(String system, String path) {
        File dir = new File(path);
        if (!dir.exists() || !dir.isDirectory()) {
            return null;
        }

        File[] files = dir.listFiles();
        if (files == null) {
            return null;
        }

        return Arrays.stream(files).map(file -> new AbstractFile(file.getName(), file.length(), file.isDirectory() ? 1 : 0, file.lastModified(), file.getPath())).toList();
    }

    @Override
    public List<AbstractFile> getTempFiles(String system) {
        return listFiles(system, "plugins/ServerCtrl/tmp");
    }

    @Override
    public String createTempZip(String system, String path, String token, List<String> names) {
        File file = new File("plugins/ServerCtrl/tmp/" + token + ".zip");
        file.getParentFile().mkdir();

        try {
            ZipFile zipFile = new ZipFile(file);
            ZipParameters zipParameters = new ZipParameters();
            zipParameters.setExcludeFileFilter(file1 -> file1.getName().equals(token + ".zip") || file1.getName().equals("session.lock"));

            for (String name : names) {
                File sourceFile = new File(path + name);
                if (isPluginFolder(sourceFile.getPath())) {
                    continue;
                }
                if (sourceFile.isDirectory()) {
                    zipFile.addFolder(sourceFile, zipParameters);
                } else {
                    zipFile.addFile(sourceFile, zipParameters);
                }
            }

            zipFile.close();

            return file.getPath();
        } catch (IOException e) {
            return null;
        }
    }

    @Override
    public AbstractFile getFile(String system, String path) {
        File file = new File(path);
        return new AbstractFile(file.getName(), file.length(), file.isDirectory() ? 1 : 0, file.lastModified(), file.getPath());
    }

    @Override
    public BufferedInputStream readFileAsStream(String system, String path) throws FileNotFoundException {
        return new BufferedInputStream(new FileInputStream(path));
    }

    @Override
    public void writeFileAsStream(String system, String path, InputStream inputStream) throws IOException {
        File file = new File(path);
        FileUtils.copyInputStreamToFile(inputStream, file);
    }

    @Override
    public boolean createFile(String system, String path) {
        File file = new File(path);
        try {
            return file.createNewFile();
        } catch (IOException e) {
            return false;
        }
    }

    @Override
    public boolean deleteFile(String system, String path) {
        File file = new File(path);
        return file.delete();
    }

    @Override
    public boolean renameFile(String system, String path, String newPath) {
        File file = new File(path);
        return file.renameTo(new File(newPath));
    }

    @Override
    public boolean extractFile(String system, String path) {
        File file = new File(path);

        try(BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(file))) {

            ArchiveInputStream<? extends ArchiveEntry> inputStream = new ArchiveStreamFactory()
                    .createArchiveInputStream(bufferedInputStream);
            ArchiveEntry entry;
            while ((entry = inputStream.getNextEntry()) != null) {
                if (!inputStream.canReadEntryData(entry)) {
                    continue;
                }

                String name = path.substring(0, path.lastIndexOf("/")+1) + entry.getName();
                File f = new File(name);
                if (entry.isDirectory()) {
                    if (!f.isDirectory() && !f.mkdirs()) {
                        throw new IOException("Failed to create directory: " + name);
                    }
                } else {
                    File parent = f.getParentFile();
                    if (!parent.isDirectory() && !parent.mkdirs()) {
                        throw new IOException("Failed to create directory: " + name);
                    }
                    try(OutputStream out = new FileOutputStream(f)) {
                        IOUtils.copy(inputStream, out);
                    }
                }
            }
            inputStream.close();
        } catch (ArchiveException | IOException e) {
            return false;
        }

        return true;
    }

    @Override
    public boolean createDirs(String system, String path) {
        File file = new File(path);
        return file.mkdirs();
    }


    @Override
    public boolean isValidFile(String system, String path) {
        File file = new File(path);
        return file.exists() && !isPluginFolder(path);
    }

    @Override
    public List<String> getEditableFiles(String system) {
        return plugin.getConfig().getStringList("Webserver.editable-files");
    }

    @Override
    public void setEditableFiles(String system, List<String> editableFiles) {
        plugin.getConfig().set("Webserver.editable-files", editableFiles);
        plugin.saveConfig();
        plugin.reloadConfig();
    }
}
