package de.blitzdose.serverctrl.common.web.auth;

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
