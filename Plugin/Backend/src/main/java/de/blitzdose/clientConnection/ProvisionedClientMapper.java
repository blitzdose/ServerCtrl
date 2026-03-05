package de.blitzdose.clientConnection;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ProvisionedClientMapper implements RowMapper<ProvisionedClient> {

    @Override
    public ProvisionedClient map(ResultSet rs, StatementContext ctx) throws SQLException {
        return new ProvisionedClient(
                rs.getString("name"),
                rs.getString("accessTokenHash"),
                rs.getBoolean("pending"),
                rs.getLong("lastConnected")
        );
    }
}
