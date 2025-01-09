// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static String m0(name) => "Account ${name}";

  static String m10(diskname) => "Freier Festplattenspeicher (${diskname})";

  static String m1(ip) => "\"${ip}\" kann nicht erreicht werden";

  static String m2(ip) => "\"${ip}\" kann nicht über HTTPS erreicht werden";

  static String m3(name) => "Programmiert von ${name}";

  static String m4(accountName) =>
      "Der Account \"${accountName}\" wird dauerhaft gelöscht.";

  static String m5(name) => "\"${name}\" wird dauerhaft gelöscht.";

  static String m6(routeTitle) => "\"${routeTitle}\" löschen";

  static String m11(diskname) => "Festplattennutzung (${diskname})";

  static String m7(filename) => "\"${filename}\" erfolgreich heruntergeladen.";

  static String m12(fileEntry) =>
      "${fileEntry} wird extrahiert, dabei werden vorhandene Dateien überschrieben. Dies kann nicht Rückgängig gemacht werden!";

  static String m8(name) => "Datei \"${name}\"";

  static String m9(version) => "Version: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Diese App setzt vorraus, dass ein Plugin auf deinem vorhandenen Minecraft-Server installiert ist. Bitte klicke auf \"Weitere Infos\" für ... weitere Infos :)"),
        "about": MessageLookupByLibrary.simpleMessage("Über"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("Über ServerCtrl"),
        "acceptNewCert": MessageLookupByLibrary.simpleMessage(
            "Das Zertifikat hat sich geändert. Bitte verifiziere und akzeptiere das neue Zertifikat."),
        "acceptWarningTryAgain": MessageLookupByLibrary.simpleMessage(
            "Bitte akzeptiere die Warnung und logge dich erneut ein"),
        "account": MessageLookupByLibrary.simpleMessage("Konto"),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "add2FAtoApp": MessageLookupByLibrary.simpleMessage(
            "Bitte füge die Zwei-Faktor-Authentisierung zu deiner App hinzu (z. B. Google Authenticator) indem du den QR-Code scannst oder das Secret kopierst"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Minecraft-Server hinzufügen"),
        "add_server": MessageLookupByLibrary.simpleMessage("Server hinzufügen"),
        "allYourChangesWillBeLost": MessageLookupByLibrary.simpleMessage(
            "Alle deine Änderungen gehen verloren."),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Zugewiesener Speicher"),
        "appearance": MessageLookupByLibrary.simpleMessage("Erscheinungsbild"),
        "availableDiskSpace": m10,
        "ban": MessageLookupByLibrary.simpleMessage("BAN"),
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "cannotConnectMaybeCredentials": MessageLookupByLibrary.simpleMessage(
            "Kann keine Verbindung zum Server herstellen, vielleicht haben sich die Anmeldeinformationen geändert?"),
        "cannotFindCredentials": MessageLookupByLibrary.simpleMessage(
            "Die Zugangsdaten für diesen Server wurden nicht gefunden, bitte füg ihn erneut hinzu"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer": MessageLookupByLibrary.simpleMessage(
            "Der Server kann nicht erreicht werden"),
        "casesensitive": MessageLookupByLibrary.simpleMessage(
            "Groß-/Kleinschreibung beachten"),
        "certCannotBeVerified": MessageLookupByLibrary.simpleMessage(
            "Das Zertifikat des Servers kann nicht überprüft werden. Wilst du ihm vertrauen? SHA1-Fingerabdruck des Zertifikats:"),
        "certificateFile":
            MessageLookupByLibrary.simpleMessage("Zertifikatsdatei"),
        "certificateKeyFile":
            MessageLookupByLibrary.simpleMessage("Zertifikatsschlüssel-Datei"),
        "certificateUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Zertifikat erfolgreich hochgeladen"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Passwort ändern"),
        "close": MessageLookupByLibrary.simpleMessage("Schließen"),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("Befehl"),
        "configureTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Zwei-Faktor-Authentisierung konfigurieren"),
        "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "connectionFailed":
            MessageLookupByLibrary.simpleMessage("Verbindung fehlgeschlagen"),
        "console": MessageLookupByLibrary.simpleMessage("Konsole"),
        "copySecret": MessageLookupByLibrary.simpleMessage("Secret kopieren"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("CPU Kerne"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU Last"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("CPU-Nutzung"),
        "create": MessageLookupByLibrary.simpleMessage("Erstellen"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Account erstellen"),
        "createFile": MessageLookupByLibrary.simpleMessage("Datei erstellen"),
        "createFolder":
            MessageLookupByLibrary.simpleMessage("Ordner erstellen"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Aktuelles Passwort"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Dunkel"),
        "dataPrivacy": MessageLookupByLibrary.simpleMessage("Datenschutz"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("Standard"),
        "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Account löschen?"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("Löschen?"),
        "deleteFileMessage": m5,
        "deleteFiles": MessageLookupByLibrary.simpleMessage("Dateien löschen?"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("DE-OP"),
        "design": MessageLookupByLibrary.simpleMessage("Design"),
        "directory": MessageLookupByLibrary.simpleMessage("Ordner"),
        "discard": MessageLookupByLibrary.simpleMessage("Verwerfen"),
        "discardChanges":
            MessageLookupByLibrary.simpleMessage("Änderungen verwerfen?"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "diskUsage": m11,
        "donate": MessageLookupByLibrary.simpleMessage("Spenden"),
        "download": MessageLookupByLibrary.simpleMessage("Herunterladen"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Heruntergeladen"),
        "downloadedFilenameSuccessfully": m7,
        "downloading": MessageLookupByLibrary.simpleMessage("Herunterladen"),
        "dynamicColor":
            MessageLookupByLibrary.simpleMessage("Dynamische Farbe"),
        "edit": MessageLookupByLibrary.simpleMessage("Bearbeiten"),
        "egWithGoogleAuthenticator": MessageLookupByLibrary.simpleMessage(
            "z. B. mit Google Authenticator"),
        "email": MessageLookupByLibrary.simpleMessage("E-Mail"),
        "errorCreatingAccount": MessageLookupByLibrary.simpleMessage(
            "Fehler beim erstellen des Accounts"),
        "errorCreatingFile": MessageLookupByLibrary.simpleMessage(
            "Fehler beim erstellen der Datei"),
        "errorCreatingFolder": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Erstellen des Ordners"),
        "errorDeletingAccount": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Löschen des Accounts"),
        "errorDeletingFile": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Löschen des Objekts"),
        "errorDeletingFiles": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Löschen der Dateien"),
        "errorExtractingFile":
            MessageLookupByLibrary.simpleMessage("Fehler beim Extrahieren"),
        "errorInputMissing": MessageLookupByLibrary.simpleMessage(
            "Bitte gebe deine Serveradresse, deinen Benutzernamen UND dein Passwort ein"),
        "errorRenamingType": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Umbenennen des Objekts"),
        "errorResettingPassword": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Zurücksetzen des Passworts"),
        "errorSavingPermissions": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Speichern der Berechtigungen"),
        "errorWhileDownloadingFile": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Herunterladen der Datei"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Fehler beim generieren des Zertifikats"),
        "errorWhileRemoving2fa": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Entfernen der 2FA"),
        "errorWhileSavingChanges": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Speichern der Änderungen"),
        "errorWhileSavingFile": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Speichern der Datei"),
        "errorWhileUploadingCertificate": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Hochladen des Zertifikats"),
        "errorWhileUploadingFile": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Hochladen der Datei"),
        "error_sending_command": MessageLookupByLibrary.simpleMessage(
            "Fehler beim Senden des Befehls"),
        "extract": MessageLookupByLibrary.simpleMessage("Extrahieren"),
        "extractFile":
            MessageLookupByLibrary.simpleMessage("Datei extrahieren"),
        "extractFileMessage": m12,
        "file": MessageLookupByLibrary.simpleMessage("Datei"),
        "fileAndName": m8,
        "fileSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Datei erfolgreich gespeichert"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage("Datei zu groß"),
        "fileTooLargeText": MessageLookupByLibrary.simpleMessage(
            "Die Datei ist zu groß für den internen Editor."),
        "files": MessageLookupByLibrary.simpleMessage("Dateien"),
        "filesUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Datei(en) erfolgreich hochgeladen"),
        "free_memory": MessageLookupByLibrary.simpleMessage("Freier Speicher"),
        "generate": MessageLookupByLibrary.simpleMessage("Generieren"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Zertifikat generieren"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Neues HTTPS-Zertifikat erstellen"),
        "getInTouch": MessageLookupByLibrary.simpleMessage("Kontaktiere mich"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "help": MessageLookupByLibrary.simpleMessage("Hilfe"),
        "helpMe": MessageLookupByLibrary.simpleMessage("Unterstütze mich"),
        "helpMeKeepThisAppAlive": MessageLookupByLibrary.simpleMessage(
            "Hilf mir, diese App am Leben zu erhalten"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "howCanILogIn": MessageLookupByLibrary.simpleMessage(
            "Wie kann ich mich einloggen?"),
        "howCanILogInText": MessageLookupByLibrary.simpleMessage(
            "Nachdem du das Plugin auf deinem Bukkit / Spigot / Paper server installiert hast, wird dir in der Console das Passwort für den Nutzer \"admin\" angezeigt. Dies passiert nur beim ersten start oder wenn kein Nutzer mit dem Namen \"admin\" vorhanden ist.\n\nWenn du das Passwort vergisst oder den Consolen-Log nicht mehr hast, kannst du einfach die Datei \"config.yml\" in dem Ordner \"ServerCtrl\" löschen oder auch nur den Nutzer \"admin\" in dieser Datei.\n\nFür mehr hilfe trete meinem Discord-Channel bei."),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "important": MessageLookupByLibrary.simpleMessage("WICHTIG!"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Bitte beachte, dass du zuerst das ServerCtrl-Plugin installieren musst"),
        "inputYourPassword":
            MessageLookupByLibrary.simpleMessage("Gebe dein Passwort ein"),
        "inputYourPasswordAndCurrent2fa": MessageLookupByLibrary.simpleMessage(
            "Gebe dein Passwort und aktuellen 2FA-Code ein"),
        "ipOrHostname":
            MessageLookupByLibrary.simpleMessage("IP oder Hostname"),
        "kick": MessageLookupByLibrary.simpleMessage("KICK"),
        "language": MessageLookupByLibrary.simpleMessage("Sprache"),
        "licenses": MessageLookupByLibrary.simpleMessage("Lizenzen"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Hell"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Anmeldung"),
        "login": MessageLookupByLibrary.simpleMessage("Anmelden"),
        "longPressEntryToDeleteIt": MessageLookupByLibrary.simpleMessage(
            "Eintrag lang drücken, um ihn zu löschen"),
        "material3": MessageLookupByLibrary.simpleMessage("Material 3"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("Speichernutzung"),
        "moreInfo": MessageLookupByLibrary.simpleMessage("Mehr Infos"),
        "multipleFiles":
            MessageLookupByLibrary.simpleMessage("Mehrere Dateien"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "newFile": MessageLookupByLibrary.simpleMessage("Neue Datei"),
        "newFolder": MessageLookupByLibrary.simpleMessage("Neuer Ordner"),
        "newPassword": MessageLookupByLibrary.simpleMessage("Neues Passwort"),
        "newServer": MessageLookupByLibrary.simpleMessage("Neuer Server"),
        "newServerAdded": MessageLookupByLibrary.simpleMessage(
            "Der neue Server wurde erfolgreich hinzugefügt"),
        "no": MessageLookupByLibrary.simpleMessage("Nein"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("Keine Datei ausgewählt"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("Keine Spieler online"),
        "nothingSelected":
            MessageLookupByLibrary.simpleMessage("Nichts ausgewählt"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP"),
        "openWith": MessageLookupByLibrary.simpleMessage("Öffnen mit"),
        "password": MessageLookupByLibrary.simpleMessage("Passwort"),
        "passwordChangedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Passwort erfolgreich geändert"),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
            "Passwörter stimmen nicht überein"),
        "permissions": MessageLookupByLibrary.simpleMessage("Berechtigungen"),
        "players": MessageLookupByLibrary.simpleMessage("Spieler"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Bitte erlaube Zugriff auf den Speicher"),
        "pleaseInputYourCode":
            MessageLookupByLibrary.simpleMessage("Bitte gebe deinen Code ein"),
        "pleaseInputYourUsernameAndPassword":
            MessageLookupByLibrary.simpleMessage(
                "Bitte gebe dein Benutzername und Passwort ein"),
        "pleasePutInYourCurrentPassword": MessageLookupByLibrary.simpleMessage(
            "Bitte gebe dein aktuelles Passwort ein"),
        "pleaseWait": MessageLookupByLibrary.simpleMessage("Bitte warten"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginAndWebserverPort":
            MessageLookupByLibrary.simpleMessage("Plugin- und Webserver-Port"),
        "port": MessageLookupByLibrary.simpleMessage("Port"),
        "regex": MessageLookupByLibrary.simpleMessage("RegEx"),
        "remove": MessageLookupByLibrary.simpleMessage("Entfernen"),
        "removeTwofactorAuthentication": MessageLookupByLibrary.simpleMessage(
            "Zwei-Faktor-Authentisierung entfernen?"),
        "rename": MessageLookupByLibrary.simpleMessage("Umbenennen"),
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Neues Passwort wiederholen"),
        "reset": MessageLookupByLibrary.simpleMessage("Zurücksetzen"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Passwort zurücksetzen"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Passwort zurücksetzen"),
        "restartToApplyLanguage": MessageLookupByLibrary.simpleMessage(
            "Bitte starten Sie die App neu, damit die neue Sprache vollständig übernommen wird."),
        "save": MessageLookupByLibrary.simpleMessage("Speichern"),
        "saveFile": MessageLookupByLibrary.simpleMessage("Datei speichern"),
        "savedChanges":
            MessageLookupByLibrary.simpleMessage("Änderungen speichern"),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Erfolgreich gespeichert"),
        "saving": MessageLookupByLibrary.simpleMessage("Speichern"),
        "secretCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Secret in die Zwischenablage kopiert"),
        "selectFile": MessageLookupByLibrary.simpleMessage("Datei auswählen"),
        "selectedEntryWIllBeDeleted": MessageLookupByLibrary.simpleMessage(
            "Der ausgewählte Eintrag wird dauerhaft aus der App gelöscht."),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "serverNameInput":
            MessageLookupByLibrary.simpleMessage("Servername (frei wählbar)"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "share": MessageLookupByLibrary.simpleMessage("Teilen"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Etwas ist schiefgelaufen"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Bitte geben Sie die Domain oder IP-Adresse des Minecraft-Servers an"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("SpigotMC"),
        "success": MessageLookupByLibrary.simpleMessage("Erfolgreich"),
        "successfullyAdded2faToYourAccount":
            MessageLookupByLibrary.simpleMessage(
                "2FA erfolgreich zu deinem Konto hinzugefügt"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("Datei erfolgreich erstellt"),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("Ordner erfolgreich erstellt"),
        "successfullyCreatedNewAccount": MessageLookupByLibrary.simpleMessage(
            "Neuer Account erfolgreich erstellt"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Erfolgreich gelöscht"),
        "successfullyExtracted":
            MessageLookupByLibrary.simpleMessage("Erfolgreich extrahiert"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Neues Zertifikat erfolgreich generiert"),
        "successfullyLoggedIn":
            MessageLookupByLibrary.simpleMessage("Erfolgreich angemeldet"),
        "successfullyRemoved2fa":
            MessageLookupByLibrary.simpleMessage("2FA erfolgreich entfernt"),
        "successfullyRenamed":
            MessageLookupByLibrary.simpleMessage("Erfolgreich umbenannt"),
        "successfullyResetPassword": MessageLookupByLibrary.simpleMessage(
            "Passwort erfolgreich zurückgesetzt"),
        "successfullySavedPermissions": MessageLookupByLibrary.simpleMessage(
            "Berechtigungen erfolgreich gespeichert"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "thanks": MessageLookupByLibrary.simpleMessage(
            "Danke an alle netten Leute für die Unterstützung"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "Die ausgewählten Dateien werden dauerhaft gelöscht"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Themenfarbe"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Gesamter Systemspeicher"),
        "totpCode": MessageLookupByLibrary.simpleMessage("TOTP Code"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Erneut versuchen"),
        "twofactorAuthentication":
            MessageLookupByLibrary.simpleMessage("Zwei-Faktor-Authentisierung"),
        "untrustedCertificate": MessageLookupByLibrary.simpleMessage(
            "Nicht vertrauenswürdiges Zertifikat"),
        "upload": MessageLookupByLibrary.simpleMessage("Hochladen"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Zertifikat hochladen"),
        "uploadFiles":
            MessageLookupByLibrary.simpleMessage("Datei(en) hochladen"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("HTTPS-Zertifikat hochladen"),
        "usable_memory":
            MessageLookupByLibrary.simpleMessage("Nutzbarer Speicher"),
        "useSystemSettings":
            MessageLookupByLibrary.simpleMessage("Systemeinstellungen"),
        "used_memory":
            MessageLookupByLibrary.simpleMessage("Verwendeter Speicher"),
        "username": MessageLookupByLibrary.simpleMessage("Benutzername"),
        "verifyPasswordForRemoving2FA": MessageLookupByLibrary.simpleMessage(
            "Bitte verifiziere dein Passwort und 2FA-Code um die Zwei-Faktor-Authentisierung zu entfernen"),
        "verifyYourTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Verifiziere deine Zwei-Faktor-Authentisierung"),
        "version": m9,
        "wrongCode": MessageLookupByLibrary.simpleMessage("Falscher Code"),
        "wrongPassword":
            MessageLookupByLibrary.simpleMessage("Falsches Passwort"),
        "wrongUsernameOrPassword": MessageLookupByLibrary.simpleMessage(
            "Falscher Benutzername oder falsches Passwort"),
        "yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "youAlreadyAddedThisServer": MessageLookupByLibrary.simpleMessage(
            "Du hast diesen Server bereits hinzugefügt"),
        "youAlreadyConfigured2FA": MessageLookupByLibrary.simpleMessage(
            "Du hast bereits die Zwei-Faktor-Authentisierung konfiguriert, möchtest du Sie entfernen?")
      };
}
