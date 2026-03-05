package de.blitzdose.clientConnection;

import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.customizer.BindBean;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;

import java.util.List;

public interface ProvisionedClientDao {
    @SqlUpdate("CREATE TABLE IF NOT EXISTS clients (name TEXT PRIMARY KEY, accessTokenHash TEXT, pending BOOLEAN DEFAULT TRUE, lastConnected INTEGER)")
    void createTable();

    @SqlUpdate("INSERT INTO clients VALUES (:name, :accessTokenHash, :pending, :lastConnected)")
    void insertClient(@BindBean ProvisionedClient provisionedClient);

    @SqlUpdate("UPDATE clients SET accessTokenHash = :accessTokenHash, pending = :pending, lastConnected = :lastConnected WHERE name = :name")
    void updateClient(@BindBean ProvisionedClient provisionedClient);

    @SqlQuery("SELECT name, accessTokenHash, pending, lastConnected FROM clients WHERE name = :name")
    ProvisionedClient findClientByName(@Bind("name") String name);

    @SqlQuery("SELECT name, accessTokenHash, pending, lastConnected FROM clients")
    List<ProvisionedClient> listAllClients();

    @SqlUpdate("DELETE FROM clients WHERE name = :name")
    void deleteByName(@Bind("name") String name);
}
