package de.blitzdose.webserver.auth;

import de.blitzdose.serverctrl.common.crypt.CryptManager;

import java.security.PublicKey;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class User {
    private String username;
    private String password;
    private String totpSecret = null;
    private boolean superAdmin;
    private Map<String, List<Role>> roleSets = new HashMap<>();
    private Map<String, PublicKey> publicKeys = new HashMap<>();

    public User(String username, String password, String totpSecret, boolean superAdmin, Map<String, List<Role>> roleSets, List<PublicKey> publicKeys) {
        this.username = username;
        this.password = password;
        this.totpSecret = totpSecret;
        this.superAdmin = superAdmin;
        this.roleSets = roleSets;
        this.publicKeys = publicKeys.stream().collect(Collectors.toMap(
                publicKey -> CryptManager.getSHA256(publicKey.getEncoded()),
                publicKey -> publicKey)
        );
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

    public Map<String, PublicKey> getPublicKeys() {
        return publicKeys;
    }

    public void addPublicKey(PublicKey publicKey) {
        String hash = CryptManager.getSHA256(publicKey.getEncoded());
        this.publicKeys.put(hash, publicKey);
    }

    public void setPublicKeys(List<PublicKey> publicKeys) {
        this.publicKeys = publicKeys.stream().collect(Collectors.toMap(
                publicKey -> CryptManager.getSHA256(publicKey.getEncoded()),
                publicKey -> publicKey)
        );
    }
}
