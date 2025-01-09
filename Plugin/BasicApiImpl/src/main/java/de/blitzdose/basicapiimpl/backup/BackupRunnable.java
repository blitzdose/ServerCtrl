package de.blitzdose.basicapiimpl.backup;

import de.blitzdose.serverctrl.common.Backup.Backup;
import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveOutputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorOutputStream;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class BackupRunnable implements Runnable {

    private final int id;
    private final List<String> paths;
    private long totalFileCount = 0;
    private long processedFileCount = 0;
    private final Path tmpOutputPath;

    public BackupRunnable(List<String> paths, int id) {
        this.id = id;
        this.paths = paths;

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");
        this.tmpOutputPath = Paths.get("plugins", "ServerCtrl", "Backups", id + "_" + now.format(formatter) + ".tar.gz.tmp");
    }

    @Override
    public void run() {
        for (String path : paths) {
            try {
                totalFileCount += Files.walk(new File(path).toPath())
                        .parallel()
                        .filter(p -> !p.toFile().isDirectory() && !p.endsWith("session.lock") && !p.getParent().endsWith(Paths.get("plugins", "ServerCtrl", "Backups")))
                        .count();
            } catch (IOException ignored) { }
        }

        Backup.backupThreads.get(id).state = Backup.State.RUNNING;

        TarArchiveOutputStream tOut = null;

        File backupDir = Paths.get("plugins", "ServerCtrl", "Backups").toFile();
        if (!backupDir.exists()) {
            backupDir.mkdir();
        }

        Backup.backupThreads.get(id).setFileName(tmpOutputPath.getFileName().toString().replaceAll("[.]tmp$", ""));

        try (OutputStream fOut = Files.newOutputStream(tmpOutputPath); BufferedOutputStream buffOut = new BufferedOutputStream(fOut); GzipCompressorOutputStream gzOut = new GzipCompressorOutputStream(buffOut)) {
            tOut = new TarArchiveOutputStream(gzOut);
            tOut.setLongFileMode(TarArchiveOutputStream.LONGFILE_POSIX);

            for (String path : paths) {
                File file = new File(path);
                addFileToTarGz(tOut, file.getPath(), file.getParent() == null ? "." : file.getParent());
            }
            Backup.backupThreads.get(id).state = Backup.State.FINISHED;
        } catch (IOException ignored) {
            Backup.backupThreads.get(id).state = Backup.State.ERROR;
        } finally {
            try {
                assert tOut != null;
                tOut.finish();
                tOut.close();
            } catch (IOException ignore) {}
        }
        File file = tmpOutputPath.toFile();
        Backup.backupThreads.get(id).size = file.length();
        file.renameTo(Paths.get("plugins", "ServerCtrl", "Backups", Backup.backupThreads.get(id).getFileName()).toFile());
    }

    private void addFileToTarGz(TarArchiveOutputStream tOut, String path, String base) throws IOException {
        File f = new File(path);
        if (f.toPath().endsWith("session.lock") || (f.toPath().getParent() != null && f.toPath().getParent().endsWith(Paths.get("plugins", "ServerCtrl", "Backups")))) {
            return;
        }
        String entryName = base + File.separatorChar + f.getName();
        if (base.equalsIgnoreCase(".")) {
            entryName = f.getName();
        }
        TarArchiveEntry tarEntry = new TarArchiveEntry(f, entryName);
        tOut.putArchiveEntry(tarEntry);
        InputStream inputStream = null;
        try {
            if (f.isFile()) {
                FileChannel fileChannel = FileChannel.open(f.toPath(), StandardOpenOption.READ);
                inputStream = Channels.newInputStream(fileChannel);
                IOUtils.copy(inputStream, tOut);
                tOut.closeArchiveEntry();
                inputStream.close();
                processedFileCount += 1;
                Backup.backupThreads.get(id).percentageComplete = ((double) processedFileCount / totalFileCount);
                File file = tmpOutputPath.toFile();
                Backup.backupThreads.get(id).size = file.length();
            } else {
                tOut.closeArchiveEntry();
                File[] children = f.listFiles();
                if (children != null) {
                    for (File child : children) {
                        addFileToTarGz(tOut, child.getAbsolutePath(), entryName);
                    }
                }
            }
        } catch (Exception ignored) {
            if (inputStream != null) inputStream.close();
        }
    }
}
