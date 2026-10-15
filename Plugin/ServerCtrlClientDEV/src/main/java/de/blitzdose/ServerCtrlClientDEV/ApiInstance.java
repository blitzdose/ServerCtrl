package de.blitzdose.ServerCtrlClientDEV;

import de.blitzdose.serverctrl.common.web.parser.PathParser;
import de.blitzdose.serverctrl.embedded.models.Player;
import de.blitzdose.serverctrl.embedded.models.ServerData;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

public class ApiInstance extends de.blitzdose.serverctrl.embedded.instance.ApiInstance {
    @Override
    public void sendMessage(String message) {
        System.out.println("API MESSAGE: " + message);
    }

    @Override
    public void shutdownServer() {
        System.out.println("API CALL: Shutdown server");
    }

    @Override
    public void reloadServer() {
        System.out.println("API CALL: Reload server");
    }

    @Override
    public void restartServer() {
        System.out.println("API CALL: Restart server");
    }

    @Override
    public void sendCommand(String command) {
        System.out.println("API CALL: Execute Command(" + command + ")");
    }

    @Override
    public int getOnlinePlayerCount() {
        return 1;
    }

    @Override
    public List<Player> getOnlinePlayers() {
        return List.of(new Player("Chris1967", UUID.fromString("0ea509a8-5394-4563-a215-4c21283099dc"), false));
    }

    @Override
    public ServerData getServerData() {
        return new ServerData(
                "This is a MOTD",
                25565,
                "26.0.1",
                20,
               true,
                true,
                true,
                false,
                true,
                ServerData.ServerType.SPIGOT
        );
    }

    @Override
    public Properties getServerProperties() {
        Properties props = new Properties();
        try(BufferedReader is = new BufferedReader(new FileReader("server.properties"))) {
            props.load(is);
            return props;
        } catch (IOException ignored) {
            return null;
        }
    }

    @Override
    public boolean setServerProperties(Properties properties) {
        try(FileWriter writer = new FileWriter("server.properties")) {
            properties.store(writer, "#Minecraft server properties");
        } catch (IOException e) {
            return false;
        }
        return true;
    }

    @Override
    public List<String> getWorldPaths(List<UUID> worlds) {
        return List.of("./world1");
    }

    @Override
    public Map<String, UUID> getWorlds() {
        return Map.of("world1", UUID.randomUUID());
    }

    @Override
    public boolean isPluginFolder(Path path) {
        return getPluginFolder() != null && path.normalize().startsWith(getPluginFolder());
    }

    @Override
    public Path getPluginFolder() {
        return PathParser.parsePath("./plugins/ServerCtrlClient");
    }

    @Override
    public boolean isBackupFolder(Path path) {
        Path backupPath = getPluginFolder().resolve("./Backups").normalize();
        return path.startsWith(backupPath);
    }

    @Override
    public String getConsoleLogPath() {
        return "plugins/ServerCtrlClient/log/console.log";
    }
}
