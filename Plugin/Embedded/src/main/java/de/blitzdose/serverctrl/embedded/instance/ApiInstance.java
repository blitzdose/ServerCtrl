package de.blitzdose.serverctrl.embedded.instance;

import de.blitzdose.serverctrl.common.web.websocket.ProvisioningPack;
import de.blitzdose.serverctrl.embedded.models.Player;
import de.blitzdose.serverctrl.embedded.models.ServerData;
import org.apache.commons.io.filefilter.RegexFileFilter;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

public abstract class ApiInstance {

    private ProvisioningPack provisioningPack;

    abstract public void sendMessage(String message);

    public abstract List<String> configGetStringList(String key);
    public abstract String configGetString(String key);
    public abstract int configGetInt(String key);
    public abstract boolean configGetBoolean(String key);
    public abstract boolean configContains(String key);
    public abstract void configUpdate(String key, Object value);
    public abstract List<String> configGetKeys(String key);

    public abstract void shutdownServer();
    public abstract void reloadServer();
    public abstract void restartServer();

    public abstract void sendCommand(String command) throws ExecutionException, InterruptedException;

    public abstract int getOnlinePlayerCount();
    public abstract List<Player> getOnlinePlayers();

    public abstract ServerData getServerData();
    public abstract Properties getServerProperties();
    public abstract boolean setServerProperties(Properties properties);

    public abstract List<String> getWorldPaths(List<UUID> worlds);
    public abstract Map<String, UUID> getWorlds();

    public abstract boolean isPluginFolder(String path); // return path.startsWith("plugins\\ServerCtrl") || path.startsWith("plugins/ServerCtrl");
    public abstract String getPluginFolder();
    public abstract boolean isBackupFolder(String path);

    public abstract String getConsoleLogPath();

    public String getProvisioningBackendURI() {
        return provisioningPack.publicURL();
    }

    public String getProvisioningBackendWebsocketURI() {
        return getProvisioningBackendURI()
                .replaceFirst("^https://", "wss://")
                .replaceFirst("^http://", "ws://") + "/ws";
    }

    public String getProvisioningAuthToken() {
        return provisioningPack.name() + ":" + provisioningPack.accessToken();
    }

    public String getProvisioningServerCert() {
        return provisioningPack.cert();
    }

    public void loadProvisioningPack() throws Exception {
        File pluginFolder = new File(getPluginFolder());
        pluginFolder.mkdirs();
        File[] files = pluginFolder.listFiles((FilenameFilter) new RegexFileFilter(".*[.]sctrl"));
        if (files != null && files.length > 0) {
            try (BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(files[0]))) {
                this.provisioningPack = ProvisioningPack.parsePackFile(bufferedInputStream.readAllBytes());
                return;
            }
        }
        throw new Exception("Failed to read provisioning pack");
    }
}
