package de.blitzdose.webserver.auth;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class User {
    private String username;
    private String password;
    private String totpSecret = null;
    private boolean superAdmin;
    private Map<String, List<Role>> roleSets = new HashMap<>();

    public User(String username, String password, String totpSecret, boolean superAdmin, Map<String, List<Role>> roleSets) {
        this.username = username;
        this.password = password;
        this.totpSecret = totpSecret;
        this.superAdmin = superAdmin;
        this.roleSets = roleSets;
    }

    public User(String username, String password, String totpSecret, boolean superAdmin) {
        this.username = username;
        this.password = password;
        this.totpSecret = totpSecret;
        this.superAdmin = superAdmin;
    }

    public User(String username, String password, boolean superAdmin) {
        this.username = username;
        this.password = password;
        this.superAdmin = superAdmin;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Map<String, List<Role>> getRoleSets() {
        return roleSets;
    }

    public void setRoleSets(Map<String, List<Role>> roleSets) {
        this.roleSets = roleSets;
    }

    public void addRoleSet(String system, List<Role> roleSet) {
        this.roleSets.put(system, roleSet);
    }

    public void addRole(String system, Role role) {
        List<Role> roleSet = this.roleSets.get(system);
        if (roleSet == null) {
            roleSet = new ArrayList<>();
        }
        roleSet.add(role);
        this.roleSets.put(system, roleSet);
    }

    public void setSuperAdmin(boolean superAdmin) {
        this.superAdmin = superAdmin;
    }

    public boolean isSuperAdmin() {
        return superAdmin;
    }

    public String getTotpSecret() {
        return totpSecret;
    }

    public void setTotpSecret(String totpSecret) {
        this.totpSecret = totpSecret;
    }
}
