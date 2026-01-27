package de.blitzdose.clientConnection.websocket;

import io.javalin.http.Context;
import io.javalin.http.Handler;
import io.javalin.http.UnauthorizedResponse;
import io.javalin.websocket.WsContext;
import kotlin.Pair;
import org.jetbrains.annotations.NotNull;

public class WebsocketAccessManager implements Handler {

    private final WebsocketClientManager websocketClientManager;

    public WebsocketAccessManager(WebsocketClientManager websocketClientManager) {
        this.websocketClientManager = websocketClientManager;
    }

    @Override
    public void handle(@NotNull Context ctx) throws UnauthorizedResponse {
        Pair<String, String> nameAndAccessToken = getTokenFromHeader(ctx);
        if (nameAndAccessToken != null) {
            if (websocketClientManager.checkAccessToken(nameAndAccessToken.component1(), nameAndAccessToken.component2())) {
                return;
            }
        }

        throw new UnauthorizedResponse();
    }

    public static Pair<String, String> getTokenFromHeader(Context ctx) {
        return getTokenFromHeader(ctx.header("Authorization"));
    }

    public static Pair<String, String> getTokenFromHeader(WsContext ctx) {
        return getTokenFromHeader(ctx.header("Authorization"));
    }

    private static Pair<String, String> getTokenFromHeader(String authHeader) {
        if (authHeader != null) {
            authHeader = authHeader.replace("Bearer ", "");

            return new Pair<>(authHeader.split(":")[0], authHeader.split(":")[1]);
        }
        return null;
    }
}
