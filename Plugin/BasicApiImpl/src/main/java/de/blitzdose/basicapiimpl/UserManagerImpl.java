package de.blitzdose.basicapiimpl;

import de.blitzdose.basicapiimpl.instance.ApiInstance;
import de.blitzdose.serverctrl.common.web.auth.UserManager;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class UserManagerImpl extends UserManager {

    private final ApiInstance instance;

    public UserManagerImpl(ApiInstance instance) {
        this.instance = instance;
    }

    @Override
    public Set<String> getUsers() {
        return instance.getUsers();
    }

    @Override
    public String getUserHash(String username) {
        return instance.configGetString("Webserver.users." + username);
    }

    @Override
    public List<String> getAppHashes(String username) {
        return instance.configGetStringList("Webserver.apppasswords." + username);
    }

    @Override
    public String getTOTPSecret(String username) {
        return instance.configGetString("Webserver.totp." + username);
    }

    @Override
    public List<String> getPermissions(String username) {
        return instance.configGetStringList("Webserver.permissions." + username);
    }

    @Override
    public boolean userExists(String username) {
        return instance.configContains("Webserver.users." + username);
    }

    @Override
    public boolean hasTOTP(String username) {
        if (!userExists(username)) {
            return false;
        }
        return instance.configContains("Webserver.totp." + username);
    }

    @Override
    public boolean isTOTPPending(String username) {
        return instance.configContains("Webserver.totp-pending." + username);
    }

    @Override
    public String getPendingTOTPSecret(String username) {
        return instance.configGetString("Webserver.totp-pending." + username);
    }

    @Override
    public void setPassword(String username, String newPasswordHash) {
        instance.configUpdate("Webserver.users." + username, newPasswordHash);
        instance.configUpdate("Webserver.apppasswords." + username, new ArrayList<String>());
    }

    @Override
    public void setUser(String username, String passwordHash) {
        instance.configUpdate("Webserver.users." + username, passwordHash);
    }

    @Override
    public void deleteUser(String username) {
        instance.configUpdate("Webserver.users." + username, null);
        instance.configUpdate("Webserver.permissions." + username, null);
    }

    @Override
    public void setPermissions(String username, String[] rolesArray) {
        instance.configUpdate("Webserver.permissions." + username, rolesArray);
    }

    @Override
    public void setPendingTOTPSecret(String username, String secret) {
        instance.configUpdate("Webserver.totp-pending." + username, secret);
    }

    @Override
    public void setTOTPSecret(String username, String secret) {
        instance.configUpdate("Webserver.totp." + username, secret);
        instance.configUpdate("Webserver.totp-pending." + username, null);
    }

    @Override
    public void setAppHashes(String username, List<String> appHashes) {
        instance.configUpdate("Webserver.apppasswords." + username, appHashes);
    }
}
