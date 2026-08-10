package de.blitzdose.ServerCtrlBackendDEV;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class BackendApiInstanceImpl extends de.blitzdose.api.BackendApiInstance {

    private final File configFile = new File("configuration.json");
    private final MockConfig mockConfig;

    BackendApiInstanceImpl() throws IOException {
        if (!configFile.exists()) {
            MockConfig.load("""
            {
              "Webserver": {
                "https": true,
                "frontend": true,
                "port": 5718,
                "editable-files": [
                  "txt",
                  "yml",
                  "json",
                  "properties",
                  "log"
                ]
              }
            }""").save(configFile);
        }
        mockConfig = MockConfig.load(configFile);
    }

    @Override
    public void sendMessage(String message) {
        System.out.println(message);
    }

    @Override
    public List<String> configGetStringList(String key) {
        return mockConfig.getStringList(key);
    }

    @Override
    public String configGetString(String key) {
        return mockConfig.getString(key);
    }

    @Override
    public int configGetInt(String key) {
        return mockConfig.getInt(key);
    }

    @Override
    public boolean configGetBoolean(String key) {
        return mockConfig.getBoolean(key);
    }

    @Override
    public boolean configContains(String key) {
        return mockConfig.contains(key);
    }

    @Override
    public void configUpdate(String key, Object value) {
        mockConfig.set(key, value);
        try {
            mockConfig.save(configFile);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<String> configGetKeys(String key) {
        return mockConfig.getKeys(key);
    }

    @Override
    public String getKeystorePath() {
        return "data/cert.jks";
    }

    @Override
    public String getRootCAPath() {
        return "data/RootCA.crt";
    }

    @Override
    public String getLogPath() {
        return "data/log/main.log";
    }

    @Override
    public String getDataDBPath() {
        return "data/data.db";
    }
}
