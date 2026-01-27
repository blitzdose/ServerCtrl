package de.blitzdose.webserver.auth;

import io.javalin.security.RouteRole;

public enum Role implements RouteRole {
    ANYONE,
    KICK,
    BAN,
    OP,
    CONSOLE,
    SERVERSETTINGS,
    LOG,
    FILES,
    ADMIN
}
