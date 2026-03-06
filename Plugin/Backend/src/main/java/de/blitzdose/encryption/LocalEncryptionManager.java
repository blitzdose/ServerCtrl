package de.blitzdose.encryption;

import org.jdbi.v3.core.Jdbi;

public class LocalEncryptionManager {

    private final Jdbi jdbi;

    public LocalEncryptionManager(Jdbi jdbi) {
        this.jdbi = jdbi;
    }

    public void insertIfNotExists(LocalEncryption localEncryption) {
        jdbi.onDemand(LocalEncryptionDao.class).insertIfNotExists(localEncryption);
    }

    public String getPassword() {
        return jdbi.onDemand(LocalEncryptionDao.class).getPassword();
    }
}
