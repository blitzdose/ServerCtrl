package de.blitzdose.webserver.auth;

import io.javalin.security.RouteRole;

public enum WebserverManagerRole implements RouteRole {
    ANYONE,
    SUPERADMIN
}
