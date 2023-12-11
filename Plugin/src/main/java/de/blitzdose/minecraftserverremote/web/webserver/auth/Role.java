package de.blitzdose.minecraftserverremote.web.webserver.auth;

import io.javalin.security.RouteRole;

public enum Role implements RouteRole {
    ANYONE,
    KICK,
    BAN,
    OP,
    CONSOLE,
    PLUGINSETTINGS,
    SERVERSETTINGS,
    LOG,
    FILES,
    ADMIN
}
