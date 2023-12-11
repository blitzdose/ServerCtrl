package de.blitzdose.minecraftserverremote.web.webserver.auth;

import io.javalin.http.Context;
import io.javalin.http.Handler;
import io.javalin.security.RouteRole;
import org.eclipse.jetty.http.HttpStatus;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.Set;

public class AccessManager implements io.javalin.security.AccessManager {
    @Override
    public void manage(@NotNull Handler handler, @NotNull Context context, @NotNull Set<? extends RouteRole> set) throws Exception {
        UserManager userManager = new UserManager();
        ArrayList<Role> givenRoles = userManager.getRoles(context.cookie("token"));
        if (set.isEmpty() || (set.contains(Role.ANYONE) && givenRoles != null)) {
            handler.handle(context);
        } else {
            Role role = (Role) set.toArray()[0];
            if (givenRoles == null || (!givenRoles.contains(role) && !givenRoles.contains(Role.ADMIN))) {
                context.status(HttpStatus.FORBIDDEN_403);
                context.result();
            } else {
                handler.handle(context);
            }
        }
    }
}
