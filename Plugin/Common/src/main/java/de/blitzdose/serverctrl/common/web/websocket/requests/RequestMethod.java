package de.blitzdose.serverctrl.common.web.websocket.requests;

public enum RequestMethod {
    GetHistoricSystemData,
    GetIcon,

    GetName,
    SetName,
    GetServerData,
    GetServerSettings,
    SetServerSettings,
    StopServer,
    RestartServer,
    ReloadServer,

    GetOnline,
    GetPlayerCount,

    GetConsoleLog,
    SendCommand,

    ListFiles,
    CountFiles,
    DownloadFile,
    DeleteFileFolder,
    CreateFile,
    CreateFolder,
    RenameFileFolder,
    ExtractFile,
    DownloadMultipleFiles,
    UploadFile,
    DeleteMultipleFileFolder,

    ListWorlds,
    CreateWorldsBackup,
    CreateFullBackup,
    ListBackups,
    DeleteBackup
}
