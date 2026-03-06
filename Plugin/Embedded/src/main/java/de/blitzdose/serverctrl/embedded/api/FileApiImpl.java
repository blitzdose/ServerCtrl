package de.blitzdose.serverctrl.embedded.api;

import com.google.gson.Gson;
import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.web.parser.Pagination;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.serverctrl.embedded.instance.ApiInstance;
import de.blitzdose.serverctrl.embedded.models.AbstractFile;
import de.blitzdose.serverctrl.embedded.websocket.BackendTrustManager;
import kotlin.Pair;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.TrustManager;
import java.io.*;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

public class FileApiImpl {

    private final ApiInstance instance;

    public FileApiImpl(ApiInstance instance) {
        this.instance = instance;
    }

    public WebsocketResponse listFiles(JSONObject data) {
        Pagination pagination = Pagination.parse(data);
        String path = data.getString("path");

        if (isInvalidFile(path)) {
            return new WebsocketResponse(false, null);
        }

        File dir = new File(path);
        if (!dir.exists() || !dir.isDirectory()) {
            return new WebsocketResponse(false, null);
        }

        File[] files = dir.listFiles();
        if (files == null) {
            return new WebsocketResponse(false, null);
        }

        List<AbstractFile> abstractFiles =  Arrays.stream(files).map(file -> new AbstractFile(
                file.getName(),
                file.length(),
                file.isFile(),
                file.lastModified(),
                file.getPath()
        )).toList();

        JSONArray filesArray = new JSONArray();

        List<AbstractFile> filesInDirSorted = abstractFiles.stream().sorted((file, t1) -> {
            if (file.isDirectory() && t1.isFile()) {
                return -1;
            }
            if (file.isFile() && t1.isDirectory()) {
                return 1;
            }
            return file.name().toLowerCase().compareTo(t1.name().toLowerCase());
        }).toList();

        for (int i= pagination.position(); i<(pagination.limit() == -1 ? filesInDirSorted.size() : pagination.limit() + pagination.position()); i++) {
            if (i >= filesInDirSorted.size()) {
                break;
            }
            AbstractFile file = filesInDirSorted.get(i);
            if (instance.isPluginFolder(file.path())) {
                continue;
            }
            filesArray.put(new JSONObject(new Gson().toJson(file)));
        }

        return new WebsocketResponse(true, filesArray);
    }

    public WebsocketResponse countFiles(String path) {
        if (isInvalidFile(path)) {
            return new WebsocketResponse(false, null);
        }

        File file = new File(path);
        if (file.isDirectory()) {
            File[] fileArray = file.listFiles();
            if (fileArray != null) {
                int count = fileArray.length;
                return new WebsocketResponse(true, count);
            }
        }

        return new WebsocketResponse(false, null);
    }


    private Pair<SSLContext, SSLParameters> sslContext() {
        // Initialize SSL context with our trust manager
        SSLContext sslContext;
        try {
            sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, new TrustManager[]{ new BackendTrustManager(CertManager.Converter.X509Certificate.fromPEM(instance.getProvisioningCACert())) }, new java.security.SecureRandom());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // Disable hostname verification
        SSLParameters sslParams = new SSLParameters();
        sslParams.setEndpointIdentificationAlgorithm("HTTPS");

        return new Pair<>(sslContext, sslParams);
    }

    public WebsocketResponse downloadFile(JSONObject data) {
        String path = data.getString("path");
        String transferID = data.getString("transferID");
        String domain = instance.getProvisioningBackendURI();
        String authToken = instance.getProvisioningAuthToken();

        if (isInvalidFile(path) && !isBackupFolder(path)) {
            return new WebsocketResponse(false, null);
        }

        File file = new File(path);
        FileInputStream inputStream;

        try {
            //noinspection resource
            inputStream = new FileInputStream(file);
        } catch (FileNotFoundException e) {
            return new WebsocketResponse(false, null);
        }

        new Thread(() -> {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(domain + "/api/files/internal-upload/" + transferID + "?name=" + file.getName() + "&size=" + file.length()))
                    .header("Authorization", "Bearer " + authToken)
                    .POST(HttpRequest.BodyPublishers.ofInputStream(() -> inputStream))
                    .build();
            try {
                Pair<SSLContext, SSLParameters> sslContext = sslContext();

                try (HttpClient httpClient = HttpClient
                        .newBuilder()
                        .sslContext(sslContext.getFirst())
                        .sslParameters(sslContext.getSecond())
                        .build()) {
                    httpClient.send(request, HttpResponse.BodyHandlers.discarding());
                }
            } catch (IOException | InterruptedException ignored) {

            } finally {
                try {
                    inputStream.close();
                } catch (IOException ignored) { }
            }
        }).start();
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse createFile(String path) {
        if (instance.isPluginFolder(path)) {
            return new WebsocketResponse(false, null);
        }

        File file = new File(path);
        boolean success;
        try {
            success = file.createNewFile();
        } catch (IOException e) {
            success = false;
        }
        return new WebsocketResponse(success, null);
    }


