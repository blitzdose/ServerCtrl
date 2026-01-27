package de.blitzdose.clientConnection.websocket;

public class WebsocketException extends Exception {
    public static class SystemNotFoundException extends WebsocketException { }
    public static class SystemNotConnectedException extends WebsocketException { }
    public static class TimeoutException extends WebsocketException { }
    public static class RequestNotSuccessfulException extends WebsocketException { }
}
