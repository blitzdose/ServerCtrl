package de.blitzdose.apiimpl;

import de.blitzdose.api.BackendApiInstance;
import de.blitzdose.serverctrl.common.web.parser.Pagination;
import de.blitzdose.serverctrl.common.web.websocket.requests.WebsocketResponse;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class BackendLogApiImpl {
    private final BackendApiInstance instance;

    public BackendLogApiImpl(BackendApiInstance instance) {
        this.instance = instance;
    }

    public WebsocketResponse getLog(Pagination pagination) {
        File file = new File(instance.getLogPath());
        if (file.exists()) {
            try {
                BufferedReader reader = new BufferedReader(new FileReader(file));
                List<String> lines = reader.lines().toList();
                List<String> newLines = new ArrayList<>();
                for (int i=lines.size()-1; i>=0; i--) {
                    newLines.add(lines.get(i));
                }
                String log = newLines.stream().skip(pagination.position()).limit(pagination.limit() != -1 ? pagination.limit() : newLines.size()).collect(Collectors.joining("\n"));
                return new WebsocketResponse(true, log);
            } catch (IOException ignored) { }
        }
        return new WebsocketResponse(false, null);
    }

    public WebsocketResponse getLogCount() {
        File file = new File(instance.getLogPath());
        if (file.exists()) {
            try {
                BufferedReader reader = new BufferedReader(new FileReader(file));
                return new WebsocketResponse(true,  reader.lines().count());
            } catch (IOException ignored) {
            }
        }
        return new WebsocketResponse(false, null);
    }
}