    public WebsocketResponse deleteFile(String path) {
        if (isInvalidFile(path)) {
            return new WebsocketResponse(false, null);
        }

        File file = new File(path);

        if (file.isDirectory()) {
            try {
                FileUtils.deleteDirectory(file);
            } catch (IOException e) {
                return new WebsocketResponse(false, null);
            }
        } else {
            try {
                FileUtils.delete(file);
            } catch (IOException e) {
                return new WebsocketResponse(false, null);
            }
        }

        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse renameFile(JSONObject data) {
        String path = data.getString("path");
        String newPath = data.getString("newPath");

        if (isInvalidFile(path) || instance.isPluginFolder(newPath)) {
            return new WebsocketResponse(false, null);
        }

        File file = new File(path);
        boolean success = file.renameTo(new File(newPath));

        return new WebsocketResponse(success, null);
    }


    public WebsocketResponse extractFile(String path) {
        File file = new File(path);

        if (isInvalidFile(path)) {
            return new WebsocketResponse(false, null);
        }

        if (FilenameUtils.getExtension(file.getName()).equalsIgnoreCase("gz")) {
            try(GzipCompressorInputStream gzIn = new GzipCompressorInputStream(new BufferedInputStream(new FileInputStream(file)))) {
                try(OutputStream out = Files.newOutputStream(Paths.get(file.getAbsolutePath().substring(0, file.getAbsolutePath().lastIndexOf("."))))) {
                    IOUtils.copyLarge(gzIn, out);
                    out.close();
                    gzIn.close();
                } catch (IOException e) {
                    return new WebsocketResponse(false, null);
                }

            } catch (IOException e) {
                return new WebsocketResponse(false, null);
            }
        } else {
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
                            return new WebsocketResponse(false, null);
                        }
                    } else {
                        File parent = f.getParentFile();
                        if (!parent.isDirectory() && !parent.mkdirs()) {
                            return new WebsocketResponse(false, null);
                        }
                        try(OutputStream out = new FileOutputStream(f)) {
                            IOUtils.copy(inputStream, out);
                        }
                    }
                }
                inputStream.close();
            } catch (IOException e) {
                return new WebsocketResponse(false, null);
            }
        }
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse createDir(String path) {
        if (instance.isPluginFolder(path)) {
            return new WebsocketResponse(false, null);
        }

        File file = new File(path);
        boolean success = file.mkdirs();
        return new WebsocketResponse(success, null);
    }

    public boolean isInvalidFile(String path) {
        File file = new File(path);
        return !file.exists() || instance.isPluginFolder(path);
    }

    public boolean isBackupFolder(String path) {
        File file = new File(path);
        return file.exists() && instance.isBackupFolder(path);
    }

    public WebsocketResponse deleteMultiple(String[] data) {
        boolean success = true;
        for (String path : data) {
            if (isInvalidFile(path)) {
                continue;
            }
            WebsocketResponse response = deleteFile(path);
            if (!response.success()) {
                success = false;
            }
        }
        return new WebsocketResponse(success, null);
    }

    public WebsocketResponse downloadMultipleFiles(JSONObject data) {
        JSONArray paths = data.getJSONArray("paths");
        String transferID = data.getString("transferID");
        String domain = instance.getProvisioningBackendURI();
        String authToken = instance.getProvisioningAuthToken();

        String pluginFolderPath = instance.getPluginFolder();

        File file = new File(pluginFolderPath + "/tmp/" + transferID + ".zip");
        if (!file.getParentFile().exists() && !file.getParentFile().mkdir()) {
            return new WebsocketResponse(false, null);
        }

        try {
            ZipFile zipFile = new ZipFile(file);
            ZipParameters zipParameters = new ZipParameters();
            zipParameters.setExcludeFileFilter(file1 -> file1.getName().equals(transferID + ".zip") || file1.getName().equals("session.lock"));

            for (int i=0; i<paths.length(); i++) {
                String path = paths.getString(i);
                if (isInvalidFile(path)) {
                    continue;
                }
                File sourceFile = new File(path);
                if (instance.isPluginFolder(sourceFile.getPath())) {
                    continue;
                }
                if (sourceFile.isDirectory()) {
                    zipFile.addFolder(sourceFile, zipParameters);
                } else {
                    zipFile.addFile(sourceFile, zipParameters);
                }
            }

            zipFile.close();
        } catch (IOException e) {
            return new WebsocketResponse(false, null);
        }

        FileInputStream inputStream;
        try {
            inputStream = new FileInputStream(file);
        } catch (FileNotFoundException e) {
            return new WebsocketResponse(false, null);
        }

        new Thread(() -> {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(domain + "/api/files/internal-upload/" + transferID + "?name=" + transferID + ".zip&size=" + file.length()))
                    .header("Authorization", "Bearer " + authToken)
                    .POST(HttpRequest.BodyPublishers.ofInputStream(() -> inputStream))
                    .build();
            try {
                Pair<SSLContext, SSLParameters> sslContext = sslContext();

                try (HttpClient httpClient = HttpClient
                        .newBuilder()
                        .sslContext(sslContext.getFirst())
                        .sslParameters(sslContext.getSecond())
                        .build()) {
                    httpClient.send(request, HttpResponse.BodyHandlers.discarding());
                }
            } catch (IOException | InterruptedException ignored) {

            } finally {
                try {
                    inputStream.close();
                } catch (IOException ignored) { }
            }
        }).start();
        return new WebsocketResponse(true, null);
    }

    public WebsocketResponse uploadFile(JSONObject data) {
        String transferID = data.getString("transferID");
        String domain = instance.getProvisioningBackendURI();
        String authToken = instance.getProvisioningAuthToken();
        String path = data.getString("path");

        if (instance.isPluginFolder(path)) {
            return new WebsocketResponse(false, null);
        }

        File file = new File(path);

        new Thread(() -> {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(domain + "/api/files/internal-download/" + transferID))
                    .header("Authorization", "Bearer " + authToken)
                    .GET()
                    .build();

            try {
                Pair<SSLContext, SSLParameters> sslContext = sslContext();

                try (HttpClient httpClient = HttpClient
                        .newBuilder()
                        .sslContext(sslContext.getFirst())
                        .sslParameters(sslContext.getSecond())
                        .build()) {
                    httpClient.send(request, HttpResponse.BodyHandlers.ofFile(file.toPath()));
                }

            } catch (IOException | InterruptedException ignored) {

            }
        }).start();
        return new WebsocketResponse(true, null);
    }
}
