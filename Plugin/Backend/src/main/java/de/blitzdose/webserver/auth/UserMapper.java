package de.blitzdose.webserver.auth;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.lang.reflect.Type;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

        try {
            String publicKeysJson = rs.getString("publicKeys");
            List<PublicKey> publicKeys = deserializePublicKeys(publicKeysJson);
            user.setPublicKeys(publicKeys);
        } catch (NoSuchAlgorithmException ignored) {}

        return user;
    }

    public List<PublicKey> deserializePublicKeys(String json) throws NoSuchAlgorithmException {
        String[] base64Keys = new Gson().fromJson(json, String[].class);

        KeyFactory kf = KeyFactory.getInstance("EC"); // or "RSA" if using RSA

        return Arrays.stream(base64Keys)
                .map(b64 -> {
                    try {
                        byte[] keyBytes = Base64.getDecoder().decode(b64);
                        return kf.generatePublic(new X509EncodedKeySpec(keyBytes));
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .collect(Collectors.toList());
    }
}