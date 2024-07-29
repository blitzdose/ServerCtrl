package de.blitzdose.minecraftserverremote.web.webserver.api;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import de.blitzdose.minecraftserverremote.web.webserver.Webserver;
import io.javalin.http.Context;
import org.bukkit.Bukkit;
import org.bukkit.Server;
import org.json.JSONObject;

import java.io.*;
import java.util.Properties;

public class ServerApi {
    public static void getIcon(Context context) throws FileNotFoundException {
        File file = new File("server-icon.png");
        if (file.exists()) {
            FileInputStream inputStream = new FileInputStream(file);
            Webserver.returnImage(context, inputStream);
        } else {
            context.redirect("/view/img/unknown_server.png");
        }
    }

    public static void getName(Context context) {
        JSONObject returnJsonObject = new JSONObject();

        if (ServerCtrl.getPlugin().getConfig().contains("Webserver.servername")) {
            ServerCtrl.getPlugin().reloadConfig();
            String servername = ServerCtrl.getPlugin().getConfig().getString("Webserver.servername");
            returnJsonObject.put("success", true);
            returnJsonObject.put("servername", servername);
        } else {
            returnJsonObject.put("success", false);
        }

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void getData(Context context) throws IOException {
        JSONObject serverDataJsonObject = new JSONObject();
        Server server = ServerCtrl.getPlugin().getServer();

        BufferedReader is = new BufferedReader(new FileReader("server.properties"));
        Properties props = new Properties();
        props.load(is);
        is.close();

        serverDataJsonObject.put("motd", server.getMotd());
        serverDataJsonObject.put("port", server.getPort());
        serverDataJsonObject.put("version", server.getVersion());
        serverDataJsonObject.put("maxPlayers", server.getMaxPlayers());
        serverDataJsonObject.put("onlineMode", server.getOnlineMode());
        serverDataJsonObject.put("allowEnd", server.getAllowEnd());
        serverDataJsonObject.put("allowNether", server.getAllowNether());
        serverDataJsonObject.put("hasWhitelist", server.hasWhitelist());
        serverDataJsonObject.put("allowCommandBlock", Boolean.parseBoolean(props.getProperty("enable-command-block")));

        JSONObject returnObject = new JSONObject();
        returnObject.put("success", true);
        returnObject.put("data", serverDataJsonObject);

        Webserver.returnJson(context, returnObject);
    }

    public static void getSettings(Context context) throws IOException {
        JSONObject returnJsonObject = new JSONObject();

        BufferedReader is = new BufferedReader(new FileReader("server.properties"));
        Properties props = new Properties();
        props.load(is);
        is.close();

        if (props.isEmpty()) {
            returnJsonObject.put("success", false);
            Webserver.returnJson(context, returnJsonObject);
            return;
        }

        JSONObject data = new JSONObject();

        for (Object keyObject : props.keySet()) {
            String key = (String) keyObject;
            String value = props.getProperty(key);
            data.put(key, value);
        }

        returnJsonObject.put("success", true);
        returnJsonObject.put("data", data);

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void setName(Context context) {
        JSONObject newServerName = new JSONObject(context.body());
        JSONObject returnJsonObject = new JSONObject();

        if (newServerName.has("servername")) {
            ServerCtrl.getPlugin().getConfig().set("Webserver.servername", newServerName.getString("servername"));
            ServerCtrl.getPlugin().saveConfig();
            returnJsonObject.put("success", true);
        } else {
            returnJsonObject.put("success", false);
        }

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void setSettings(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);

        JSONObject data = new JSONObject(context.body());

        Properties props = new Properties();
        for (String key : data.keySet()) {
            props.setProperty(key, data.getString(key));
        }

        try {
            FileWriter writer = new FileWriter("server.properties");
            props.store(writer, "#Minecraft server properties");
            writer.close();
        } catch (IOException e) {
            returnJsonObject.put("success", false);
        }

        Webserver.returnJson(context, returnJsonObject);
    }

    public static void stop(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);

        Bukkit.getScheduler().scheduleSyncDelayedTask(ServerCtrl.getPlugin(), () -> Bukkit.getServer().shutdown(), 20L);
    }

    public static void restart(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);

        Bukkit.getScheduler().scheduleSyncDelayedTask(ServerCtrl.getPlugin(), () -> Bukkit.getServer().spigot().restart(), 20L);
    }

    public static void reload(Context context) {
        JSONObject returnJsonObject = new JSONObject();
        returnJsonObject.put("success", true);
        Webserver.returnJson(context, returnJsonObject);

        Bukkit.getScheduler().scheduleSyncDelayedTask(ServerCtrl.getPlugin(), () -> Bukkit.getServer().reload(), 20L);
    }
}
