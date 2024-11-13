package de.blitzdose.serverctrl.common.web.api;

import de.blitzdose.serverctrl.common.crypt.CertManager;
import de.blitzdose.serverctrl.common.web.Webserver;
import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import org.bouncycastle.operator.OperatorCreationException;
import org.json.JSONObject;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.security.KeyStore;

public class PluginApi {
    public static void getSettings(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        JSONObject webserverJson = new JSONObject();

        webserverJson.put("Port", Webserver.abstractPluginApi.getPort());
        webserverJson.put("Https", Webserver.abstractPluginApi.isHTTPS());
        returnJsonObject.put("Webserver", webserverJson);
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);
    }

    public static void setSettings(Context context) {
        String port = context.formParam("port");
        String https = context.formParam("https");

        JSONObject returnJsonObject = new JSONObject();

        try {
            Webserver.abstractPluginApi.setPort(Integer.parseInt(port));
            Webserver.abstractPluginApi.setHTTPS(Boolean.parseBoolean(https));

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

                try (FileOutputStream fos = new FileOutputStream(Webserver.abstractPluginApi.getKeystorePath())) {
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
            CertManager.generateAndSaveSelfSignedCertificate(name, Webserver.abstractPluginApi.getKeystorePath(), Webserver.abstractPluginApi.getRootCAPath());
        } catch (GeneralSecurityException | IOException | OperatorCreationException e) {
            returnJson.put("success", false);
            Webserver.returnJson(context, returnJson);
            return;
        }

        returnJson.put("success", true);
        Webserver.returnJson(context, returnJson);
    }
}
