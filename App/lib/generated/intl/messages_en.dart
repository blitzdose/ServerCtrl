// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(name) => "Account ${name}";

  static String m1(ip) => "Cannot reach \"${ip}\"";

  static String m2(ip) => "Cannot reach \"${ip}\" over HTTPS";

  static String m3(name) => "Coded by ${name}";

  static String m4(accountName) =>
      "The account \"${accountName}\" will be permanently removed.";

  static String m5(name) => "\"${name}\" will be permanently removed.";

  static String m6(routeTitle) => "Delete \"${routeTitle}\"";

  static String m7(filename) => "Downloaded \"${filename}\" successfully.";

  static String m10(fileEntry) =>
      "${fileEntry} will be extracted, overwriting files if they already exist. This action cannot be undone!";

  static String m8(name) => "File \"${name}\"";

  static String m9(version) => "Version: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InstallPlugin": MessageLookupByLibrary.simpleMessage(
            "This app requires a plugin to be installed on your existing Minecraft server. Please click \"More info\" for ... well ... more info :)"),
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "aboutServerctrl":
            MessageLookupByLibrary.simpleMessage("About ServerCtrl"),
        "acceptNewCert": MessageLookupByLibrary.simpleMessage(
            "Certificate changed. Please verify and accept the new certificate."),
        "acceptWarningTryAgain": MessageLookupByLibrary.simpleMessage(
            "Please accept the warning and login again"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "add2FAtoApp": MessageLookupByLibrary.simpleMessage(
            "Please add the two-factor authentication to your App (e.g. Google Authenticator) by scanning the QR-Code or copying the secret"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Add Minecraft server"),
        "add_server": MessageLookupByLibrary.simpleMessage("Add Server"),
        "allYourChangesWillBeLost": MessageLookupByLibrary.simpleMessage(
            "All your changes will be lost"),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Allocated memory"),
        "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
        "ban": MessageLookupByLibrary.simpleMessage("BAN"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cannotConnectMaybeCredentials": MessageLookupByLibrary.simpleMessage(
            "Cannot connect to the server, maybe the credentials changed?"),
        "cannotFindCredentials": MessageLookupByLibrary.simpleMessage(
            "Cannot find credentials to this server, please add it again"),
        "cannotReachIp": m1,
        "cannotReachIpOverHttps": m2,
        "cannotReachTheServer":
            MessageLookupByLibrary.simpleMessage("Cannot reach the server"),
        "certCannotBeVerified": MessageLookupByLibrary.simpleMessage(
            "The certificate of the server cannot be verified. Do you want to trust it? SHA1 fingerprint of the certificate:"),
        "certificateFile":
            MessageLookupByLibrary.simpleMessage("Certificate file"),
        "certificateKeyFile":
            MessageLookupByLibrary.simpleMessage("Certificate key file"),
        "certificateUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Certificate uploaded successfully"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "codedBy": m3,
        "command": MessageLookupByLibrary.simpleMessage("Command"),
        "configureTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Configure Two-factor authentication"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "connectionFailed":
            MessageLookupByLibrary.simpleMessage("Connection failed"),
        "console": MessageLookupByLibrary.simpleMessage("Console"),
        "copySecret": MessageLookupByLibrary.simpleMessage("Copy secret"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("CPU cores"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU load"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("CPU Usage"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
        "createFile": MessageLookupByLibrary.simpleMessage("Create File"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Create Folder"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Current password"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "dataPrivacy": MessageLookupByLibrary.simpleMessage("Data privacy"),
        "defaultStr": MessageLookupByLibrary.simpleMessage("Default"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Delete account?"),
        "deleteAccountMessage": m4,
        "deleteFile": MessageLookupByLibrary.simpleMessage("Delete?"),
        "deleteFileMessage": m5,
        "deleteFiles": MessageLookupByLibrary.simpleMessage("Delete files?"),
        "deleteRoutetitle": m6,
        "deop": MessageLookupByLibrary.simpleMessage("DE-OP"),
        "design": MessageLookupByLibrary.simpleMessage("Design"),
        "directory": MessageLookupByLibrary.simpleMessage("directory"),
        "discard": MessageLookupByLibrary.simpleMessage("Discard"),
        "discardChanges":
            MessageLookupByLibrary.simpleMessage("Discard changes?"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "donate": MessageLookupByLibrary.simpleMessage("Donate"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Downloaded"),
        "downloadedFilenameSuccessfully": m7,
        "downloading": MessageLookupByLibrary.simpleMessage("Downloading"),
        "dynamicColor": MessageLookupByLibrary.simpleMessage("Dynamic color"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "egWithGoogleAuthenticator": MessageLookupByLibrary.simpleMessage(
            "e.g. with Google Authenticator"),
        "email": MessageLookupByLibrary.simpleMessage("E-Mail"),
        "errorCreatingAccount":
            MessageLookupByLibrary.simpleMessage("Error creating account"),
        "errorCreatingFile":
            MessageLookupByLibrary.simpleMessage("Error creating file"),
        "errorCreatingFolder":
            MessageLookupByLibrary.simpleMessage("Error creating folder"),
        "errorDeletingAccount":
            MessageLookupByLibrary.simpleMessage("Error deleting account"),
        "errorDeletingFile":
            MessageLookupByLibrary.simpleMessage("Error deleting Object"),
        "errorDeletingFiles":
            MessageLookupByLibrary.simpleMessage("Error deleting files"),
        "errorExtractingFile":
            MessageLookupByLibrary.simpleMessage("Error extracting file"),
        "errorInputMissing": MessageLookupByLibrary.simpleMessage(
            "Please input your server address, username AND password"),
        "errorRenamingType":
            MessageLookupByLibrary.simpleMessage("Error renaming Object"),
        "errorResettingPassword":
            MessageLookupByLibrary.simpleMessage("Error resetting Password"),
        "errorSavingPermissions":
            MessageLookupByLibrary.simpleMessage("Error saving permissions"),
        "errorWhileDownloadingFile": MessageLookupByLibrary.simpleMessage(
            "Error while downloading file"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Error while generating certificate"),
        "errorWhileRemoving2fa":
            MessageLookupByLibrary.simpleMessage("Error while removing 2FA"),
        "errorWhileSavingChanges":
            MessageLookupByLibrary.simpleMessage("Error while saving changes"),
        "errorWhileSavingFile":
            MessageLookupByLibrary.simpleMessage("Error while saving file"),
        "errorWhileUploadingCertificate": MessageLookupByLibrary.simpleMessage(
            "Error while uploading certificate"),
        "errorWhileUploadingFile":
            MessageLookupByLibrary.simpleMessage("Error while uploading file"),
        "error_sending_command":
            MessageLookupByLibrary.simpleMessage("Error while sending command"),
        "extract": MessageLookupByLibrary.simpleMessage("Extract"),
        "extractFile": MessageLookupByLibrary.simpleMessage("Extract file"),
        "extractFileMessage": m10,
        "file": MessageLookupByLibrary.simpleMessage("file"),
        "fileAndName": m8,
        "fileSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("File saved successfully"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage("File too large"),
        "fileTooLargeText": MessageLookupByLibrary.simpleMessage(
            "The file you are trying to open is too large for the internal editor."),
        "files": MessageLookupByLibrary.simpleMessage("Files"),
        "filesUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "File(s) uploaded successfully."),
        "free_memory": MessageLookupByLibrary.simpleMessage("Free memory"),
        "generate": MessageLookupByLibrary.simpleMessage("Generate"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Generate certificate"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Generate new HTTPS certificate"),
        "getInTouch": MessageLookupByLibrary.simpleMessage("Get in touch"),
        "github": MessageLookupByLibrary.simpleMessage("GitHub"),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "helpMe": MessageLookupByLibrary.simpleMessage("Support me"),
        "helpMeKeepThisAppAlive":
            MessageLookupByLibrary.simpleMessage("Help me keep this app alive"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "howCanILogIn":
            MessageLookupByLibrary.simpleMessage("How can I log in?"),
        "howCanILogInText": MessageLookupByLibrary.simpleMessage(
            "After you installed the Plugin on your Bukkit / Spigot / Paper server, the Plugin will show the password for the user \"admin\" in your console. This only happens on the first startup or when no user named \"admin\" is registered.\n\nIf you forgot the password or didn\'t got the console log anymore simple delete the \"config.yml\" file inside the \"ServerCtrl\" folder or just the user \"admin\" inside this file.\n\nFor more help join my Discord server."),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "important": MessageLookupByLibrary.simpleMessage("IMPORTANT!"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Please remember, that you have to install the ServerCtrl-Plugin first"),
        "inputYourPassword":
            MessageLookupByLibrary.simpleMessage("Input your password"),
        "inputYourPasswordAndCurrent2fa": MessageLookupByLibrary.simpleMessage(
            "Input your password and current 2FA"),
        "ipOrHostname": MessageLookupByLibrary.simpleMessage("IP or Hostname"),
        "kick": MessageLookupByLibrary.simpleMessage("KICK"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "licenses": MessageLookupByLibrary.simpleMessage("Licenses"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Light Mode"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Logging in"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "longPressEntryToDeleteIt": MessageLookupByLibrary.simpleMessage(
            "Long press entry to delete it"),
        "material3": MessageLookupByLibrary.simpleMessage("Material 3"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("Memory Usage"),
        "moreInfo": MessageLookupByLibrary.simpleMessage("More info"),
        "multipleFiles": MessageLookupByLibrary.simpleMessage("Multiple files"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "newFile": MessageLookupByLibrary.simpleMessage("New File"),
        "newFolder": MessageLookupByLibrary.simpleMessage("New Folder"),
        "newPassword": MessageLookupByLibrary.simpleMessage("New password"),
        "newServer": MessageLookupByLibrary.simpleMessage("New server"),
        "newServerAdded": MessageLookupByLibrary.simpleMessage(
            "The new server got added successfully"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("No file selected"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("No players online"),
        "nothingSelected":
            MessageLookupByLibrary.simpleMessage("Nothing selected"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP"),
        "openWith": MessageLookupByLibrary.simpleMessage("Open with"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordChangedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Password changed successfully"),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "permissions": MessageLookupByLibrary.simpleMessage("Permissions"),
        "players": MessageLookupByLibrary.simpleMessage("Players"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Please allow access to the storage"),
        "pleaseInputYourCode":
            MessageLookupByLibrary.simpleMessage("Please input your Code"),
        "pleaseInputYourUsernameAndPassword":
            MessageLookupByLibrary.simpleMessage(
                "Please input your username and password"),
        "pleasePutInYourCurrentPassword": MessageLookupByLibrary.simpleMessage(
            "Please put in your current password"),
        "pleaseWait": MessageLookupByLibrary.simpleMessage("Please wait"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginAndWebserverPort":
            MessageLookupByLibrary.simpleMessage("Plugin and Webserver Port"),
        "port": MessageLookupByLibrary.simpleMessage("Port"),
        "remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "removeTwofactorAuthentication": MessageLookupByLibrary.simpleMessage(
            "Remove two-factor authentication?"),
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Repeat new password"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "restartToApplyLanguage": MessageLookupByLibrary.simpleMessage(
            "Please restart the App to fully apply the new language"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saveFile": MessageLookupByLibrary.simpleMessage("Save file"),
        "savedChanges": MessageLookupByLibrary.simpleMessage("Saved changes"),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Saved successfully"),
        "saving": MessageLookupByLibrary.simpleMessage("Saving"),
        "secretCopiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Secret copied to clipboard"),
        "selectFile": MessageLookupByLibrary.simpleMessage("Select file"),
        "selectedEntryWIllBeDeleted": MessageLookupByLibrary.simpleMessage(
            "The selected Entry will be permanently deleted from the app"),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "serverNameInput": MessageLookupByLibrary.simpleMessage(
            "Server name (freely selectable)"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Please specify the domain or IP-Address of the Minecraft server"),
        "spigotmc": MessageLookupByLibrary.simpleMessage("SpigotMC"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "successfullyAdded2faToYourAccount":
            MessageLookupByLibrary.simpleMessage(
                "Successfully added 2FA to your account"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("Successfully created file"),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("Successfully created folder"),
        "successfullyCreatedNewAccount": MessageLookupByLibrary.simpleMessage(
            "Successfully created new account"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Successfully deleted"),
        "successfullyExtracted":
            MessageLookupByLibrary.simpleMessage("Successfully extracted"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Successfully generated new certificate"),
        "successfullyLoggedIn":
            MessageLookupByLibrary.simpleMessage("Successfully logged in"),
        "successfullyRemoved2fa":
            MessageLookupByLibrary.simpleMessage("Successfully removed 2FA"),
        "successfullyRenamed":
            MessageLookupByLibrary.simpleMessage("Successfully renamed"),
        "successfullyResetPassword":
            MessageLookupByLibrary.simpleMessage("Successfully reset password"),
        "successfullySavedPermissions": MessageLookupByLibrary.simpleMessage(
            "Successfully saved permissions"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "thanks": MessageLookupByLibrary.simpleMessage(
            "Thanks to all nice people for supporting me"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "The selected files will be permanently deleted"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Theme color"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Total system memory"),
        "totpCode": MessageLookupByLibrary.simpleMessage("TOTP Code"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
        "twofactorAuthentication":
            MessageLookupByLibrary.simpleMessage("Two-factor authentication"),
        "untrustedCertificate":
            MessageLookupByLibrary.simpleMessage("Untrusted Certificate"),
        "upload": MessageLookupByLibrary.simpleMessage("Upload"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Upload certificate"),
        "uploadFiles": MessageLookupByLibrary.simpleMessage("Upload File(s)"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("Upload HTTPS certificate"),
        "usable_memory": MessageLookupByLibrary.simpleMessage("Usable memory"),
        "useSystemSettings":
            MessageLookupByLibrary.simpleMessage("Use system settings"),
        "used_memory": MessageLookupByLibrary.simpleMessage("Used memory"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "verifyPasswordForRemoving2FA": MessageLookupByLibrary.simpleMessage(
            "Please verify your password and the 2FA code for removing your two-factor authentication"),
        "verifyYourTwofactorAuthentication":
            MessageLookupByLibrary.simpleMessage(
                "Verify with two-factor authentication"),
        "version": m9,
        "wrongCode": MessageLookupByLibrary.simpleMessage("Wrong Code"),
        "wrongPassword": MessageLookupByLibrary.simpleMessage("Wrong password"),
        "wrongUsernameOrPassword":
            MessageLookupByLibrary.simpleMessage("Wrong username or password"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "youAlreadyAddedThisServer": MessageLookupByLibrary.simpleMessage(
            "You already added this server"),
        "youAlreadyConfigured2FA": MessageLookupByLibrary.simpleMessage(
            "You already configured two-factor authentication, do you want to remove it?")
      };
}
