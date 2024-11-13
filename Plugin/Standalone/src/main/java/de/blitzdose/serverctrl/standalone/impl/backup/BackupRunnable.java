package de.blitzdose.serverctrl.standalone.impl.backup;

import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveOutputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorOutputStream;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class BackupRunnable implements Runnable {

    private final int id;
    private final List<String> paths;

    public BackupRunnable(List<String> paths, int id) {
        this.id = id;
        this.paths = paths;
    }

    @Override
    public void run() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");

        TarArchiveOutputStream tOut = null;

        File backupDir = Paths.get("plugins", "ServerCtrl", "Backups").toFile();
        if (!backupDir.exists()) {
            backupDir.mkdir();
        }

        try (OutputStream fOut = Files.newOutputStream(Paths.get("plugins", "ServerCtrl", "Backups", id + "_" + now.format(formatter) + ".tar.gz")); BufferedOutputStream buffOut = new BufferedOutputStream(fOut); GzipCompressorOutputStream gzOut = new GzipCompressorOutputStream(buffOut)) {
            tOut = new TarArchiveOutputStream(gzOut);

            for (String path : paths) {
                File file = new File(path);
                addFileToTarGz(tOut, file.getPath(), file.getParent());
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                assert tOut != null;
                tOut.finish();
                tOut.close();
            } catch (IOException ignore) {}
        }
    }

    private void addFileToTarGz(TarArchiveOutputStream tOut, String path, String base) throws IOException {
        File f = new File(path);
        String entryName = base + File.separatorChar + f.getName();
        TarArchiveEntry tarEntry = new TarArchiveEntry(f, entryName);
        tOut.putArchiveEntry(tarEntry);
        if (f.isFile()) {
            IOUtils.copy(new FileInputStream(f), tOut);
            tOut.closeArchiveEntry();
        } else {
            tOut.closeArchiveEntry();
            File[] children = f.listFiles();
            if (children != null) {
                for (File child : children) {
                    addFileToTarGz(tOut, child.getAbsolutePath(), entryName);
                }
            }
        }
    }
}
