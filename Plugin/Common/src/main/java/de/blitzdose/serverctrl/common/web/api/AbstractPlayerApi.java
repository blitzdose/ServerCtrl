package de.blitzdose.serverctrl.common.web.api;

import java.util.List;
import java.util.UUID;

public abstract class AbstractPlayerApi {

    public abstract int getPlayerCount(String system);

    public abstract List<Player> getOnlinePlayer(String system);

    public static class Player {
        private final String name;
        private final UUID UniqueId;
        private final boolean op;


        public Player(String name, UUID uniqueId, boolean op) {
            this.name = name;
            UniqueId = uniqueId;
            this.op = op;
        }

        public String getName() {
            return name;
        }

        public UUID getUniqueId() {
            return UniqueId;
        }

        public boolean isOp() {
            return op;
        }
    }
}
