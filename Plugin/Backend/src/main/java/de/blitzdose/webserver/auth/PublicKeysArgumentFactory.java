package de.blitzdose.webserver.auth;

import com.google.gson.Gson;
import org.jdbi.v3.core.argument.AbstractArgumentFactory;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.config.ConfigRegistry;

import java.security.PublicKey;
import java.sql.Types;
import java.util.Base64;
import java.util.List;
import java.util.Map;

public class PublicKeysArgumentFactory extends AbstractArgumentFactory<Map<String, PublicKey>> {
    private static final Gson gson = new Gson();

    public PublicKeysArgumentFactory() {
        super(Types.VARCHAR);
    }

    @Override
    protected Argument build(Map<String, PublicKey> value, ConfigRegistry config) {
        List<String> base64Keys = value.values().stream()
                .map(key -> Base64.getEncoder().encodeToString(key.getEncoded()))
                .toList();

        return (pos, stmt, ctx) -> stmt.setString(pos, gson.toJson(base64Keys));
    }
}