// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'it';

  static String m0(name) => "Account ${name}";

  static String m1(ip) => "Impossibile raggiungere \"${ip}\"";

  static String m2(ip) => "Impossibile raggiungere \"${ip}\" tramite HTTPS";

  static String m3(name) => "Programmato da ${name}";

  static String m4(accountName) =>
      "L\'account \"${accountName}\" sarà rimosso permanentemente.";

  static String m5(name) => "\"${name}\" verrà rimosso definitivamente.";

  static String m6(routeTitle) => "Cancella \"${routeTitle}\"";

  static String m7(filename) => "\"${filename}\" scaricato con successo.";

  static String m8(name) => "File \"${name}\"";

  static String m9(version) => "Versione: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Questa applicazione richiede un plugin per essere installato sul server Minecraft esistente. Si prega di fare clic su \"Maggiori informazioni\" per ...beh... Altre informazioni :)"),
        "about": MessageLookupByLibrary.simpleMessage("Chi siamo"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("Informazioni su ServerCtrl"),
        "acceptNewCert": MessageLookupByLibrary.simpleMessage(
            "Certificato modificato. Verificare e accettare il nuovo certificato."),
        "acceptWarningTryAgain": MessageLookupByLibrary.simpleMessage(
            "Accettare l\'avviso e accedere di nuovo"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Account"),
        "add2FAtoApp": MessageLookupByLibrary.simpleMessage(
            "Aggiungi l\'autenticazione a due fattori alla tua app (ad es. Google Authenticator) scansionando il codice QR o copiando il segreto"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Aggiungi server Minecraft"),
        "add_server": MessageLookupByLibrary.simpleMessage("Aggiungi Server"),
        "allYourChangesWillBeLost": MessageLookupByLibrary.simpleMessage(
            "Tutte le tue modifiche andranno perse"),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Memoria allocata"),
        "appearance": MessageLookupByLibrary.simpleMessage("Apparenza"),
        "ban": MessageLookupByLibrary.simpleMessage("Ban"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annulla"),
        "cannotConnectMaybeCredentials": MessageLookupByLibrary.simpleMessage(
            "Impossibile connettersi al server, forse le credenziali sono cambiate?"),
        "cannotFindCredentials": MessageLookupByLibrary.simpleMessage(
            "Impossibile trovare le credenziali per questo server, si prega di aggiungerle di nuovo"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer": MessageLookupByLibrary.simpleMessage(
            "Impossibile raggiungere il server"),
        "certCannotBeVerified": MessageLookupByLibrary.simpleMessage(
            "Il certificato del server non può essere verificato. Vuoi continuare? Fingerprint SHA1 del certificato:"),
        "certificateFile":
            MessageLookupByLibrary.simpleMessage("File del certificato"),
        "certificateKeyFile": MessageLookupByLibrary.simpleMessage(
            "File di chiave del certificato"),
        "certificateUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Certificato caricato con successo"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Cambia password"),
        "close": MessageLookupByLibrary.simpleMessage("Chiudi"),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("Comando"),
        "configureTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Configura l\'autenticazione a due fattori"),
        "confirm": MessageLookupByLibrary.simpleMessage("Conferma"),
        "connectionFailed":
            MessageLookupByLibrary.simpleMessage("Connessione fallita"),
        "console": MessageLookupByLibrary.simpleMessage("Console"),
        "copySecret": MessageLookupByLibrary.simpleMessage("Copia segreto"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("Core CPU"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("Carico CPU"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("Uso CPU"),
        "create": MessageLookupByLibrary.simpleMessage("Crea"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Creare un account"),
        "createFile": MessageLookupByLibrary.simpleMessage("Crea file"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Crea cartella"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Password attuale"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Modalità scura"),
        "dataPrivacy": MessageLookupByLibrary.simpleMessage("Privacy dati"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("Default"),
        "delete": MessageLookupByLibrary.simpleMessage("Cancella"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Cancellare l\'account?"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("Cancellare?"),
        "deleteFileMessage": m5,
        "deleteFiles":
            MessageLookupByLibrary.simpleMessage("Cancellare i file?"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("De-OP"),
        "design": MessageLookupByLibrary.simpleMessage("Design"),
        "directory": MessageLookupByLibrary.simpleMessage("cartella"),
        "discard": MessageLookupByLibrary.simpleMessage("Annulla"),
        "discardChanges":
            MessageLookupByLibrary.simpleMessage("Annulare le modifiche?"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "donate": MessageLookupByLibrary.simpleMessage("Dona"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Scaricato"),
        "downloadedFilenameSuccessfully": m7,
        "downloading": MessageLookupByLibrary.simpleMessage("Scaricando"),
        "dynamicColor": MessageLookupByLibrary.simpleMessage("Colore dinamico"),
        "edit": MessageLookupByLibrary.simpleMessage("Modifica"),
        "egWithGoogleAuthenticator": MessageLookupByLibrary.simpleMessage(
            "esempio: con Google Authenticator"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "errorCreatingAccount":
            MessageLookupByLibrary.simpleMessage("Errore creazione account"),
        "errorCreatingFile": MessageLookupByLibrary.simpleMessage(
            "Errore durante la creazione del file"),
        "errorCreatingFolder": MessageLookupByLibrary.simpleMessage(
            "Errore durante la creazione della cartella"),
        "errorDeletingAccount": MessageLookupByLibrary.simpleMessage(
            "Errore durante la cancellazione dell\'account"),
        "errorDeletingFile": MessageLookupByLibrary.simpleMessage(
            "Errore durante la cancellazione dell\'oggetto"),
        "errorDeletingFiles": MessageLookupByLibrary.simpleMessage(
            "Errore durante la cancellazione dei file"),
        "errorInputMissing": MessageLookupByLibrary.simpleMessage(
            "Inserisci il tuo indirizzo server, nome utente e password"),
        "errorRenamingType": MessageLookupByLibrary.simpleMessage(
            "Errore nel rinominare l\'oggetto"),
        "errorResettingPassword": MessageLookupByLibrary.simpleMessage(
            "Errore reimpostazione password"),
        "errorSavingPermissions": MessageLookupByLibrary.simpleMessage(
            "Errore nel salvataggio dei permessi"),
        "errorWhileDownloadingFile": MessageLookupByLibrary.simpleMessage(
            "Errore durante lo scaricamento del file"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Errore durante la generazione del certificato"),
        "errorWhileRemoving2fa": MessageLookupByLibrary.simpleMessage(
            "Errore durante la rimozione della 2FA"),
        "errorWhileSavingChanges": MessageLookupByLibrary.simpleMessage(
            "Errore durante il salvataggio delle modifiche"),
        "errorWhileSavingFile": MessageLookupByLibrary.simpleMessage(
            "Errore durante il salvataggio del file"),
        "errorWhileUploadingCertificate": MessageLookupByLibrary.simpleMessage(
            "Errore durante il caricamento del certificato"),
        "errorWhileUploadingFile": MessageLookupByLibrary.simpleMessage(
            "Errore durante il caricamento del file"),
        "error_sending_command": MessageLookupByLibrary.simpleMessage(
            "Errore durante l\'invio del comando"),
        "file": MessageLookupByLibrary.simpleMessage("file"),
        "fileAndName": m8,
        "fileSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("File salvato con successo"),
        "fileTooLarge":
            MessageLookupByLibrary.simpleMessage("File troppo grande"),
        "fileTooLargeText": MessageLookupByLibrary.simpleMessage(
            "Il file che si sta tentando di aprire è troppo grande per l\'editor interno."),
        "files": MessageLookupByLibrary.simpleMessage("File"),
        "filesUploadedSuccessfully":
            MessageLookupByLibrary.simpleMessage("File caricati con successo."),
        "free_memory": MessageLookupByLibrary.simpleMessage("Memoria libera"),
        "generate": MessageLookupByLibrary.simpleMessage("Genera"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Genera certificato"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Genera nuovo certificato HTTPS"),
        "getInTouch": MessageLookupByLibrary.simpleMessage("Contattaci"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "help": MessageLookupByLibrary.simpleMessage("Aiuto"),
        "helpMe": MessageLookupByLibrary.simpleMessage("Supportami"),
        "helpMeKeepThisAppAlive": MessageLookupByLibrary.simpleMessage(
            "Aiutami a mantenere questa app attiva"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "howCanILogIn":
            MessageLookupByLibrary.simpleMessage("Come posso accedere?"),
        "howCanILogInText": MessageLookupByLibrary.simpleMessage(
            "Dopo aver installato il plugin sul server Bukkit / Spigot / Paper, il plugin mostrerà la password per l\'utente \"admin\" nella console. Questo accade solo al primo avvio o quando nessun utente chiamato \"admin\" è registrato.\n\nSe hai dimenticato la password o non hai ottenuto il registro della console più semplice, elimina il file \"config.yml\" all\'interno della cartella \"ServerCtrl\" o semplicemente l\'utente \"admin\" all\'interno di questo file. \n\nPer più aiuto entra il mio server Discord."),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "important": MessageLookupByLibrary.simpleMessage("IMPORTANTE!"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Ricorda che è necessario prima installare il plugin ServerCtrl"),
        "inputYourPassword":
            MessageLookupByLibrary.simpleMessage("Inserisci la tua password"),
        "inputYourPasswordAndCurrent2fa": MessageLookupByLibrary.simpleMessage(
            "Inserisci la tua password e l\'attuale 2FA"),
        "ipOrHostname": MessageLookupByLibrary.simpleMessage("IP o nome host"),
        "kick": MessageLookupByLibrary.simpleMessage("Kick"),
        "language": MessageLookupByLibrary.simpleMessage("Lingua"),
        "licenses": MessageLookupByLibrary.simpleMessage("Licenze"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Modalità chiara"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Accedendo"),
        "login": MessageLookupByLibrary.simpleMessage("Accedi"),
        "longPressEntryToDeleteIt": MessageLookupByLibrary.simpleMessage(
            "Premere a lungo per eliminarlo"),
        "material3": MessageLookupByLibrary.simpleMessage("Materiale 3"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("Uso memoria"),
        "moreInfo": MessageLookupByLibrary.simpleMessage("Più info"),
        "multipleFiles": MessageLookupByLibrary.simpleMessage("Più file"),
        "name": MessageLookupByLibrary.simpleMessage("Nome"),
        "newFile": MessageLookupByLibrary.simpleMessage("Nuovo file"),
        "newFolder": MessageLookupByLibrary.simpleMessage("Nuova cartella"),
        "newPassword": MessageLookupByLibrary.simpleMessage("Nuova password"),
        "newServer": MessageLookupByLibrary.simpleMessage("Nuovo server"),
        "newServerAdded": MessageLookupByLibrary.simpleMessage(
            "Nuovo server aggiunto con successo"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("Nessun file selezionato"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("Nessun giocatore online"),
        "nothingSelected":
            MessageLookupByLibrary.simpleMessage("Niente di selezionato"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP"),
        "openWith": MessageLookupByLibrary.simpleMessage("Apri con"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordChangedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Password cambiata con successo"),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
            "Le password non corrispondono"),
        "permissions": MessageLookupByLibrary.simpleMessage("Permissi"),
        "players": MessageLookupByLibrary.simpleMessage("Giocatori"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Consentire l\'accesso alla memoria"),
        "pleaseInputYourCode":
            MessageLookupByLibrary.simpleMessage("Inserisci il tuo codice"),
        "pleaseInputYourUsernameAndPassword":
            MessageLookupByLibrary.simpleMessage(
                "Inserisci nome utente e password"),
        "pleasePutInYourCurrentPassword": MessageLookupByLibrary.simpleMessage(
            "Inserisci la tua password attuale"),
        "pleaseWait":
            MessageLookupByLibrary.simpleMessage("Per favore aspetta"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginAndWebserverPort": MessageLookupByLibrary.simpleMessage(
            "Porta del Plugin e Webserver"),
        "port": MessageLookupByLibrary.simpleMessage("Porta"),
        "remove": MessageLookupByLibrary.simpleMessage("Rimuovi"),
        "removeTwofactorAuthentication": MessageLookupByLibrary.simpleMessage(
            "Rimuovere l\'autenticazione a due fattori?"),
        "rename": MessageLookupByLibrary.simpleMessage("Rinomina"),
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Ripeti nuova password"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Resetta password"),
        "restartToApplyLanguage": MessageLookupByLibrary.simpleMessage(
            "Riavviare l\'app per applicare completamente la nuova lingua"),
        "save": MessageLookupByLibrary.simpleMessage("Salva"),
        "saveFile": MessageLookupByLibrary.simpleMessage("Salva file"),
        "savedChanges":
            MessageLookupByLibrary.simpleMessage("Modifiche salvate"),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Salvato con successo"),
        "saving": MessageLookupByLibrary.simpleMessage("Salvando"),
        "secretCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Segreto copiato negli appunti"),
        "selectFile": MessageLookupByLibrary.simpleMessage("Seleziona file"),
        "selectedEntryWIllBeDeleted": MessageLookupByLibrary.simpleMessage(
            "La voce selezionata verrà eliminata in modo permanente dall\'app"),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "serverNameInput": MessageLookupByLibrary.simpleMessage(
            "Nome del server (selezione libera)"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "share": MessageLookupByLibrary.simpleMessage("Condividi"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Qualcosa è andato storto"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Specificare il dominio o l\'indirizzo IP del server Minecraft"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("SpigotMC"),
        "success": MessageLookupByLibrary.simpleMessage("Successo"),
        "successfullyAdded2faToYourAccount":
            MessageLookupByLibrary.simpleMessage(
                "2FA aggiunto con successo al tuo account"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("File creato con successo"),
        "successfullyCreatedFolder": MessageLookupByLibrary.simpleMessage(
            "Cartella creata con successo"),
        "successfullyCreatedNewAccount": MessageLookupByLibrary.simpleMessage(
            "Nuovo account creato con successo"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Cancellato con successo"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Nuovo certificato generato con successo"),
        "successfullyLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Accesso effetuato con successo"),
        "successfullyRemoved2fa":
            MessageLookupByLibrary.simpleMessage("2FA rimossa con successo"),
        "successfullyRenamed":
            MessageLookupByLibrary.simpleMessage("Rinominato con successo"),
        "successfullyResetPassword": MessageLookupByLibrary.simpleMessage(
            "Password reimpostata con successo"),
        "successfullySavedPermissions": MessageLookupByLibrary.simpleMessage(
            "Permessi salvati con successo"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "thanks": MessageLookupByLibrary.simpleMessage(
            "Grazie a tutte le generose persone per avermi sostenuto"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "I file selezionati verranno eliminati permanentemente"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Colore tema"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Memoria di sistema totale "),
        "totpCode": MessageLookupByLibrary.simpleMessage("Codice TOTP"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Riprova"),
        "twofactorAuthentication": MessageLookupByLibrary.simpleMessage(
            "Autenticazione a due fattori"),
        "untrustedCertificate":
            MessageLookupByLibrary.simpleMessage("Certificato non attendibile"),
        "upload": MessageLookupByLibrary.simpleMessage("Carica"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Carica certificato"),
        "uploadFiles": MessageLookupByLibrary.simpleMessage("Carica file"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("Carica certificato HTTPS"),
        "usable_memory":
            MessageLookupByLibrary.simpleMessage("Memoria usabile"),
        "useSystemSettings": MessageLookupByLibrary.simpleMessage(
            "Usa le impostazioni di sistema"),
        "used_memory": MessageLookupByLibrary.simpleMessage("Memoria usata"),
        "username": MessageLookupByLibrary.simpleMessage("Nome utente"),
        "verifyPasswordForRemoving2FA": MessageLookupByLibrary.simpleMessage(
            "Verificare la password e il codice 2FA per rimuovere l\'autenticazione a due fattori"),
        "verifyYourTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Verifica con autenticazione a due fattori"),
        "version": m9,
        "wrongCode": MessageLookupByLibrary.simpleMessage("Codice errato"),
        "wrongPassword":
            MessageLookupByLibrary.simpleMessage("Password errata"),
        "wrongUsernameOrPassword": MessageLookupByLibrary.simpleMessage(
            "Nome utente o passowrd errati"),
        "yes": MessageLookupByLibrary.simpleMessage("Si"),
        "youAlreadyAddedThisServer": MessageLookupByLibrary.simpleMessage(
            "Hai già aggiunto questo server"),
        "youAlreadyConfigured2FA": MessageLookupByLibrary.simpleMessage(
            "Hai già configurato l\'autenticazione a due fattori, vuoi rimuoverla?")
      };
}
