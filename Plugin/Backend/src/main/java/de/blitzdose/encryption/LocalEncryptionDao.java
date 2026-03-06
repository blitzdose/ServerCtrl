package de.blitzdose.encryption;

import org.jdbi.v3.sqlobject.customizer.BindBean;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;

public interface LocalEncryptionDao {
    @SqlUpdate("""
        CREATE TABLE IF NOT EXISTS local_encryption (
            id INT PRIMARY KEY CHECK (id = 1),
            password VARCHAR NOT NULL
        )
        """)
    void createTable();

    @SqlUpdate("""
        INSERT INTO local_encryption (id, password) VALUES (1, :password)
        ON CONFLICT (id) DO NOTHING
        """)
    void insertIfNotExists(@BindBean LocalEncryption encryption);

    @SqlQuery("SELECT password FROM local_encryption WHERE id = 1")
    String getPassword();
}
