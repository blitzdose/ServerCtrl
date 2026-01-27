package de.blitzdose.webserver;

public record WebserverConfig(boolean debugging, boolean https, boolean frontend, int port) {
}
