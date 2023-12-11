package de.blitzdose.minecraftserverremote.web.webserver.auth;

import de.blitzdose.minecraftserverremote.ServerCtrl;
import org.bukkit.configuration.file.FileConfiguration;

import java.util.ArrayList;
import java.util.stream.Collectors;

public class TokenUser {
    private final String username;
    private long updatedDateMillis;

    public TokenUser(String username, long createDateMillis, ArrayList<Role> roles) {
        this.username = username;
        this.updatedDateMillis = createDateMillis;
    }

    public String getUsername() {
        return username;
    }

    public long getUpdatedDateMillis() {
        return updatedDateMillis;
    }

    public void setUpdatedDateMillis(long updatedDateMillis) {
        this.updatedDateMillis = updatedDateMillis;
    }

    public ArrayList<Role> getRoles() {
        FileConfiguration config = ServerCtrl.getPlugin().getConfig();
        if (!config.contains("Webserver.users." + username)) {
            return new ArrayList<>();
        }
        return config.getStringList("Webserver.permissions." + username).stream().map(Role::valueOf).collect(Collectors.toCollection(ArrayList::new));
    }
}
