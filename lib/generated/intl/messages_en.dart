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

  static String m2(version) => "Version: ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountAndName": m0,
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "add_server": MessageLookupByLibrary.simpleMessage("Add Server"),
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
        "command": MessageLookupByLibrary.simpleMessage("Command"),
        "console": MessageLookupByLibrary.simpleMessage("Console"),
        "cpu_cores": MessageLookupByLibrary.simpleMessage("CPU cores"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU load"),
        "cpu_usage": MessageLookupByLibrary.simpleMessage("CPU Usage"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Delete account?"),
        "deleteAccountMessage": m1,
        "deop": MessageLookupByLibrary.simpleMessage("DE-OP"),
        "errorCreatingAccount":
            MessageLookupByLibrary.simpleMessage("Error creating account"),
        "errorDeletingAccount":
            MessageLookupByLibrary.simpleMessage("Error deleting account"),
        "errorResettingPassword":
            MessageLookupByLibrary.simpleMessage("Error resetting Password"),
        "errorSavingPermissions":
            MessageLookupByLibrary.simpleMessage("Error saving permissions"),
        "errorWhileGeneratingCertificate": MessageLookupByLibrary.simpleMessage(
            "Error while generating certificate"),
        "errorWhileSavingChanges":
            MessageLookupByLibrary.simpleMessage("Error while saving changes"),
        "errorWhileUploadingCertificate": MessageLookupByLibrary.simpleMessage(
            "Error while uploading certificate"),
        "error_sending_command":
            MessageLookupByLibrary.simpleMessage("Error while sending command"),
        "files": MessageLookupByLibrary.simpleMessage("Files"),
        "free_memory": MessageLookupByLibrary.simpleMessage("Free memory"),
        "generateCertificate":
            MessageLookupByLibrary.simpleMessage("Generate certificate"),
        "generateNewHttpsCertificate": MessageLookupByLibrary.simpleMessage(
            "Generate new HTTPS certificate"),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "https": MessageLookupByLibrary.simpleMessage("HTTPS"),
        "kick": MessageLookupByLibrary.simpleMessage("KICK"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "memory_usage": MessageLookupByLibrary.simpleMessage("Memory Usage"),
        "newPassword": MessageLookupByLibrary.simpleMessage("New password"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noFileSelected":
            MessageLookupByLibrary.simpleMessage("No file selected"),
        "noPlayersOnline":
            MessageLookupByLibrary.simpleMessage("No players online"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "op": MessageLookupByLibrary.simpleMessage("OP"),
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
        "repeatNewPassword":
            MessageLookupByLibrary.simpleMessage("Repeat new password"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "savedChanges": MessageLookupByLibrary.simpleMessage("Saved changes"),
        "selectFile": MessageLookupByLibrary.simpleMessage("Select file"),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "server_ctrl": MessageLookupByLibrary.simpleMessage("ServerCtrl"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "specifyIpOrAddr": MessageLookupByLibrary.simpleMessage(
            "Please specify the domain or IP-Address of the Minecraft server"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "successfullyCreatedNewAccount": MessageLookupByLibrary.simpleMessage(
            "Successfully created new account"),
        "successfullyDeleted":
            MessageLookupByLibrary.simpleMessage("Successfully deleted"),
        "successfullyGeneratedNewCertificate":
            MessageLookupByLibrary.simpleMessage(
                "Successfully generated new certificate"),
        "successfullyResetPassword":
            MessageLookupByLibrary.simpleMessage("Successfully reset password"),
        "successfullySavedPermissions": MessageLookupByLibrary.simpleMessage(
            "Successfully saved permissions"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "total_system_memory":
            MessageLookupByLibrary.simpleMessage("Total system memory"),
        "upload": MessageLookupByLibrary.simpleMessage("Upload"),
        "uploadCertificate":
            MessageLookupByLibrary.simpleMessage("Upload certificate"),
        "uploadHttpsCertificate":
            MessageLookupByLibrary.simpleMessage("Upload HTTPS certificate"),
        "usable_memory": MessageLookupByLibrary.simpleMessage("Usable memory"),
        "used_memory": MessageLookupByLibrary.simpleMessage("Used memory"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "version": m2
      };
}
