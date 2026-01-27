package de.blitzdose.webserver.auth;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.lang.reflect.Type;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class UserMapper implements RowMapper<User> {
    private static final Gson gson = new Gson();
    private static final Type ROLE_MAP_TYPE = new TypeToken<Map<String, List<Role>>>() {}.getType();

    @Override
    public User map(ResultSet rs, StatementContext ctx) throws SQLException {
        User user = new User(
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("totpSecret"),
                rs.getBoolean("superAdmin")
        );

        String rolesJson = rs.getString("roleSets");
        Map<String, List<Role>> roles = gson.fromJson(rolesJson, ROLE_MAP_TYPE);
        user.setRoleSets(roles);

        return user;
    }
}