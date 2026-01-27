package de.blitzdose.webserver.api;

import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.clientConnection.websocket.WebsocketHandler;
import de.blitzdose.serverctrl.common.web.websocket.requests.RequestMethod;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketRequest;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import de.blitzdose.webserver.auth.Role;
import de.blitzdose.webserver.auth.User;
import de.blitzdose.webserver.logging.SecurityLogType;
import io.javalin.http.Context;
import org.json.JSONObject;

import java.util.Base64;

public class ConsoleApi {

    public static void getLog(Context context) throws WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        WebsocketResponse response = WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.GetConsoleLog, null));

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data",  response.data(String.class)));
    }

    public static void command(Context context) throws de.blitzdose.webserver.auth.shiro.UserManager.UserManagerException, WebsocketException.SystemNotFoundException, WebsocketException.RequestNotSuccessfulException, WebsocketException.SystemNotConnectedException, WebsocketException.TimeoutException {
        String commandBase64 = WebServer.getData(context, String.class);
        String command = new String(Base64.getUrlDecoder().decode(commandBase64)).trim();
        String system = context.queryParam("system");

        User user = WebServer.userManager.getUser(context.cookie("token"));

        if (!hasPermission(user, system, command)) {
            WebServer.returnFailedJson(context);
            return;
        }

        WebsocketHandler.tunnelThroughWebsocket(context.queryParam("system"), new WebsocketRequest(RequestMethod.SendCommand, command));

        WebServer.securityLog(SecurityLogType.COMMAND_SEND, context, command);
        WebServer.returnSuccessfulJson(context, new JSONObject());
    }

    private static boolean hasPermission(User user, String system, String command) {
        if (user.isSuperAdmin() ||
                user.getRoleSets().get(system).contains(Role.CONSOLE) ||
                user.getRoleSets().get(system).contains(Role.ADMIN)) {
            return true;
        }

        if (command.startsWith("kick ")) {
            return user.getRoleSets().get(system).contains(Role.KICK);
        } else if (command.startsWith("ban ")) {
            return user.getRoleSets().get(system).contains(Role.BAN);
        } else if (command.startsWith("op ") || command.startsWith("deop ")) {
            return user.getRoleSets().get(system).contains(Role.OP);
        } else {
            return false;
        }
    }

}
