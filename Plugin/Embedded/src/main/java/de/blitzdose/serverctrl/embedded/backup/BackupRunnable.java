package de.blitzdose.serverctrl.embedded.backup;

import de.blitzdose.serverctrl.common.backup.Backup;
import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveOutputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorOutputStream;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Path;
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

    public BackupRunnable(Path pluginFolder, List<String> paths, int id) {
        this.id = id;
        this.paths = paths;

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");
        this.tmpOutputPath = pluginFolder.resolve("./Backups/").resolve(id + "_" + now.format(formatter) + ".tar.gz.tmp").normalize();
    }

    @Override
    public void run() {
        for (String path : paths) {
            try {
                totalFileCount += Files.walk(new File(path).toPath())
                        .parallel()
                        .filter(p -> !p.toFile().isDirectory() && !p.endsWith("session.lock") && !p.getParent().startsWith(tmpOutputPath.getParent()))
                        .count();
            } catch (IOException ignored) { }
        }

        Backup.backupThreads.get(id).state = Backup.State.RUNNING;

        TarArchiveOutputStream tOut = null;

        File backupDir = tmpOutputPath.getParent().toFile();
        if (!backupDir.exists()) {
            backupDir.mkdirs();
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
                if (tOut != null) {
                    tOut.finish();
                    tOut.close();
                }
            } catch (IOException ignore) {}
        }
        File file = tmpOutputPath.toFile();
        Backup.backupThreads.get(id).size = file.length();
        file.renameTo(tmpOutputPath.getParent().resolve(Backup.backupThreads.get(id).getFileName()).toFile());
    }

    private void addFileToTarGz(TarArchiveOutputStream tOut, String path, String base) throws IOException {
        File f = new File(path);
        if (f.toPath().endsWith("session.lock") || (f.toPath().getParent() != null && f.toPath().getParent().normalize().startsWith(tmpOutputPath.getParent()))) {
            return;
        }
        String entryName = base + File.separatorChar + f.getName();
        if (base.equalsIgnoreCase(".")) {
            entryName = f.getName();
        }
        TarArchiveEntry tarEntry = new TarArchiveEntry(f, entryName);
        InputStream inputStream = null;
        try {
            if (f.isFile()) {
                tOut.putArchiveEntry(tarEntry);
                FileChannel fileChannel = FileChannel.open(f.toPath(), StandardOpenOption.READ);
                inputStream = Channels.newInputStream(fileChannel);
                IOUtils.copyLarge(inputStream, tOut, 0, tarEntry.getSize());
                tOut.closeArchiveEntry();
                inputStream.close();
                processedFileCount += 1;
                Backup.backupThreads.get(id).percentageComplete = ((double) processedFileCount / totalFileCount);
                File file = tmpOutputPath.toFile();
                Backup.backupThreads.get(id).size = file.length();
            } else {
                if (!entryName.equalsIgnoreCase(".")) {
                    tOut.putArchiveEntry(tarEntry);
                    tOut.closeArchiveEntry();
                }
                File[] children = f.listFiles();
                if (children != null) {
                    for (File child : children) {
                        addFileToTarGz(tOut, child.getAbsolutePath(), entryName);
                    }
                }
            }
        } catch (Exception e) {
            if (inputStream != null) inputStream.close();
        }
    }
}
