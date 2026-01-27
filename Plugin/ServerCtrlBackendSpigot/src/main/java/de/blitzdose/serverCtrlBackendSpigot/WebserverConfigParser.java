package de.blitzdose.serverCtrlBackendSpigot;

import de.blitzdose.webserver.WebserverConfig;
import org.bukkit.configuration.ConfigurationSection;
import org.jetbrains.annotations.Nullable;

public class WebserverConfigParser {
    static WebserverConfig parseFromYAML(@Nullable ConfigurationSection section) {
        if (section == null) {
            return new WebserverConfig(false, true, true, 5718);
        }
        boolean debugging = section.getBoolean("debugging", false);
        boolean https = section.getBoolean("https", true);
        boolean frontend = section.getBoolean("frontend", true);
        int port = section.getInt("port", 5718);
        return new WebserverConfig(debugging, https, frontend, port);
    }
}
