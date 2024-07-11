package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import de.blitzdose.minecraftserverremote.logging.LoggingSaver;
import de.blitzdose.minecraftserverremote.logging.LoggingType;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import de.blitzdose.minecraftserverremote.web.webserver.auth.UserManager;
import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.bukkit.configuration.file.FileConfiguration;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

public class FilesApi {

    static Map<String, String> files = new HashMap<>();
    public static void listFiles(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject requestJson = new JSONObject(context.body());
        String path = parsePath(requestJson.getString("path"), false);
        int limit = -1;
        int position = 0;
        if (requestJson.has("limit")) {
            limit = requestJson.getInt("limit");
        }
        if (requestJson.has("position")) {
            position = requestJson.getInt("position");
        }

        File dir = new File(path);

        if (!dir.exists() || !dir.isDirectory()) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        JSONArray filesArray = new JSONArray();

        File[] filesInDir = dir.listFiles();

        List<File> filesInDirSorted = Arrays.stream(filesInDir).sorted(new Comparator<File>() {
            @Override
            public int compare(File file, File t1) {
                if (file.isDirectory() && t1.isFile()) {
                    return -1;
                }
                if (file.isFile() && t1.isDirectory()) {
                    return 1;
                }
                return file.getName().toLowerCase().compareTo(t1.getName().toLowerCase());
            }
        }).collect(Collectors.toList());

        for (int i=position; i<(limit == -1 ? filesInDirSorted.size() : limit + position); i++) {
            if (i >= filesInDirSorted.size()) {
                break;
            }
            File file = filesInDirSorted.get(i);
            if (isPluginFolder(file.getPath())) {
                continue;
            }
            JSONObject fileJson = new JSONObject();
            fileJson.put("name", file.getName());
            fileJson.put("size", file.length());
            fileJson.put("type", file.isDirectory() ? 1 : 0);

            long fileDate = file.lastModified();
            Instant date = new Date(fileDate).toInstant();
            LocalDateTime dateTime = LocalDateTime.ofInstant(date, ZoneId.systemDefault());
            JSONObject fileDateJson = new JSONObject();
            fileDateJson.put("year", dateTime.getYear());
            fileDateJson.put("month", dateTime.getMonthValue());
            fileDateJson.put("dayOfMonth", dateTime.getDayOfMonth());
            fileDateJson.put("hourOfDay", dateTime.getHour());
            fileDateJson.put("minute", dateTime.getMinute());
            fileDateJson.put("second", dateTime.getSecond());
            fileJson.put("date", fileDateJson);
            filesArray.put(fileJson);
        }

        returnJson.put("data", filesArray);
        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }

    public static void downloadFilePost(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject requestJson = new JSONObject(context.body());
        String path = parsePath(requestJson.getString("path"), false);
        String name = parsePath(requestJson.getString("name"), true);

        File file = new File(path + name);

        if (file.exists() && !isPluginFolder(file.getPath())) {
            returnJson.put("success", true);
            String id = UserManager.generateNewToken();
            returnJson.put("id", id);

            files.put(id, file.getPath());
        } else {
            returnJson.put("success", false);
        }

        Webserver.returnJson(context, returnJson);
    }

    private static String parsePath(String path, boolean file) {
        if (path == null) {
            return "?";
        }
        if (path.contains("\\")) {
            return "?";
        }
        path = path.replace("../", "");
        path = path.replace("/..", "");
        path = path.replace("//", "/");
        if (path.startsWith("/")) {
            path = path.replaceFirst("/", "");
        }
        if (path.isEmpty()) {
            path = "./";
        }
        if (!path.endsWith("/") && !file) {
            path = path + "/";
        }
        return path;
    }

