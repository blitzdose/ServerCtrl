// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs locale. All the
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
  String get localeName => 'cs';

  static String m0(name) => "Účet ${name}";

  static String m1(ip) => "Server \"${ip}\" neobjeven";

  static String m2(ip) => "Nelze objevit server \"${ip}\" přes HTTPS";

  static String m3(name) => "Nakódoval ${name}";

  static String m4(accountName) => "Účet \"${accountName}\" bude odstraněn.";

  static String m5(name) => "\"${name}\" bude odstraněn.";

  static String m6(routeTitle) => "Odstranit \"${routeTitle}\"";

  static String m7(filename) => "Soubor \"${filename}\" byl úspěšně stažen.";

  static String m8(name) => "Soubor \"${name}\"";

  static String m9(version) => "Verze: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Tato aplikace vyžaduje instalaci pluginu na Vašem Minecraft serveru. Prosím klikněte na \"Více info\" pro... no... více info :)"),
        "about": MessageLookupByLibrary.simpleMessage("Informace"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("Ohledně ServerCtrl"),
        "acceptNewCert": MessageLookupByLibrary.simpleMessage(
            "Certifikát změněn. Prosím ověřte a přijměte nový certifikát."),
        "acceptWarningTryAgain": MessageLookupByLibrary.simpleMessage(
            "Přijměte prosím varování a přihlašte se znovu"),
        "account": MessageLookupByLibrary.simpleMessage("Účet"),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Účty"),
        "add2FAtoApp": MessageLookupByLibrary.simpleMessage(
            "Prosím přidejte toto dvoufázové ověření do Vaší aplikace (např. Google Authenticator) pomocí skenu QR-kódu nebo zkopírování tajného klíče."),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Přidat Minecraft server"),
        "add_server": MessageLookupByLibrary.simpleMessage("Přidat Server"),
        "allYourChangesWillBeLost": MessageLookupByLibrary.simpleMessage(
            "Všechny změny budou ztraceny"),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Přidělená paměť"),
        "appearance": MessageLookupByLibrary.simpleMessage("Vzhled"),
        "ban": MessageLookupByLibrary.simpleMessage("ZABANOVAT"),
        "cancel": MessageLookupByLibrary.simpleMessage("Zrušit"),
        "cannotConnectMaybeCredentials": MessageLookupByLibrary.simpleMessage(
            "Nelze se připojit k serveru, možná došlo k změně údajů?"),
        "cannotFindCredentials": MessageLookupByLibrary.simpleMessage(
            "Nlease add it againelze najít údaje k serveru, prosím přidejte je znovu"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer":
            MessageLookupByLibrary.simpleMessage("Nelze se připojit k serveru"),
        "certCannotBeVerified": MessageLookupByLibrary.simpleMessage(
            "Certifikát serveru nelze ověřit. Chcete ho ověřit? SHA1 otisk certifikátu:"),
        "certificateFile": MessageLookupByLibrary.simpleMessage("Certifikát"),
        "certificateKeyFile":
            MessageLookupByLibrary.simpleMessage("Soubor certifikátu"),
        "certificateUploadedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Certifikát úspěšně nahrán"),
        "changePassword": MessageLookupByLibrary.simpleMessage("Změnit heslo"),
        "close": MessageLookupByLibrary.simpleMessage("Zavřít"),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("Příkaz"),
        "configureTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Nastavit dvoufázové ověřování"),
        "confirm": MessageLookupByLibrary.simpleMessage("Potvrdit"),
        "connectionFailed":
            MessageLookupByLibrary.simpleMessage("Připojení se nezdařilo"),
        "console": MessageLookupByLibrary.simpleMessage("Konzole"),
        "copySecret": MessageLookupByLibrary.simpleMessage("Zkopírovat klíč"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("GPU jádra"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU zátěž"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("Využití CPU"),
        "create": MessageLookupByLibrary.simpleMessage("Vytvořit"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Vytvořit heslo"),
        "createFile": MessageLookupByLibrary.simpleMessage("Vytvořit soubor"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Vytvořit složku"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Aktuální heslo"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Tmavý režim"),
        "dataPrivacy": MessageLookupByLibrary.simpleMessage("Soukromí dat"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("Výchozí"),
        "delete": MessageLookupByLibrary.simpleMessage("Odstranit"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Opravdu odstranit?"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("Odstranit?"),
        "deleteFileMessage": m5,
        "deleteFiles": MessageLookupByLibrary.simpleMessage("Smazat soubory?"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("DE-OP"),
        "design": MessageLookupByLibrary.simpleMessage("Vzhled"),
        "directory": MessageLookupByLibrary.simpleMessage("složka"),
        "discard": MessageLookupByLibrary.simpleMessage("Zrušit"),
        "discardChanges": MessageLookupByLibrary.simpleMessage("Zrušit změny?"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "donate": MessageLookupByLibrary.simpleMessage("Přispět"),
        "download": MessageLookupByLibrary.simpleMessage("Stáhnout"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Staženo"),
        "downloadedFilenameSuccessfully": m7,
        "downloading": MessageLookupByLibrary.simpleMessage("Stahování"),
        "dynamicColor":
            MessageLookupByLibrary.simpleMessage("Dynamické zabarvení"),
        "edit": MessageLookupByLibrary.simpleMessage("Upravit"),
        "egWithGoogleAuthenticator": MessageLookupByLibrary.simpleMessage(
            "např. pomocí Google Authenticator"),
        "email": MessageLookupByLibrary.simpleMessage("E-Mail"),
        "errorCreatingAccount": MessageLookupByLibrary.simpleMessage(
            "Během tvoření nového účtu se naskytl problém"),
        "errorCreatingFile":
            MessageLookupByLibrary.simpleMessage("Chyba při vytváření souboru"),
        "errorCreatingFolder":
            MessageLookupByLibrary.simpleMessage("Chyba při vytváření složky"),
        "errorDeletingAccount": MessageLookupByLibrary.simpleMessage(
            "Během mazání účtu se naskytl problém"),
        "errorDeletingFile": MessageLookupByLibrary.simpleMessage(
            "Chyba při odstraňování souboru"),
        "errorDeletingFiles":
            MessageLookupByLibrary.simpleMessage("Chyba při mazání souborů"),
        "errorInputMissing": MessageLookupByLibrary.simpleMessage(
            "Prosím zadejte adresu Vašeho serveru, přezdívku A heslo"),
        "errorRenamingType": MessageLookupByLibrary.simpleMessage(
            "Chyba při přejmenovávání souboru"),
        "errorResettingPassword": MessageLookupByLibrary.simpleMessage(
            "Během resetování hesla se naskytl problém"),
        "errorSavingPermissions": MessageLookupByLibrary.simpleMessage(
            "Během ukládání oprávnění se naskytl problém"),
        "errorWhileDownloadingFile":
            MessageLookupByLibrary.simpleMessage("Chyba při stahování souboru"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Během vytváření certifikátu se naskytl problém"),
        "errorWhileRemoving2fa":
            MessageLookupByLibrary.simpleMessage("Chyba při odebírání 2FA"),
        "errorWhileSavingChanges": MessageLookupByLibrary.simpleMessage(
            "Během ukládání změn se naskytl problém"),
        "errorWhileSavingFile":
            MessageLookupByLibrary.simpleMessage("Chyba při ukládání souboru"),
        "errorWhileUploadingCertificate": MessageLookupByLibrary.simpleMessage(
            "Během nahrávání certifikátu se naskytl problém"),
        "errorWhileUploadingFile": MessageLookupByLibrary.simpleMessage(
            "Chyba při nahrávání soubor(ů)"),
        "error_sending_command": MessageLookupByLibrary.simpleMessage(
            "Během zadání příkazu se naskytl problém"),
        "file": MessageLookupByLibrary.simpleMessage("soubor"),
        "fileAndName": m8,
        "fileSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Soubor úspěšně uložen"),
        "fileTooLarge":
            MessageLookupByLibrary.simpleMessage("Soubor příliš velký"),
        "fileTooLargeText": MessageLookupByLibrary.simpleMessage(
            "Soubor, který se snažíte otevřít, je příliš velký pro interní editor."),
        "files": MessageLookupByLibrary.simpleMessage("Soubory"),
        "filesUploadedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Soubor(y) úspěšně nahrán(y)"),
        "free_memory": MessageLookupByLibrary.simpleMessage("Volná paměť"),
        "generate": MessageLookupByLibrary.simpleMessage("Vytvořit"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Vytvořit certifikát"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Vytvořit nový HTTPS certifikát"),
        "getInTouch": MessageLookupByLibrary.simpleMessage("Kontaktovat"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "help": MessageLookupByLibrary.simpleMessage("Pomoc"),
        "helpMe": MessageLookupByLibrary.simpleMessage("Podpořit tvůrce"),
        "helpMeKeepThisAppAlive":
            MessageLookupByLibrary.simpleMessage("Pomozte mi udržet aplikaci"),
        "home": MessageLookupByLibrary.simpleMessage("Domů"),
        "howCanILogIn":
            MessageLookupByLibrary.simpleMessage("Jak se přihlásit?"),
        "howCanILogInText": MessageLookupByLibrary.simpleMessage(
            "Po té co nainstalujete tento plugin na Vašem Bukkit / Spigot / Paper serveru, v konzoli se Vám ukáže heslo pro uživatele \"admin\". Heslo se ukáže pouze po prvním spuštění pluginu nebo pokud žádný \"admin\" uživatel neexistuje.\n\nPokud jste zapomněl heslo nebo nemůže heslo najít v záznamu konzole (log), jednoduše stačí smazat soubor \"config.yml\" ve složce \"ServerCtrl\", případně pouze uživatele \"admin\" uvnitř souboru.\n\nPokud potřebujete pomoc, připojte se na můj Discord server."),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "important": MessageLookupByLibrary.simpleMessage("DŮLEŽITÝ!"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Prosím, ujistěte se, že máte nainstalován ServerCtrl-Plugin"),
        "inputYourPassword":
            MessageLookupByLibrary.simpleMessage("Napište Vaše heslo"),
        "inputYourPasswordAndCurrent2fa": MessageLookupByLibrary.simpleMessage(
            "Napište Vaše heslo a aktuální 2FA"),
        "ipOrHostname": MessageLookupByLibrary.simpleMessage("IP nebo Doména"),
        "kick": MessageLookupByLibrary.simpleMessage("VYHODIT"),
        "language": MessageLookupByLibrary.simpleMessage("Jazyk"),
        "licenses": MessageLookupByLibrary.simpleMessage("Licence"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Světlý režim"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Přihlašování"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "longPressEntryToDeleteIt": MessageLookupByLibrary.simpleMessage(
            "Dlouze stiskněte pro odstranění"),
        "material3": MessageLookupByLibrary.simpleMessage("Material 3"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("Paměť CPU"),
        "moreInfo": MessageLookupByLibrary.simpleMessage("Více info"),
        "multipleFiles":
            MessageLookupByLibrary.simpleMessage("Několik souborů"),
        "name": MessageLookupByLibrary.simpleMessage("Název"),
        "newFile": MessageLookupByLibrary.simpleMessage("Nový soubor"),
        "newFolder": MessageLookupByLibrary.simpleMessage("Nová složka"),
        "newPassword": MessageLookupByLibrary.simpleMessage("Nové heslo"),
        "newServer": MessageLookupByLibrary.simpleMessage("Nový server"),
        "newServerAdded":
            MessageLookupByLibrary.simpleMessage("Server úspěšně přidán"),
        "no": MessageLookupByLibrary.simpleMessage("Ne"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("Žádný soubor nebyl zvolen"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("Žádní hráči online"),
        "nothingSelected":
            MessageLookupByLibrary.simpleMessage("Nic není zvoleno"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP"),
        "openWith": MessageLookupByLibrary.simpleMessage("Otevřít pomocí"),
        "password": MessageLookupByLibrary.simpleMessage("Heslo"),
        "passwordChangedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Heslo úspěšně změněno"),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Hesla nesouhlasí"),
        "permissions": MessageLookupByLibrary.simpleMessage("Oprávnění"),
        "players": MessageLookupByLibrary.simpleMessage("Hráči"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Prosím povolte přístup k souborům"),
        "pleaseInputYourCode":
            MessageLookupByLibrary.simpleMessage("Prosím vložte Váš kód"),
        "pleaseInputYourUsernameAndPassword":
            MessageLookupByLibrary.simpleMessage(
                "Prosím zadejte svoji přezdívku a heslo"),
        "pleasePutInYourCurrentPassword":
            MessageLookupByLibrary.simpleMessage("Prosím napište vaše heslo"),
        "pleaseWait": MessageLookupByLibrary.simpleMessage("Prosím počkejte"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginAndWebserverPort":
            MessageLookupByLibrary.simpleMessage("Plugin a Webserver port"),
        "port": MessageLookupByLibrary.simpleMessage("Port"),
        "remove": MessageLookupByLibrary.simpleMessage("Odebrat"),
        "removeTwofactorAuthentication": MessageLookupByLibrary.simpleMessage(
            "Odebrat dvoufázové ověřování?"),
        "rename": MessageLookupByLibrary.simpleMessage("Přejmenovat"),
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Zopakovat nové heslo"),
        "reset": MessageLookupByLibrary.simpleMessage("Resetovat"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Resetovat heslo"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Resetovat heslo"),
        "restartToApplyLanguage": MessageLookupByLibrary.simpleMessage(
            "Prosím restartujte aplikaci pro změnu jazyku"),
        "save": MessageLookupByLibrary.simpleMessage("Uložit"),
        "saveFile": MessageLookupByLibrary.simpleMessage("Uložit soubor"),
        "savedChanges": MessageLookupByLibrary.simpleMessage("Změny uloženy"),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Úspěšně uloženo"),
        "saving": MessageLookupByLibrary.simpleMessage("Ukládání"),
        "secretCopiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Klíč zkopírován"),
        "selectFile": MessageLookupByLibrary.simpleMessage("Vybrat soubor"),
        "selectedEntryWIllBeDeleted": MessageLookupByLibrary.simpleMessage(
            "Vybraný záznam bude odstraněn z aplikace"),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "serverNameInput":
            MessageLookupByLibrary.simpleMessage("Název serveru (jakýkoliv)"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Nastavení"),
        "share": MessageLookupByLibrary.simpleMessage("Sdílet"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Něco se nezdařilo"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Prosím upřesni doménu nebo IP adresu Minecraft serveru"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("SpigotMC"),
        "success": MessageLookupByLibrary.simpleMessage("Úspěch"),
        "successfullyAdded2faToYourAccount":
            MessageLookupByLibrary.simpleMessage(
                "Dvoufázové ověřování úspěšně přidán k Vašemu účtu"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("Soubor úspěšně vytvořen"),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("Složka úspěšně vytvořena"),
        "successfullyCreatedNewAccount":
            MessageLookupByLibrary.simpleMessage("Nový účet úspěšně vytvořen"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Úspěšně smazáno"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Nový certifikát úspěšně vytvořen"),
        "successfullyLoggedIn":
            MessageLookupByLibrary.simpleMessage("Úspěšně přihlášen"),
        "successfullyRemoved2fa":
            MessageLookupByLibrary.simpleMessage("2FA úspěšně odebrán"),
        "successfullyRenamed":
            MessageLookupByLibrary.simpleMessage("Úspěšně přejmenováno"),
        "successfullyResetPassword": MessageLookupByLibrary.simpleMessage(
            "Heslo bylo úspěšně resetováno"),
        "successfullySavedPermissions":
            MessageLookupByLibrary.simpleMessage("Oprávnění úspěšně uloženy"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "thanks": MessageLookupByLibrary.simpleMessage(
            "Děkuji všem, kteří se mě rozhodli podpořit"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "Zvolené soubory budou smazány"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Barva témy"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Celková paměť systému"),
        "totpCode": MessageLookupByLibrary.simpleMessage("TOTP Kód"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Zkusit znovu"),
        "twofactorAuthentication":
            MessageLookupByLibrary.simpleMessage("Dvoufázové ověření"),
        "untrustedCertificate":
            MessageLookupByLibrary.simpleMessage("Nedůvěryhodný certifikát"),
        "upload": MessageLookupByLibrary.simpleMessage("Nahrát"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Nahrát certifikát"),
        "uploadFiles": MessageLookupByLibrary.simpleMessage("Nahrát soubor(y)"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("Nahrát HTTPS certifikát"),
        "usable_memory":
            MessageLookupByLibrary.simpleMessage("Využitelná paměť"),
        "useSystemSettings":
            MessageLookupByLibrary.simpleMessage("Použít systémová nastavení"),
        "used_memory": MessageLookupByLibrary.simpleMessage("Využitá paměť"),
        "username": MessageLookupByLibrary.simpleMessage("Přezdívka"),
        "verifyPasswordForRemoving2FA": MessageLookupByLibrary.simpleMessage(
            "Prosím ověřte Vaše heslo a 2FA kód pro odebrání Vašeho dvoufázového ověřování"),
        "verifyYourTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Ověřte se pomocí dvoufázového ověření"),
        "version": m9,
        "wrongCode": MessageLookupByLibrary.simpleMessage("Nesprávný kód"),
        "wrongPassword":
            MessageLookupByLibrary.simpleMessage("Nesprávné heslo"),
        "wrongUsernameOrPassword": MessageLookupByLibrary.simpleMessage(
            "Nesprávná přezdívka nebo heslo"),
        "yes": MessageLookupByLibrary.simpleMessage("Ano"),
        "youAlreadyAddedThisServer": MessageLookupByLibrary.simpleMessage(
            "Tento server jste již přidal"),
        "youAlreadyConfigured2FA": MessageLookupByLibrary.simpleMessage(
            "Již jste nastavil dvoufázové ověřování, chcete ho odstranit?")
      };
}
