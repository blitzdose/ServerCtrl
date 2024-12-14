package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.logging.LoggingType;
import de.blitzdose.serverctrl.common.web.Webserver;
import de.blitzdose.serverctrl.common.web.auth.UserManager;
import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;

import static de.blitzdose.serverctrl.common.web.parser.PathParser.parsePath;

public class FilesApi {

    static Map<String, String[]> files = new HashMap<>();

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

        List<AbstractFileApi.AbstractFile> files = Webserver.abstractFileApi.listFiles(context.pathParam("system"), path);

        if (files == null) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        JSONArray filesArray = new JSONArray();

        List<AbstractFileApi.AbstractFile> filesInDirSorted = files.stream().sorted((file, t1) -> {
            if (file.isDirectory() && t1.isFile()) {
                return -1;
            }
            if (file.isFile() && t1.isDirectory()) {
                return 1;
            }
            return file.name().toLowerCase().compareTo(t1.name().toLowerCase());
        }).toList();

        for (int i=position; i<(limit == -1 ? filesInDirSorted.size() : limit + position); i++) {
            if (i >= filesInDirSorted.size()) {
                break;
            }
            AbstractFileApi.AbstractFile file = filesInDirSorted.get(i);
            if (Webserver.abstractFileApi.isPluginFolder(file.path())) {
                continue;
            }
            JSONObject fileJson = new JSONObject();
            fileJson.put("name", file.name());
            fileJson.put("size", file.size());
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

        if (Webserver.abstractFileApi.isValidFile(context.pathParam("system"), path + name)) {
            returnJson.put("success", true);
            String id = UserManager.generateNewToken();
            returnJson.put("id", id);

            String filePath = Webserver.abstractFileApi.getFile(context.pathParam("system"), path + name).path();

            files.put(id, new String[]{context.pathParam("system"), filePath});
        } else {
            returnJson.put("success", false);
        }

        Webserver.returnJson(context, returnJson);
    }

    public static void downloadFileGet(Context context) {
        removeOldDownloads(context.pathParam("system"));
        String id = context.queryParam("id");
        if (files.containsKey(id)) {
            String system = files.get(id)[0];
            String filePath = files.get(id)[1];

            AbstractFileApi.AbstractFile file = Webserver.abstractFileApi.getFile(system, filePath);
            BufferedInputStream fileStream;
            try {
                fileStream = Webserver.abstractFileApi.readFileAsStream(system, filePath);
            } catch (FileNotFoundException e) {
                Webserver.return404(context);
                return;
            }
            Webserver.returnFile(context, file.name(), file.size(), fileStream);

            Webserver.loggingSaver.addLogEntry(LoggingType.DOWNLOADED_FILES, context, filePath);
            files.remove(id);
        } else {
            Webserver.return404(context);
        }
    }

    private static void removeOldDownloads(String system) {
        List<AbstractFileApi.AbstractFile> tmpFiles = Webserver.abstractFileApi.getTempFiles(system);
        if (tmpFiles == null) {
            return;
        }
        for (AbstractFileApi.AbstractFile file : tmpFiles) {
            if (!files.containsKey(file.name().substring(0, file.name().lastIndexOf(".")))) {
                Webserver.abstractFileApi.deleteFile(system, file.path());
            }
        }
    }

