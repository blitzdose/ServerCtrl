package de.blitzdose.serverctrl.standalone.impl;

import de.blitzdose.serverctrl.common.logging.LoggingSaver;


public class LoggingSaverImpl extends LoggingSaver {

    @Override
    public String getLogFilePath() {
        return "plugins/ServerCtrl/log/main.log";
    }
}
