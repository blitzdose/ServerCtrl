package de.blitzdose.basicapiimpl;

import de.blitzdose.serverctrl.common.logging.LoggingSaver;


public class LoggingSaverImpl extends LoggingSaver {

    @Override
    public String getLogFilePath() {
        return "plugins/ServerCtrl/log/main.log";
    }
}
