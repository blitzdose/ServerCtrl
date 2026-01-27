package de.blitzdose.webserver.auth;

import com.google.gson.Gson;
import org.jdbi.v3.core.argument.AbstractArgumentFactory;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.config.ConfigRegistry;

import java.sql.Types;
import java.util.List;
import java.util.Map;

public class RoleSetsArgumentFactory extends AbstractArgumentFactory<Map<String, List<Role>>> {
    private static final Gson gson = new Gson();

    public RoleSetsArgumentFactory() {
        super(Types.VARCHAR);
    }

    @Override
    protected Argument build(Map<String, List<Role>> value, ConfigRegistry config) {
        return (pos, stmt, ctx) -> stmt.setString(pos, gson.toJson(value));
    }
}