    public static void downloadFileGet(Context context) {
        removeOldDownloads();
        String id = context.queryParam("id");
        if (files.containsKey(id)) {
            String filePath = files.get(id);
            Webserver.returnFile(context, filePath);
            LoggingSaver.addLogEntry(LoggingType.DOWNLOADED_FILES, context, filePath);
            files.remove(id);
        } else {
            Webserver.return404(context);
        }
    }

    private static void removeOldDownloads() {
        File tmpDir = new File("plugins/ServerCtrl/tmp");
        File[] tmpFiles = tmpDir.listFiles();
        if (tmpFiles == null) {
            return;
        }
        for (File file : tmpFiles) {
            if (!files.containsKey(file.getName().substring(0, file.getName().lastIndexOf(".")))) {
                file.delete();
            }
        }
    }

    public static void uploadFile(Context context) {
        JSONObject jsonObject = new JSONObject();
        List<UploadedFile> uploadedFiles = new ArrayList<>();
        try {
            uploadedFiles = (context.uploadedFiles());
        } catch (Exception e) {
            jsonObject.put("success", false);
            Webserver.returnJson(context, jsonObject);
        }
        String path = parsePath(context.formParam("path"), false);

        for (UploadedFile uploadedFile : uploadedFiles) {
            String filename = parsePath(uploadedFile.filename(), true);
            File file = new File(path + filename);
            if (isPluginFolder(file.getPath())) {
                Webserver.return404(context);
                return;
            }
            try {
                FileUtils.copyInputStreamToFile(uploadedFile.content(), file);
                context.result();
                LoggingSaver.addLogEntry(LoggingType.UPLOADED_FILES, context, path + filename);
            } catch (IOException e) {
                jsonObject.put("success", false);
                jsonObject.put("message", e.getMessage());
                Webserver.returnJson(context, jsonObject);
                return;
            }
        }
        jsonObject.put("success", true);
        Webserver.returnJson(context, jsonObject);
    }

