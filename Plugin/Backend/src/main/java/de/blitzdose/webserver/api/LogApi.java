package de.blitzdose.webserver.api;

import de.blitzdose.apiimpl.BackendLogApiImpl;
import de.blitzdose.serverctrl.common.web.parser.Pagination;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import org.json.JSONObject;

public class LogApi {
    public static void getLog(Context context) {
        BackendLogApiImpl logApi = new BackendLogApiImpl(WebServer.backendApiInstance);
        Pagination pagination = Pagination.parse(context.queryParamMap());

        WebsocketResponse response = logApi.getLog(pagination);
        if (!response.success()) {
            WebServer.returnFailedJson(context);
            return;
        }

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(String.class)));
    }

    public static void countLogs(Context context) {
        BackendLogApiImpl logApi = new BackendLogApiImpl(WebServer.backendApiInstance);

        WebsocketResponse response = logApi.getLogCount();
        if (!response.success()) {
            WebServer.returnFailedJson(context);
            return;
        }

        WebServer.returnSuccessfulJson(context, new JSONObject().put("data", response.data(Long.class)));
    }
}
