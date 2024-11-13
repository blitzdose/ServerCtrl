package de.blitzdose.serverctrl.common.web.auth;

import java.util.ArrayList;

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
}
