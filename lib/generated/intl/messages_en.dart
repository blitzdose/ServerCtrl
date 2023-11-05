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

  static String m1(accountName) =>
      "The account \"${accountName}\" will be permanently removed.";

  static String m2(type) => "Delete ${type}?";

  static String m3(type, name) =>
      "The ${type} \"${name}\" will be permanently removed.";

  static String m4(filename) => "Downloaded \"${filename}\" successfully.";

  static String m5(type) => "Error deleting ${type}";

  static String m6(type) => "Error renaming ${type}";

  static String m7(name) => "File \"${name}\"";

  static String m8(type) => "Rename ${type}";

  static String m9(version) => "Version: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "addMinecraftServer":
            MessageLookupByLibrary.simpleMessage("Add Minecraft server"),
        "add_server": MessageLookupByLibrary.simpleMessage("Add Server"),
        "allYourChangesWillBeLost": MessageLookupByLibrary.simpleMessage(
            "All your changes will be lost"),
        "allocated_memory":
            MessageLookupByLibrary.simpleMessage("Allocated memory"),
        "ban": MessageLookupByLibrary.simpleMessage("BAN"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "certificateFile":
            MessageLookupByLibrary.simpleMessage("Certificate file"),
        "certificateKeyFile":
            MessageLookupByLibrary.simpleMessage("Certificate key file"),
        "certificateUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Certificate uploaded successfully"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "command": MessageLookupByLibrary.simpleMessage("Command"),
        "console": MessageLookupByLibrary.simpleMessage("Console"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("CPU cores"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU load"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("CPU Usage"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
        "createFile": MessageLookupByLibrary.simpleMessage("Create File"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Create Folder"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Delete account?"),
        "deleteAccountMessage": m1,
        "deleteFile": m2,
        "deleteFileMessage": m3,
        "deleteFiles": MessageLookupByLibrary.simpleMessage("Delete files?"),
        "deop": MessageLookupByLibrary.simpleMessage("DE-OP"),
        "directory": MessageLookupByLibrary.simpleMessage("directory"),
        "discard": MessageLookupByLibrary.simpleMessage("Discard"),
        "discardChanges":
            MessageLookupByLibrary.simpleMessage("Discard changes?"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloaded": MessageLookupByLibrary.simpleMessage("Downloaded"),
        "downloadedFilenameSuccessfully": m4,
        "downloading": MessageLookupByLibrary.simpleMessage("Downloading"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "errorCreatingAccount":
            MessageLookupByLibrary.simpleMessage("Error creating account"),
        "errorCreatingFile":
            MessageLookupByLibrary.simpleMessage("Error creating file"),
        "errorCreatingFolder":
            MessageLookupByLibrary.simpleMessage("Error creating folder"),
        "errorDeletingAccount":
            MessageLookupByLibrary.simpleMessage("Error deleting account"),
        "errorDeletingFile": m5,
        "errorDeletingFiles":
            MessageLookupByLibrary.simpleMessage("Error deleting files"),
        "errorRenamingType": m6,
        "errorResettingPassword":
            MessageLookupByLibrary.simpleMessage("Error resetting Password"),
        "errorSavingPermissions":
            MessageLookupByLibrary.simpleMessage("Error saving permissions"),
        "errorWhileDownloadingFile": MessageLookupByLibrary.simpleMessage(
            "Error while downloading file"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Error while generating certificate"),
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
        "file": MessageLookupByLibrary.simpleMessage("file"),
        "fileAndName": m7,
        "fileSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("File saved successfully"),
        "files": MessageLookupByLibrary.simpleMessage("Files"),
        "filesUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "File(s) uploaded successfully."),
        "free_memory": MessageLookupByLibrary.simpleMessage("Free memory"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Generate certificate"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Generate new HTTPS certificate"),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "infoInstallPlugin": MessageLookupByLibrary.simpleMessage(
            "Please remember, that you have to install the ServerCtrl-Plugin first"),
        "ipOrHostname": MessageLookupByLibrary.simpleMessage("IP or Hostname"),
        "kick": MessageLookupByLibrary.simpleMessage("KICK"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "loggingIn": MessageLookupByLibrary.simpleMessage("Logging in"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("Memory Usage"),
        "multipleFiles": MessageLookupByLibrary.simpleMessage("Multiple files"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "newFile": MessageLookupByLibrary.simpleMessage("New File"),
        "newFolder": MessageLookupByLibrary.simpleMessage("New Folder"),
        "newPassword": MessageLookupByLibrary.simpleMessage("New password"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("No file selected"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("No players online"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP"),
        "openWith": MessageLookupByLibrary.simpleMessage("Open with"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "permissions": MessageLookupByLibrary.simpleMessage("Permissions"),
        "players": MessageLookupByLibrary.simpleMessage("Players"),
        "pleaseAllowAccessToTheStorage": MessageLookupByLibrary.simpleMessage(
            "Please allow access to the storage"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginAndWebserverPort":
            MessageLookupByLibrary.simpleMessage("Plugin and Webserver Port"),
        "port": MessageLookupByLibrary.simpleMessage("Port"),
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "renameType": m8,
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Repeat new password"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saveFile": MessageLookupByLibrary.simpleMessage("Save file"),
        "savedChanges": MessageLookupByLibrary.simpleMessage("Saved changes"),
        "savedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Saved successfully"),
        "saving": MessageLookupByLibrary.simpleMessage("Saving"),
        "selectFile": MessageLookupByLibrary.simpleMessage("Select file"),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Please specify the domain or IP-Address of the Minecraft server"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "successfullyCreatedFile":
            MessageLookupByLibrary.simpleMessage("Successfully created file"),
        "successfullyCreatedFolder":
            MessageLookupByLibrary.simpleMessage("Successfully created folder"),
        "successfullyCreatedNewAccount": MessageLookupByLibrary.simpleMessage(
            "Successfully created new account"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Successfully deleted"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Successfully generated new certificate"),
        "successfullyRenamed":
            MessageLookupByLibrary.simpleMessage("Successfully renamed"),
        "successfullyResetPassword":
            MessageLookupByLibrary.simpleMessage("Successfully reset password"),
        "successfullySavedPermissions": MessageLookupByLibrary.simpleMessage(
            "Successfully saved permissions"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "theSelectedFilesWillBePermanentlyDeleted":
            MessageLookupByLibrary.simpleMessage(
                "The selected files will be permanently deleted"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Total system memory"),
        "upload": MessageLookupByLibrary.simpleMessage("Upload"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Upload certificate"),
        "uploadFiles": MessageLookupByLibrary.simpleMessage("Upload File(s)"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("Upload HTTPS certificate"),
        "usable_memory": MessageLookupByLibrary.simpleMessage("Usable memory"),
        "used_memory": MessageLookupByLibrary.simpleMessage("Used memory"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "version": m9
      };
}
