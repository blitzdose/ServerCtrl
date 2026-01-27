package de.blitzdose.webserver.auth;

import de.blitzdose.clientConnection.websocket.WebsocketAccessManager;
import de.blitzdose.clientConnection.websocket.WebsocketClientManager;
import de.blitzdose.webserver.auth.shiro.UserManager;
import io.javalin.http.Context;
import io.javalin.http.Handler;
import io.javalin.http.UnauthorizedResponse;
import kotlin.Pair;
import org.jetbrains.annotations.NotNull;

import java.util.List;
import java.util.Map;

public class AccessManager implements Handler {

    private final UserManager userManager;
    private final WebsocketClientManager websocketClientManager;

    public AccessManager(UserManager userManager, WebsocketClientManager websocketClientManager) {
        this.userManager = userManager;
        this.websocketClientManager = websocketClientManager;
    }

    @Override
    public void handle(@NotNull Context ctx) {
        if (ctx.routeRoles().isEmpty()) return;

        if (ctx.routeRoles().contains(InternalRole.INTERNAL)) {
            Pair<String, String> nameAndAccessToken = WebsocketAccessManager.getTokenFromHeader(ctx);
            if (nameAndAccessToken == null) {
                throw new UnauthorizedResponse();
            }
            if (!websocketClientManager.checkAccessToken(nameAndAccessToken.component1(), nameAndAccessToken.component2())) {
                throw new UnauthorizedResponse();
            }
            return;
        }

        String token = ctx.cookie("token");
        if (token == null || token.isEmpty()) {
            throw new UnauthorizedResponse();
        }

        User user;

        try {
            user = userManager.getUser(token);
        } catch (UserManager.UserManagerException e) {
            throw new UnauthorizedResponse();
        }

        ctx.attribute("user", user);

        if (ctx.routeRoles().contains(WebserverManagerRole.ANYONE) || user.isSuperAdmin()) {
            return;
        }

        Map<String, List<Role>> roleSets = user.getRoleSets();
        String system = ctx.queryParam("system");
        if (system == null) {
            throw new UnauthorizedResponse();
        }

        List<Role> roleList = roleSets.get(system);
        if (roleList == null) {
            throw new UnauthorizedResponse();
        }

        if (ctx.routeRoles().contains(Role.ANYONE)) {
            return;
        }

        if (roleList.contains(Role.ADMIN)) {
            return;
        }

        if (ctx.routeRoles().stream().noneMatch(roleList::contains)) {
            throw new UnauthorizedResponse();
        }
    }
}
