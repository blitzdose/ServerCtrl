package de.blitzdose.encryption;

public class LocalEncryption {
    private String password;

    public LocalEncryption(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}