    public static void uploadFile(Context context) {
        String system = context.pathParam("system");

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
            if (Webserver.abstractFileApi.isPluginFolder(path + filename)) {
                Webserver.return404(context);
                return;
            }
            try {
                Webserver.abstractFileApi.writeFileAsStream(system, path + filename, uploadedFile.content());
                context.result();
                Webserver.loggingSaver.addLogEntry(LoggingType.UPLOADED_FILES, context, path + filename);
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
        String system = context.pathParam("system");
        JSONObject returnJson = new JSONObject();

        JSONObject requestJson = new JSONObject(context.body());
        String path = parsePath(requestJson.getString("path"), false);
        String fileName = parsePath(requestJson.getString("name"), true);

        if (!Webserver.abstractFileApi.isValidFile(system, path + fileName)) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        boolean success = Webserver.abstractFileApi.extractFile(system, path + fileName);

        returnJson.put("success", success);
        Webserver.returnJson(context, returnJson);
    }

    public static void deleteFile(Context context) {
        String system = context.pathParam("system");
        JSONObject returnJson = new JSONObject();

        JSONObject requestJson = new JSONObject(context.body());
        String path = parsePath(requestJson.getString("path"), false);
        String name = parsePath(requestJson.getString("name"), true);
        boolean dir = requestJson.getBoolean("dir");

        boolean success = false;

        if (Webserver.abstractFileApi.isValidFile(system, path + name)) {
            AbstractFileApi.AbstractFile file = Webserver.abstractFileApi.getFile(system, path + name);
            if (dir) {
                success = deleteDirectory(system, file);
            } else {
                success = Webserver.abstractFileApi.deleteFile(system, file.path());
            }
        }

        returnJson.put("success", success);
        Webserver.returnJson(context, returnJson);
    }

    private static boolean deleteDirectory(String system, AbstractFileApi.AbstractFile directoryToBeDeleted) {
        List<AbstractFileApi.AbstractFile> allContents = Webserver.abstractFileApi.listFiles(system, directoryToBeDeleted.path());
        if (allContents != null) {
            for (AbstractFileApi.AbstractFile file : allContents) {
                deleteDirectory(system, file);
            }
        }
        return Webserver.abstractFileApi.deleteFile(system, directoryToBeDeleted.path());
    }

    public static void createFile(Context context) {
        String system = context.pathParam("system");

        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        String name = parsePath(jsonObject.getString("name"), true);

        boolean success = false;
        if (!Webserver.abstractFileApi.isPluginFolder(path + name)) {
            success = Webserver.abstractFileApi.createFile(system, path + name);
        }

        JSONObject jsonReturn = new JSONObject();
        jsonReturn.put("success", success);

        Webserver.returnJson(context, jsonReturn);
    }

    public static void createDir(Context context) {
        String system = context.pathParam("system");

        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        String name = parsePath(jsonObject.getString("name"), true);

        boolean success = false;
        if (!Webserver.abstractFileApi.isPluginFolder(path + name)) {
            success = Webserver.abstractFileApi.createDirs(system, path + name);
        }

        JSONObject jsonReturn = new JSONObject();
        jsonReturn.put("success", success);

        Webserver.returnJson(context, jsonReturn);
    }

    public static void renameFile(Context context) {
        String system = context.pathParam("system");

        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        String name = parsePath(jsonObject.getString("name"), true);
        String newName = parsePath(jsonObject.getString("newName"), true);


        boolean success = false;
        if (Webserver.abstractFileApi.isValidFile(system, path + name)) {
            success = Webserver.abstractFileApi.renameFile(system, path + name, path + newName);
        }

        JSONObject jsonReturn = new JSONObject();
        jsonReturn.put("success", success);

        Webserver.returnJson(context, jsonReturn);
    }

    public static void downloadMultiple(Context context) {
        JSONObject returnJson = new JSONObject();
        returnJson.put("success", true);
        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        JSONArray requestedFiles = jsonObject.getJSONArray("names");

        String token = UserManager.generateNewToken();

        List<String> names = new ArrayList<>();
        for (int i=0; i<requestedFiles.length(); i++) {
            JSONObject fileObject = requestedFiles.getJSONObject(i);
            String name = parsePath(fileObject.getString("name"), true);
            names.add(name);
        }

        String zipPath = Webserver.abstractFileApi.createTempZip(context.pathParam("system"), path, token, names);
        if (zipPath == null) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
        }

        files.put(token, new String[]{context.pathParam("system"), zipPath});
        returnJson.put("id", token);

        Webserver.returnJson(context, returnJson);
    }

    public static void deleteMultiple(Context context) {
        String system = context.pathParam("system");
        JSONObject returnJson = new JSONObject();

        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);
        JSONArray requestedFiles = jsonObject.getJSONArray("names");

        boolean success = true;

        for (int i=0; i<requestedFiles.length(); i++) {
            JSONObject fileObject = requestedFiles.getJSONObject(i);
            String name = parsePath(fileObject.getString("name"), true);

            boolean deleteSuccess;
            if (Webserver.abstractFileApi.isValidFile(system, path + name)) {
                AbstractFileApi.AbstractFile file = Webserver.abstractFileApi.getFile(system, path + name);
                if (file.isDirectory()) {
                    deleteSuccess = deleteDirectory(system, file);
                } else {
                    deleteSuccess = Webserver.abstractFileApi.deleteFile(system, file.path());
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

        List<String> editableFiles = Webserver.abstractFileApi.getEditableFiles(context.pathParam("system"));
        returnJson.put("fileExtensions", editableFiles);
        returnJson.put("success", true);

        Webserver.returnJson(context, returnJson);
    }

    public static void setEditableFiles(Context context) {
        JSONObject returnJson = new JSONObject();

        JSONObject jsonObject = new JSONObject(context.body());
        JSONArray fileExtensions = jsonObject.getJSONArray("fileExtensions");
        List<String> editableFiles = new ArrayList<>();
        for (int i=0; i<fileExtensions.length(); i++) {
            editableFiles.add(fileExtensions.getString(i));
        }

        Webserver.abstractFileApi.setEditableFiles(context.pathParam("system"), editableFiles);
        returnJson.put("success", true);

        Webserver.returnJson(context, returnJson);
    }

    public static void countFiles(Context context) {
        String system = context.pathParam("system");
        JSONObject returnJson = new JSONObject();

        JSONObject jsonObject = new JSONObject(context.body());
        String path = parsePath(jsonObject.getString("path"), false);

        AbstractFileApi.AbstractFile file = Webserver.abstractFileApi.getFile(system, path);

        if (file.isDirectory()) {
            List<AbstractFileApi.AbstractFile> files = Webserver.abstractFileApi.listFiles(system, path);
            if (files != null) {
                returnJson.put("count", files.size());
                returnJson.put("success", true);
                Webserver.returnJson(context, returnJson);
                return;
            }
        }
        returnJson.put("success", false);
        Webserver.returnJson(context, returnJson);
    }
}
