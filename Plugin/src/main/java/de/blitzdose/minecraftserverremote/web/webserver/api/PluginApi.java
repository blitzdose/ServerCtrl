package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import de.blitzdose.minecraftserverremote.crypt.CertManager;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import org.bouncycastle.operator.OperatorCreationException;
import org.bukkit.configuration.file.FileConfiguration;
import org.json.JSONObject;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.security.KeyStore;

public class PluginApi {
    public static void getSettings(Context context) {
        JSONObject returnJsonObject = new JSONObject();

        FileConfiguration config = ServerCtrl.getPlugin().getConfig();
        JSONObject webserverJson = new JSONObject();

        webserverJson.put("Port", config.getInt("Webserver.port"));
        webserverJson.put("Https", config.getBoolean("Webserver.https"));
        returnJsonObject.put("Webserver", webserverJson);
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);
    }

    public static void setSettings(Context context) {
        String port = context.formParam("port");
        String https = context.formParam("https");

        JSONObject returnJsonObject = new JSONObject();

        try {
            FileConfiguration config = ServerCtrl.getPlugin().getConfig();
            config.set("Webserver.port", Integer.parseInt(port));
            config.set("Webserver.https", Boolean.parseBoolean(https));

            ServerCtrl.getPlugin().saveConfig();

            returnJsonObject.put("success", true);
        } catch (Exception e) {
            returnJsonObject.put("success", false);
        }

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void setCertificate(Context context) {
        JSONObject returnJsonObject = new JSONObject();

        if (!context.uploadedFiles("cert").isEmpty() && !context.uploadedFiles("certKey").isEmpty()) {
            UploadedFile certFile = context.uploadedFiles("cert").get(0);
            UploadedFile certKeyFile = context.uploadedFiles("certKey").get(0);

            try {
                InputStream certFileInputstream = certFile.content();
                InputStream keyFileInputstream = certKeyFile.content();

                byte[] cert = certFileInputstream.readAllBytes();
                byte[] privKey = keyFileInputstream.readAllBytes();

                certFileInputstream.close();
                keyFileInputstream.close();

                KeyStore keyStore = CertManager.keystoreFromCertificate(cert, privKey);
                char[] pwdArray = "2-X>5h5^-!/'c(ELoT;)8O7I=-I<NMs)/{t8e~#0754>l=4".toCharArray();

                try (FileOutputStream fos = new FileOutputStream("plugins/ServerCtrl/cert.jks")) {
                    keyStore.store(fos, pwdArray);
                }
            } catch (Exception e) {
                returnJsonObject.put("success", false);
                Webserver.returnJson(context, returnJsonObject);
                return;
            }

            returnJsonObject.put("success", true);
            Webserver.returnJson(context, returnJsonObject);
            return;
        }

        returnJsonObject.put("success", false);
        Webserver.returnJson(context, returnJsonObject);
    }

    public static void generateCertificate(Context context) {
        JSONObject requestJson = new JSONObject(context.body());
        JSONObject returnJson = new JSONObject();

        String name = requestJson.getString("name");
        try {
            CertManager.generateAndSaveSelfSignedCertificate(name, "plugins/ServerCtrl/cert.jks", "plugins/ServerCtrl/RootCA.cer");
        } catch (GeneralSecurityException | IOException | OperatorCreationException e) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }
}
