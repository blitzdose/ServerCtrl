// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
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
  String get localeName => 'nl';

  static String m0(name) => "Account ${name}";

  static String m1(ip) => "Kan \"${ip}\" niet bereiken";

  static String m2(ip) => "Kan \"${ip}\" niet bereiken over HTTPS";

  static String m3(name) => "Geprogrammeerd door ${name}";

  static String m4(accountName) =>
      "Het account \"${accountName}\" zal permanent verwijderd worden.";

  static String m5(name) => "\"${name}\" zal permanent verwijderd worden.";

  static String m6(routeTitle) => "Verwijder \"${routeTitle}\"";

  static String m7(filename) => "\"${filename}\" succesvol gedownload";

  static String m8(name) => "Bestand \"${name}\"";

  static String m9(version) => "Versie: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Voor deze app moet een plugin op uw bestaande Minecraft-server worden geïnstalleerd. Klik op \"Meer informatie\" voor ... nou ja ... meer info :)"),
        "about": MessageLookupByLibrary.simpleMessage("Over"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("Over ServerCtrl"),
        "acceptNewCert": MessageLookupByLibrary.simpleMessage(
            "Het certificaat is gewijzigd. Verifieer en accepteer het nieuwe certificaat."),
        "acceptWarningTryAgain": MessageLookupByLibrary.simpleMessage(
            "Accepteer de waarschuwing en log opnieuw in"),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Minecraft-server toevoegen"),
        "add_server": MessageLookupByLibrary.simpleMessage("Server Toevoegen"),
        "allYourChangesWillBeLost": MessageLookupByLibrary.simpleMessage(
            "Alle veranderingen zullen verwijderd worden"),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Toegewezen geheugen"),
        "appearance": MessageLookupByLibrary.simpleMessage("Uiterlijk"),
        "ban": MessageLookupByLibrary.simpleMessage("Verbannen"),
        "cancel": MessageLookupByLibrary.simpleMessage("Afbreken"),
        "cannotConnectMaybeCredentials": MessageLookupByLibrary.simpleMessage(
            "Kan geen verbinding maken met de server, misschien zijn de inloggegevens veranderd?"),
        "cannotFindCredentials": MessageLookupByLibrary.simpleMessage(
            "Kan geen aanmeldgegevens vinden voor deze server,  probeer deze opnieuw toe te voegen"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer":
            MessageLookupByLibrary.simpleMessage("Kan de server niet bereiken"),
        "certCannotBeVerified": MessageLookupByLibrary.simpleMessage(
            "Het certificaat van de server kan niet geverifieerd worden. Wil je doorgaan? SHA-1 vingerafdruk van het certificaat:"),
        "certificateFile": MessageLookupByLibrary.simpleMessage("Certificaat"),
        "certificateKeyFile":
            MessageLookupByLibrary.simpleMessage("Certificaatssleutel"),
        "certificateUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Certificaat succesvol geüpload"),
        "close": MessageLookupByLibrary.simpleMessage("Sluiten"),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("Commando"),
        "connectionFailed":
            MessageLookupByLibrary.simpleMessage("Verbinding mislukt"),
        "console": MessageLookupByLibrary.simpleMessage("Console"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("CPU kernen"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU gebruik"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("CPU gebruik"),
        "create": MessageLookupByLibrary.simpleMessage("Aanmaken"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Account aanmaken"),
        "createFile": MessageLookupByLibrary.simpleMessage("Bestand aanmaken"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Map aanmaken"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Donkere Modus"),
        "dataPrivacy": MessageLookupByLibrary.simpleMessage("Data privacy"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("Standaard"),
        "delete": MessageLookupByLibrary.simpleMessage("Verwijderen"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Account verwijderen?"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("Verwijderen?"),
        "deleteFileMessage": m5,
        "deleteFiles":
            MessageLookupByLibrary.simpleMessage("Bestanden verwijderen?"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("OP permissie opheffen"),
        "design": MessageLookupByLibrary.simpleMessage("Ontwerp"),
        "directory": MessageLookupByLibrary.simpleMessage("map"),
        "discard": MessageLookupByLibrary.simpleMessage("Verwerpen"),
        "discardChanges":
            MessageLookupByLibrary.simpleMessage("Veranderingen verwerpen?"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "donate": MessageLookupByLibrary.simpleMessage("Doneer"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Gedownload"),
        "downloadedFilenameSuccessfully": m7,
        "downloading":
            MessageLookupByLibrary.simpleMessage("Aan het downloaden"),
        "dynamicColor":
            MessageLookupByLibrary.simpleMessage("Dynamische kleur"),
        "edit": MessageLookupByLibrary.simpleMessage("Bewerken"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "errorCreatingAccount": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het aanmaken van het nieuwe account"),
        "errorCreatingFile": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het aanmaken van het bestand"),
        "errorCreatingFolder": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het aanmaken van de map"),
        "errorDeletingAccount": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het verwijderen van het account"),
        "errorDeletingFile": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het verwijderen van dit object"),
        "errorDeletingFiles": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het verwijderen van de bestanden"),
        "errorInputMissing": MessageLookupByLibrary.simpleMessage(
            "Geef een serveradres, gebruiksnaam en wachtwoord op"),
        "errorRenamingType": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het hernoemen van dit object"),
        "errorResettingPassword": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het resetten van het wachtwoord"),
        "errorSavingPermissions": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het opslaan van de permissies"),
        "errorWhileDownloadingFile": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het downloaden van het bestand"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het aanmaken van het nieuwe certificaat"),
        "errorWhileSavingChanges": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het opslaan"),
        "errorWhileSavingFile": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het opslaan van dit bestand"),
        "errorWhileUploadingCertificate": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het uploaden van het certificaat"),
        "errorWhileUploadingFile": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden tijdens het uploaden van dit bestand"),
        "error_sending_command": MessageLookupByLibrary.simpleMessage(
            "Er is een fout opgetreden bij het verzenden van het commando"),
        "file": MessageLookupByLibrary.simpleMessage("bestand"),
        "fileAndName": m8,
        "fileSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Bestanden succesvol opgeslagen"),
        "fileTooLarge":
            MessageLookupByLibrary.simpleMessage("Bestand te groot"),
        "fileTooLargeText": MessageLookupByLibrary.simpleMessage(
            "Het bestand is te groot voor de interne editor"),
        "files": MessageLookupByLibrary.simpleMessage("Bestanden"),
        "filesUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Bestand(en) succesvol geüpload"),
        "free_memory": MessageLookupByLibrary.simpleMessage("Vrij geheugen"),
        "generate": MessageLookupByLibrary.simpleMessage("Genereer"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Certificaat genereren"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Nieuw HTTPS certificaat generen"),
        "getInTouch": MessageLookupByLibrary.simpleMessage("Neem contact op"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "helpMe": MessageLookupByLibrary.simpleMessage("Help me"),
        "helpMeKeepThisAppAlive": MessageLookupByLibrary.simpleMessage(
            "Help me om deze app in leven te houden"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "important": MessageLookupByLibrary.simpleMessage("BELANGRIJK!"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Onthoud dat je eerst de ServerCtrl-plugin moet installeren"),
        "ipOrHostname": MessageLookupByLibrary.simpleMessage("IP of Hostname"),
        "kick": MessageLookupByLibrary.simpleMessage("Verbinding verbreken"),
        "language": MessageLookupByLibrary.simpleMessage("Taal"),
        "licenses": MessageLookupByLibrary.simpleMessage("Licensies"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Lichte Modus"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Aan het inloggen"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "longPressEntryToDeleteIt": MessageLookupByLibrary.simpleMessage(
            "Lang ingedrukt houden om een entry te verwijderen"),
        "material3": MessageLookupByLibrary.simpleMessage("Material 3"),
        "memory_usage":
            MessageLookupByLibrary.simpleMessage("Geheugen gebruik"),
        "moreInfo": MessageLookupByLibrary.simpleMessage("Meer informatie"),
        "multipleFiles":
            MessageLookupByLibrary.simpleMessage("Meerdere bestanden"),
        "name": MessageLookupByLibrary.simpleMessage("Naam"),
        "newFile": MessageLookupByLibrary.simpleMessage("Nieuw Bestand"),
        "newFolder": MessageLookupByLibrary.simpleMessage("Nieuwe Map"),
        "newPassword": MessageLookupByLibrary.simpleMessage("Nieuw wachtwoord"),
        "newServer": MessageLookupByLibrary.simpleMessage("Nieuwe server"),
        "newServerAdded": MessageLookupByLibrary.simpleMessage(
            "De server is succesvol toegevoegd"),
        "no": MessageLookupByLibrary.simpleMessage("Nee"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("Geen bestand geselecteerd"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("Er zijn geen spelers online"),
        "nothingSelected":
            MessageLookupByLibrary.simpleMessage("Niks geselecteerd"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP permissie verlenen"),
        "openWith": MessageLookupByLibrary.simpleMessage("Openen met"),
        "password": MessageLookupByLibrary.simpleMessage("Wachtwoord"),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
            "Wachtwoorden komen niet overeen"),
        "permissions": MessageLookupByLibrary.simpleMessage("Permissies"),
        "players": MessageLookupByLibrary.simpleMessage("Spelers"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Geef a.u.b. toegang tot de opslag"),
        "pleaseInputYourUsernameAndPassword":
            MessageLookupByLibrary.simpleMessage(
                "Geef een gebruiksnaam en wachtwoord op"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginAndWebserverPort":
            MessageLookupByLibrary.simpleMessage("Plugin en Webserver Poort"),
        "port": MessageLookupByLibrary.simpleMessage("Poort"),
        "rename": MessageLookupByLibrary.simpleMessage("Hernoemen"),
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Nieuw wachtwoord herhalen"),
        "reset": MessageLookupByLibrary.simpleMessage("Resetten"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Wachtwoord resetten"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Wachtwoord resetten"),
        "restartToApplyLanguage": MessageLookupByLibrary.simpleMessage(
            "Herstart de app om de nieuwe taal in werking te laten treden"),
        "save": MessageLookupByLibrary.simpleMessage("Opslaan"),
        "saveFile": MessageLookupByLibrary.simpleMessage("Bestand opslaan"),
        "savedChanges":
            MessageLookupByLibrary.simpleMessage("Veranderingen opgeslagen"),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Succesvol opgeslagen"),
        "saving": MessageLookupByLibrary.simpleMessage("Aan het opslaan"),
        "selectFile":
            MessageLookupByLibrary.simpleMessage("Bestand selecteren"),
        "selectedEntryWIllBeDeleted": MessageLookupByLibrary.simpleMessage(
            "De geselecteerde entries zullen permanent verwijderd worden van de app"),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "serverNameInput":
            MessageLookupByLibrary.simpleMessage("Servernaam (vrij te kiezen)"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Instellingen"),
        "share": MessageLookupByLibrary.simpleMessage("Delen"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Er is iets misgegaan"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Geef het domein of het IP-adres van de Minecraft server op"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("SpigotMC"),
        "success": MessageLookupByLibrary.simpleMessage("Succes"),
        "successfullyCreatedFile": MessageLookupByLibrary.simpleMessage(
            "Bestand succesvol aangemaakt"),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("Map succesvol aangemaakt"),
        "successfullyCreatedNewAccount": MessageLookupByLibrary.simpleMessage(
            "Het nieuwe account is succesvol aangemaakt"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Succesvol verwijdered"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Nieuw certificaat succesvol aangemaakt"),
        "successfullyLoggedIn":
            MessageLookupByLibrary.simpleMessage("Succesvol ingelogd"),
        "successfullyRenamed":
            MessageLookupByLibrary.simpleMessage("Succesvol hernoemd"),
        "successfullyResetPassword": MessageLookupByLibrary.simpleMessage(
            "Wachtwoord succesvol gereset"),
        "successfullySavedPermissions": MessageLookupByLibrary.simpleMessage(
            "Permissies succesvol opgeslagen"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "thanks": MessageLookupByLibrary.simpleMessage(
            "Ik bedank iedereen voor de geleverde support"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "De geselecteerde bestanden zullen permanent verwijderd worden"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Themakleur"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Totaal geheugen"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Opnieuw proberen"),
        "untrustedCertificate":
            MessageLookupByLibrary.simpleMessage("Ondertrouwd certificaat"),
        "upload": MessageLookupByLibrary.simpleMessage("Uploaden"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Certificaat uploaden"),
        "uploadFiles":
            MessageLookupByLibrary.simpleMessage("Bestand(en) uploaden"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("HTTPS certificaat uploaden"),
        "usable_memory":
            MessageLookupByLibrary.simpleMessage("Bruikbaar geheugen"),
        "useSystemSettings": MessageLookupByLibrary.simpleMessage(
            "Systeeminstellingen gebruiken"),
        "used_memory":
            MessageLookupByLibrary.simpleMessage("Gebruikt geheugen"),
        "username": MessageLookupByLibrary.simpleMessage("Gebruiksnaam"),
        "version": m9,
        "wrongUsernameOrPassword": MessageLookupByLibrary.simpleMessage(
            "De gebruiksnaam of wachtwoord is incorrect"),
        "yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "youAlreadyAddedThisServer": MessageLookupByLibrary.simpleMessage(
            "Je hebt deze server al toegevoegd")
      };
}
