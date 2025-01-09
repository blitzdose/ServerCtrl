package de.blitzdose.basicapiimpl;

import de.blitzdose.serverctrl.common.web.auth.UserManager;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.plugin.Plugin;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class UserManagerImpl extends UserManager {

    Plugin plugin;

    public UserManagerImpl(Plugin plugin) {
        this.plugin = plugin;
    }

    @Override
    public Set<String> getUsers() {
        ConfigurationSection users = plugin.getConfig().getConfigurationSection("Webserver.users");
        if (users == null) {
            return null;
        } else {
            return users.getKeys(false);
        }
    }

    @Override
    public String getUserHash(String username) {
        return plugin.getConfig().getString("Webserver.users." + username);
    }

    @Override
    public List<String> getAppHashes(String username) {
        return plugin.getConfig().getStringList("Webserver.apppasswords." + username);
    }

    @Override
    public String getTOTPSecret(String username) {
        return plugin.getConfig().getString("Webserver.totp." + username);
    }

    @Override
    public List<String> getPermissions(String username) {
        return plugin.getConfig().getStringList("Webserver.permissions." + username);
    }

    @Override
    public boolean userExists(String username) {
        return plugin.getConfig().contains("Webserver.users." + username);
    }

    @Override
    public boolean hasTOTP(String username) {
        if (!userExists(username)) {
            return false;
        }
        return plugin.getConfig().contains("Webserver.totp." + username);
    }

    @Override
    public boolean isTOTPPending(String username) {
        return plugin.getConfig().contains("Webserver.totp-pending." + username);
    }

    @Override
    public String getPendingTOTPSecret(String username) {
        return plugin.getConfig().getString("Webserver.totp-pending." + username);
    }

    @Override
    public void setPassword(String username, String newPasswordHash) {
        plugin.getConfig().set("Webserver.users." + username, newPasswordHash);
        plugin.getConfig().set("Webserver.apppasswords." + username, new ArrayList<String>());
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void setUser(String username, String passwordHash) {
        plugin.getConfig().set("Webserver.users." + username, passwordHash);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void deleteUser(String username) {
        plugin.getConfig().set("Webserver.users." + username, null);
        plugin.getConfig().set("Webserver.permissions." + username, null);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void setPermissions(String username, String[] rolesArray) {
        plugin.getConfig().set("Webserver.permissions." + username, rolesArray);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void setPendingTOTPSecret(String username, String secret) {
        plugin.getConfig().set("Webserver.totp-pending." + username, secret);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void setTOTPSecret(String username, String secret) {
        plugin.getConfig().set("Webserver.totp." + username, secret);
        plugin.getConfig().set("Webserver.totp-pending." + username, null);
        plugin.saveConfig();
        plugin.reloadConfig();
    }

    @Override
    public void setAppHashes(String username, List<String> appHashes) {
        plugin.getConfig().set("Webserver.apppasswords." + username, appHashes);
        plugin.saveConfig();
        plugin.reloadConfig();
    }
}