    public static void extractFile(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject requestJson = new JSONObject(context.body());
        String path = parsePath(requestJson.getString("path"), false);
        String fileName = parsePath(requestJson.getString("name"), true);

        File file = new File(path + fileName);

        if (isPluginFolder(file.getPath())) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        boolean success = true;

        BufferedInputStream bufferedInputStream = null;
        try {
            bufferedInputStream = new BufferedInputStream(new FileInputStream(file));
            ArchiveInputStream<? extends ArchiveEntry> inputStream = new ArchiveStreamFactory()
                    .createArchiveInputStream(bufferedInputStream);
            ArchiveEntry entry;
            while ((entry = inputStream.getNextEntry()) != null) {
                if (!inputStream.canReadEntryData(entry)) {
                    continue;
                }

                String name = path + entry.getName();
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
            success = false;
        }

        try {
            if (bufferedInputStream != null) bufferedInputStream.close();
        } catch (IOException ignored) { }

        returnJson.put("success", success);
        Webserver.returnJson(context, returnJson);
    }

    public static void deleteFile(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject requestJson = new JSONObject(context.body());
        String path = parsePath(requestJson.getString("path"), false);
        String name = parsePath(requestJson.getString("name"), true);
        boolean dir = requestJson.getBoolean("dir");

        File file = new File(path + name);
        boolean success = false;

        if (!isPluginFolder(file.getPath())) {
            if (dir) {
                success = deleteDirectory(file);
            } else {
                success = file.delete();
            }
        }

        returnJson.put("success", success);
        Webserver.returnJson(context, returnJson);
    }

    private static boolean deleteDirectory(File directoryToBeDeleted) {
        File[] allContents = directoryToBeDeleted.listFiles();
        if (allContents != null) {
            for (File file : allContents) {
                deleteDirectory(file);
            }
        }
        return directoryToBeDeleted.delete();
    }

    public static void createFile(Context context) {
        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        String name = parsePath(jsonObject.getString("name"), true);

        File file = new File(path + name);
        boolean success = false;
        if (!isPluginFolder(file.getPath())) {
            try {
                success = file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        JSONObject jsonReturn = new JSONObject();
        jsonReturn.put("success", success);

        Webserver.returnJson(context, jsonReturn);
    }

    public static void createDir(Context context) {
        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        String name = parsePath(jsonObject.getString("name"), true);

        File file = new File(path + name);
        boolean success = false;
        if (!isPluginFolder(file.getPath())) {
            success = file.mkdirs();
        }

        JSONObject jsonReturn = new JSONObject();
        jsonReturn.put("success", success);

        Webserver.returnJson(context, jsonReturn);
    }

    public static void renameFile(Context context) {
        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        String name = parsePath(jsonObject.getString("name"), true);
        String newName = parsePath(jsonObject.getString("newName"), true);

        File file = new File(path + name);
        boolean success = false;
        if (file.exists() && !isPluginFolder(file.getPath())) {
            success = file.renameTo(new File(path + newName));
        }

        JSONObject jsonReturn = new JSONObject();
        jsonReturn.put("success", success);

        Webserver.returnJson(context, jsonReturn);
    }

    public static void downloadMultiple(Context context) {
        JSONObject returnJson = new JSONObject();
        returnJson.put("success", true);
        try {
            JSONObject jsonObject = new JSONObject(context.body());
            String path = parsePath(jsonObject.getString("path"), false);
            JSONArray requestedFiles = jsonObject.getJSONArray("names");

            String token = UserManager.generateNewToken();

            File file = new File("plugins/ServerCtrl/tmp/" + token + ".zip");
            file.getParentFile().mkdir();

            ZipFile zipFile = new ZipFile(file);

            ZipParameters zipParameters = new ZipParameters();
            zipParameters.setExcludeFileFilter(file1 -> file1.getName().equals(token + ".zip"));

            for (int i=0; i<requestedFiles.length(); i++) {
                JSONObject fileObject = requestedFiles.getJSONObject(i);
                String name = parsePath(fileObject.getString("name"), true);

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

            files.put(token, file.getPath());
            returnJson.put("id", token);


        } catch (Exception e) {
            e.printStackTrace();
            returnJson.put("success", false);
        }

        Webserver.returnJson(context, returnJson);
    }

    public static void deleteMultiple(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        JSONArray requestedFiles = jsonObject.getJSONArray("names");

        boolean success = true;

        for (int i=0; i<requestedFiles.length(); i++) {
            JSONObject fileObject = requestedFiles.getJSONObject(i);
            String name = parsePath(fileObject.getString("name"), true);

            File file = new File(path + name);
            boolean deleteSuccess;
            if (!isPluginFolder(file.getPath())) {
                if (file.isDirectory()) {
                    deleteSuccess = deleteDirectory(file);
                } else {
                    deleteSuccess = file.delete();
                }
            } else {
                deleteSuccess = false;
            }
            if (!deleteSuccess) {
                success = false;
            }
        }

        returnJson.put("success", success);
        Webserver.returnJson(context, returnJson);
    }

    public static void getEditableFiles(Context context) {
        JSONObject returnJson = new JSONObject();

        FileConfiguration config = ServerCtrl.getPlugin().getConfig();
        List<String> editableFiles = config.getStringList("Webserver.editable-files");
        returnJson.put("fileExtensions", editableFiles);
        returnJson.put("success", true);

        Webserver.returnJson(context, returnJson);
    }

    private static boolean isPluginFolder(String path) {
        return path.startsWith("plugins\\ServerCtrl") || path.startsWith("plugins/ServerCtrl");
    }

    public static void countFiles(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);

        File file = new File(path);
        if (file.isDirectory()) {
            String[] files = file.list();
            if (files != null) {
                returnJson.put("count", files.length);
                returnJson.put("success", true);
                Webserver.returnJson(context, returnJson);
                return;
            }
        }
        returnJson.put("success", false);
        Webserver.returnJson(context, returnJson);
    }
}
