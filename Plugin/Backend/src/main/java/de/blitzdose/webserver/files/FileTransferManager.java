package de.blitzdose.webserver.files;

import de.blitzdose.clientConnection.websocket.WebsocketException;
import de.blitzdose.webserver.WebServer;
import io.javalin.http.Context;
import jakarta.servlet.ServletOutputStream;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.concurrent.*;

import static de.blitzdose.serverctrl.common.web.parser.PathParser.parsePath;

public class FileTransferManager {

    private static final List<Transfer> transfers = new ArrayList<>();

    public Transfer initNewTransfer(Context context) {
        String transferID = UUID.randomUUID().toString();
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        Transfer transfer = new Transfer(transferID, context, future);
        transfers.add(transfer);
        return transfer;
    }

    public void handleUpload(Context context) {
        String transferID = context.pathParam("transferID");
        String name = context.queryParam("name");
        long size = Long.parseLong(Objects.requireNonNull(context.queryParam("size")));

        Optional<Transfer> transfer = transfers.stream().filter(t -> t.ID.equals(transferID)).findAny();

        if (transfer.isEmpty()) {
            WebServer.returnFailedJson(context);
            return;
        }

        transfer.get().cancelTimeout();

        Context requestContext = transfer.get().context;

        requestContext.contentType("application/octet-stream");
        requestContext.header("Access-Control-Allow-Origin", "*");
        requestContext.header("Content-Disposition", "attachment; filename=\"" + name + "\"");
        requestContext.header("Content-Length", String.valueOf(size));

        try (InputStream inputStream = context.bodyInputStream(); ServletOutputStream outputStream = requestContext.outputStream()) {
            while (inputStream.available() > 0) {
                outputStream.write(inputStream.read());
            }
            WebServer.returnSuccessfulJson(context, new JSONObject());
            transfer.get().future.complete(true);
        } catch (IOException e) {
            WebServer.returnFailedJson(requestContext);
            transfer.get().future.complete(false);
        } finally {
            transfers.remove(transfer.get());
        }
    }

    public void handleDownload(Context context) {
        String transferID = context.pathParam("transferID");

        Optional<Transfer> transfer = transfers.stream().filter(t -> t.ID.equals(transferID)).findAny();

        if (transfer.isEmpty()) {
            WebServer.returnFailedJson(context);
            return;
        }

        String path = parsePath(transfer.get().context.queryParam("path"), true);

        context.contentType("application/octet-stream");
        context.header("Access-Control-Allow-Origin", "*");
        context.header("Content-Disposition", "attachment; filename=\"" + path + "\"");
        context.header("Content-Length", String.valueOf(transfer.get().context.contentLength()));

        try (InputStream inputStream = transfer.get().context.bodyInputStream(); ServletOutputStream outputStream = context.outputStream()) {
            while (inputStream.available() > 0) {
                outputStream.write(inputStream.read());
            }
            WebServer.returnSuccessfulJson(transfer.get().context, new JSONObject());
            transfer.get().future.complete(true);
        } catch (IOException e) {
            WebServer.returnFailedJson(transfer.get().context);
            transfer.get().future.complete(false);
        } finally {
            transfers.remove(transfer.get());
        }
    }

    public static class Transfer {

        private final String ID;
        private final Context context;
        private final CompletableFuture<Boolean> future;
        final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
        ScheduledFuture<?> timeout = null;

        Transfer(String ID, Context context, CompletableFuture<Boolean> future) {
            this.ID = ID;
            this.context = context;
            this.future = future;
        }

        public void setTimeout(long value, TimeUnit timeUnit) {
            timeout = scheduler.schedule(
                    () -> future.completeExceptionally(new WebsocketException.TimeoutException()),
                    value, timeUnit
            );
        }

        public void cancelTimeout() {
            timeout.cancel(false);
        }

        public void cancel() {
            transfers.remove(this);
        }

        public CompletableFuture<?> registerHandler() {
            return future;
        }

        public String getID() {
            return ID;
        }
    }
}
