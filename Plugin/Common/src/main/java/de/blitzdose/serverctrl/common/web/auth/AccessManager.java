package de.blitzdose.serverctrl.common.web.auth;

import io.javalin.http.Context;
import io.javalin.http.Handler;
import io.javalin.http.UnauthorizedResponse;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class AccessManager implements Handler {

    private final UserManager userManager;

    public AccessManager(UserManager userManager) {
        this.userManager = userManager;
    }

    @Override
    public void handle(@NotNull Context ctx) {
        ArrayList<Role> givenRoles = userManager.getRoles(ctx.cookie("token"));
        if (ctx.routeRoles().isEmpty() || (ctx.routeRoles().contains(Role.ANYONE) && givenRoles != null)) {
            return;
        } else {
            Role role = (Role) ctx.routeRoles().toArray()[0];
            if (givenRoles == null || (!givenRoles.contains(role) && !givenRoles.contains(Role.ADMIN))) {
                throw new UnauthorizedResponse();
            }
        }
    }
}
