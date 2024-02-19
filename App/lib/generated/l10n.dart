// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ServerCtrl`
  String get server_ctrl {
    return Intl.message(
      'ServerCtrl',
      name: 'server_ctrl',
      desc: '',
      args: [],
    );
  }

  /// `Version: {version}`
  String version(Object version) {
    return Intl.message(
      'Version: $version',
      name: 'version',
      desc: 'Example: Version: 1.0.0',
      args: [version],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Add Server`
  String get add_server {
    return Intl.message(
      'Add Server',
      name: 'add_server',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Console`
  String get console {
    return Intl.message(
      'Console',
      name: 'console',
      desc: '',
      args: [],
    );
  }

  /// `Players`
  String get players {
    return Intl.message(
      'Players',
      name: 'players',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Log`
  String get log {
    return Intl.message(
      'Log',
      name: 'log',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `CPU cores`
  String get cpu_cores {
    return Intl.message(
      'CPU cores',
      name: 'cpu_cores',
      desc: '',
      args: [],
    );
  }

  /// `CPU load`
  String get cpu_load {
    return Intl.message(
      'CPU load',
      name: 'cpu_load',
      desc: '',
      args: [],
    );
  }

  /// `Usable memory`
  String get usable_memory {
    return Intl.message(
      'Usable memory',
      name: 'usable_memory',
      desc: '',
      args: [],
    );
  }

  /// `Allocated memory`
  String get allocated_memory {
    return Intl.message(
      'Allocated memory',
      name: 'allocated_memory',
      desc: '',
      args: [],
    );
  }

  /// `Used memory`
  String get used_memory {
    return Intl.message(
      'Used memory',
      name: 'used_memory',
      desc: '',
      args: [],
    );
  }

  /// `Total system memory`
  String get total_system_memory {
    return Intl.message(
      'Total system memory',
      name: 'total_system_memory',
      desc: '',
      args: [],
    );
  }

  /// `Free memory`
  String get free_memory {
    return Intl.message(
      'Free memory',
      name: 'free_memory',
      desc: '',
      args: [],
    );
  }

  /// `CPU Usage`
  String get cpu_usage {
    return Intl.message(
      'CPU Usage',
      name: 'cpu_usage',
      desc: '',
      args: [],
    );
  }

  /// `Memory Usage`
  String get memory_usage {
    return Intl.message(
      'Memory Usage',
      name: 'memory_usage',
      desc: '',
      args: [],
    );
  }

  /// `test`
  String get test {
    return Intl.message(
      'test',
      name: 'test',
      desc: '',
      args: [],
    );
  }

  /// `Command`
  String get command {
    return Intl.message(
      'Command',
      name: 'command',
      desc: '',
      args: [],
    );
  }

  /// `Error while sending command`
  String get error_sending_command {
    return Intl.message(
      'Error while sending command',
      name: 'error_sending_command',
      desc: '',
      args: [],
    );
  }

  /// `KICK`
  String get kick {
    return Intl.message(
      'KICK',
      name: 'kick',
      desc: '',
      args: [],
    );
  }

  /// `BAN`
  String get ban {
    return Intl.message(
      'BAN',
      name: 'ban',
      desc: '',
      args: [],
    );
  }

  /// `DE-OP`
  String get deop {
    return Intl.message(
      'DE-OP',
      name: 'deop',
      desc: '',
      args: [],
    );
  }

  /// `OP`
  String get op {
    return Intl.message(
      'OP',
      name: 'op',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Permissions`
  String get permissions {
    return Intl.message(
      'Permissions',
      name: 'permissions',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete account?`
  String get deleteAccount {
    return Intl.message(
      'Delete account?',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `The account "{accountName}" will be permanently removed.`
  String deleteAccountMessage(Object accountName) {
    return Intl.message(
      'The account "$accountName" will be permanently removed.',
      name: 'deleteAccountMessage',
      desc: 'Example: The account "Admin" will be permanently removed.',
      args: [accountName],
    );
  }

  /// `Successfully deleted`
  String get successfullyDeleted {
    return Intl.message(
      'Successfully deleted',
      name: 'successfullyDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting account`
  String get errorDeletingAccount {
    return Intl.message(
      'Error deleting account',
      name: 'errorDeletingAccount',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Repeat new password`
  String get repeatNewPassword {
    return Intl.message(
      'Repeat new password',
      name: 'repeatNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Successfully reset password`
  String get successfullyResetPassword {
    return Intl.message(
      'Successfully reset password',
      name: 'successfullyResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Error resetting Password`
  String get errorResettingPassword {
    return Intl.message(
      'Error resetting Password',
      name: 'errorResettingPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Successfully saved permissions`
  String get successfullySavedPermissions {
    return Intl.message(
      'Successfully saved permissions',
      name: 'successfullySavedPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Error saving permissions`
  String get errorSavingPermissions {
    return Intl.message(
      'Error saving permissions',
      name: 'errorSavingPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Successfully created new account`
  String get successfullyCreatedNewAccount {
    return Intl.message(
      'Successfully created new account',
      name: 'successfullyCreatedNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Error creating account`
  String get errorCreatingAccount {
    return Intl.message(
      'Error creating account',
      name: 'errorCreatingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Port`
  String get port {
    return Intl.message(
      'Port',
      name: 'port',
      desc: '',
      args: [],
    );
  }

  /// `Generate certificate`
  String get generateCertificate {
    return Intl.message(
      'Generate certificate',
      name: 'generateCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Please specify the domain or IP-Address of the Minecraft server`
  String get specifyIpOrAddr {
    return Intl.message(
      'Please specify the domain or IP-Address of the Minecraft server',
      name: 'specifyIpOrAddr',
      desc: '',
      args: [],
    );
  }

  /// `No file selected`
  String get noFileSelected {
    return Intl.message(
      'No file selected',
      name: 'noFileSelected',
      desc: '',
      args: [],
    );
  }

  /// `Upload certificate`
  String get uploadCertificate {
    return Intl.message(
      'Upload certificate',
      name: 'uploadCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Certificate file`
  String get certificateFile {
    return Intl.message(
      'Certificate file',
      name: 'certificateFile',
      desc: '',
      args: [],
    );
  }

  /// `Please allow access to the storage`
  String get pleaseAllowAccessToTheStorage {
    return Intl.message(
      'Please allow access to the storage',
      name: 'pleaseAllowAccessToTheStorage',
      desc: '',
      args: [],
    );
  }

  /// `Select file`
  String get selectFile {
    return Intl.message(
      'Select file',
      name: 'selectFile',
      desc: '',
      args: [],
    );
  }

  /// `Certificate key file`
  String get certificateKeyFile {
    return Intl.message(
      'Certificate key file',
      name: 'certificateKeyFile',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Plugin`
  String get plugin {
    return Intl.message(
      'Plugin',
      name: 'plugin',
      desc: '',
      args: [],
    );
  }

  /// `HTTPS`
  String get https {
    return Intl.message(
      'HTTPS',
      name: 'https',
      desc: '',
      args: [],
    );
  }

  /// `Upload HTTPS certificate`
  String get uploadHttpsCertificate {
    return Intl.message(
      'Upload HTTPS certificate',
      name: 'uploadHttpsCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Generate new HTTPS certificate`
  String get generateNewHttpsCertificate {
    return Intl.message(
      'Generate new HTTPS certificate',
      name: 'generateNewHttpsCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Plugin and Webserver Port`
  String get pluginAndWebserverPort {
    return Intl.message(
      'Plugin and Webserver Port',
      name: 'pluginAndWebserverPort',
      desc: '',
      args: [],
    );
  }

  /// `Server`
  String get server {
    return Intl.message(
      'Server',
      name: 'server',
      desc: '',
      args: [],
    );
  }

  /// `Error while saving changes`
  String get errorWhileSavingChanges {
    return Intl.message(
      'Error while saving changes',
      name: 'errorWhileSavingChanges',
      desc: '',
      args: [],
    );
  }

  /// `Saved changes`
  String get savedChanges {
    return Intl.message(
      'Saved changes',
      name: 'savedChanges',
      desc: '',
      args: [],
    );
  }

  /// `Successfully generated new certificate`
  String get successfullyGeneratedNewCertificate {
    return Intl.message(
      'Successfully generated new certificate',
      name: 'successfullyGeneratedNewCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Error while generating certificate`
  String get errorWhileGeneratingCertificate {
    return Intl.message(
      'Error while generating certificate',
      name: 'errorWhileGeneratingCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Certificate uploaded successfully`
  String get certificateUploadedSuccessfully {
    return Intl.message(
      'Certificate uploaded successfully',
      name: 'certificateUploadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error while uploading certificate`
  String get errorWhileUploadingCertificate {
    return Intl.message(
      'Error while uploading certificate',
      name: 'errorWhileUploadingCertificate',
      desc: '',
      args: [],
    );
  }

  /// `No players online`
  String get noPlayersOnline {
    return Intl.message(
      'No players online',
      name: 'noPlayersOnline',
      desc: '',
      args: [],
    );
  }

  /// `Open with`
  String get openWith {
    return Intl.message(
      'Open with',
      name: 'openWith',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `Delete?`
  String get deleteFile {
    return Intl.message(
      'Delete?',
      name: 'deleteFile',
      desc: '',
      args: [],
    );
  }

  /// `"{name}" will be permanently removed.`
  String deleteFileMessage(Object name) {
    return Intl.message(
      '"$name" will be permanently removed.',
      name: 'deleteFileMessage',
      desc: 'Example: "config.yml" will be permanently removed.',
      args: [name],
    );
  }

  /// `File "{name}"`
  String fileAndName(Object name) {
    return Intl.message(
      'File "$name"',
      name: 'fileAndName',
      desc: 'Example: File "config.yml"',
      args: [name],
    );
  }

  /// `Error deleting Object`
  String get errorDeletingFile {
    return Intl.message(
      'Error deleting Object',
      name: 'errorDeletingFile',
      desc: '',
      args: [],
    );
  }

  /// `Create File`
  String get createFile {
    return Intl.message(
      'Create File',
      name: 'createFile',
      desc: '',
      args: [],
    );
  }

  /// `New File`
  String get newFile {
    return Intl.message(
      'New File',
      name: 'newFile',
      desc: '',
      args: [],
    );
  }

  /// `Create Folder`
  String get createFolder {
    return Intl.message(
      'Create Folder',
      name: 'createFolder',
      desc: '',
      args: [],
    );
  }

  /// `New Folder`
  String get newFolder {
    return Intl.message(
      'New Folder',
      name: 'newFolder',
      desc: '',
      args: [],
    );
  }

  /// `Successfully created file`
  String get successfullyCreatedFile {
    return Intl.message(
      'Successfully created file',
      name: 'successfullyCreatedFile',
      desc: '',
      args: [],
    );
  }

  /// `Error creating file`
  String get errorCreatingFile {
    return Intl.message(
      'Error creating file',
      name: 'errorCreatingFile',
      desc: '',
      args: [],
    );
  }

  /// `Successfully created folder`
  String get successfullyCreatedFolder {
    return Intl.message(
      'Successfully created folder',
      name: 'successfullyCreatedFolder',
      desc: '',
      args: [],
    );
  }

  /// `Error creating folder`
  String get errorCreatingFolder {
    return Intl.message(
      'Error creating folder',
      name: 'errorCreatingFolder',
      desc: '',
      args: [],
    );
  }

  /// `File(s) uploaded successfully.`
  String get filesUploadedSuccessfully {
    return Intl.message(
      'File(s) uploaded successfully.',
      name: 'filesUploadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Multiple files`
  String get multipleFiles {
    return Intl.message(
      'Multiple files',
      name: 'multipleFiles',
      desc: '',
      args: [],
    );
  }

  /// `Error while uploading file`
  String get errorWhileUploadingFile {
    return Intl.message(
      'Error while uploading file',
      name: 'errorWhileUploadingFile',
      desc: '',
      args: [],
    );
  }

  /// `Downloading`
  String get downloading {
    return Intl.message(
      'Downloading',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `Saving`
  String get saving {
    return Intl.message(
      'Saving',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `Saved successfully`
  String get savedSuccessfully {
    return Intl.message(
      'Saved successfully',
      name: 'savedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error while saving file`
  String get errorWhileSavingFile {
    return Intl.message(
      'Error while saving file',
      name: 'errorWhileSavingFile',
      desc: '',
      args: [],
    );
  }

  /// `Save file`
  String get saveFile {
    return Intl.message(
      'Save file',
      name: 'saveFile',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded`
  String get downloaded {
    return Intl.message(
      'Downloaded',
      name: 'downloaded',
      desc: '',
      args: [],
    );
  }

  /// `Error while downloading file`
  String get errorWhileDownloadingFile {
    return Intl.message(
      'Error while downloading file',
      name: 'errorWhileDownloadingFile',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Successfully renamed`
  String get successfullyRenamed {
    return Intl.message(
      'Successfully renamed',
      name: 'successfullyRenamed',
      desc: '',
      args: [],
    );
  }

  /// `file`
  String get file {
    return Intl.message(
      'file',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `directory`
  String get directory {
    return Intl.message(
      'directory',
      name: 'directory',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded "{filename}" successfully.`
  String downloadedFilenameSuccessfully(Object filename) {
    return Intl.message(
      'Downloaded "$filename" successfully.',
      name: 'downloadedFilenameSuccessfully',
      desc: 'Example: Downloaded "config.yml" successfully.',
      args: [filename],
    );
  }

  /// `Error renaming Object`
  String get errorRenamingType {
    return Intl.message(
      'Error renaming Object',
      name: 'errorRenamingType',
      desc: '',
      args: [],
    );
  }

  /// `Delete files?`
  String get deleteFiles {
    return Intl.message(
      'Delete files?',
      name: 'deleteFiles',
      desc: '',
      args: [],
    );
  }

  /// `The selected files will be permanently deleted`
  String get theSelectedFilesWillBePermanentlyDeleted {
    return Intl.message(
      'The selected files will be permanently deleted',
      name: 'theSelectedFilesWillBePermanentlyDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting files`
  String get errorDeletingFiles {
    return Intl.message(
      'Error deleting files',
      name: 'errorDeletingFiles',
      desc: '',
      args: [],
    );
  }

  /// `Upload File(s)`
  String get uploadFiles {
    return Intl.message(
      'Upload File(s)',
      name: 'uploadFiles',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Discard changes?`
  String get discardChanges {
    return Intl.message(
      'Discard changes?',
      name: 'discardChanges',
      desc: '',
      args: [],
    );
  }

  /// `All your changes will be lost`
  String get allYourChangesWillBeLost {
    return Intl.message(
      'All your changes will be lost',
      name: 'allYourChangesWillBeLost',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message(
      'Discard',
      name: 'discard',
      desc: '',
      args: [],
    );
  }

  /// `File saved successfully`
  String get fileSavedSuccessfully {
    return Intl.message(
      'File saved successfully',
      name: 'fileSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Add Minecraft server`
  String get addMinecraftServer {
    return Intl.message(
      'Add Minecraft server',
      name: 'addMinecraftServer',
      desc: '',
      args: [],
    );
  }

  /// `Please remember, that you have to install the ServerCtrl-Plugin first`
  String get infoInstallPlugin {
    return Intl.message(
      'Please remember, that you have to install the ServerCtrl-Plugin first',
      name: 'infoInstallPlugin',
      desc: '',
      args: [],
    );
  }

  /// `IP or Hostname`
  String get ipOrHostname {
    return Intl.message(
      'IP or Hostname',
      name: 'ipOrHostname',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Logging in`
  String get loggingIn {
    return Intl.message(
      'Logging in',
      name: 'loggingIn',
      desc: '',
      args: [],
    );
  }

  /// `Coded by {name}`
  String codedBy(Object name) {
    return Intl.message(
      'Coded by $name',
      name: 'codedBy',
      desc: 'Example: Coded by Max Mustermann',
      args: [name],
    );
  }

  /// `Thanks to all nice people for supporting me`
  String get thanks {
    return Intl.message(
      'Thanks to all nice people for supporting me',
      name: 'thanks',
      desc: '',
      args: [],
    );
  }

  /// `Untrusted Certificate`
  String get untrustedCertificate {
    return Intl.message(
      'Untrusted Certificate',
      name: 'untrustedCertificate',
      desc: '',
      args: [],
    );
  }

  /// `The certificate of the server cannot be verified. Do you want to trust it? SHA1 fingerprint of the certificate:`
  String get certCannotBeVerified {
    return Intl.message(
      'The certificate of the server cannot be verified. Do you want to trust it? SHA1 fingerprint of the certificate:',
      name: 'certCannotBeVerified',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Delete "{routeTitle}"`
  String deleteRoutetitle(Object routeTitle) {
    return Intl.message(
      'Delete "$routeTitle"',
      name: 'deleteRoutetitle',
      desc: 'Example: Delete "Server-1"',
      args: [routeTitle],
    );
  }

  /// `The selected Entry will be permanently deleted from the app`
  String get selectedEntryWIllBeDeleted {
    return Intl.message(
      'The selected Entry will be permanently deleted from the app',
      name: 'selectedEntryWIllBeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Long press entry to delete it`
  String get longPressEntryToDeleteIt {
    return Intl.message(
      'Long press entry to delete it',
      name: 'longPressEntryToDeleteIt',
      desc: '',
      args: [],
    );
  }

  /// `Server name (freely selectable)`
  String get serverNameInput {
    return Intl.message(
      'Server name (freely selectable)',
      name: 'serverNameInput',
      desc: '',
      args: [],
    );
  }

  /// `Connection failed`
  String get connectionFailed {
    return Intl.message(
      'Connection failed',
      name: 'connectionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Cannot reach the server`
  String get cannotReachTheServer {
    return Intl.message(
      'Cannot reach the server',
      name: 'cannotReachTheServer',
      desc: '',
      args: [],
    );
  }

  /// `Cannot connect to the server, maybe the credentials changed?`
  String get cannotConnectMaybeCredentials {
    return Intl.message(
      'Cannot connect to the server, maybe the credentials changed?',
      name: 'cannotConnectMaybeCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Cannot find credentials to this server, please add it again`
  String get cannotFindCredentials {
    return Intl.message(
      'Cannot find credentials to this server, please add it again',
      name: 'cannotFindCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Please restart the App to fully apply the new language`
  String get restartToApplyLanguage {
    return Intl.message(
      'Please restart the App to fully apply the new language',
      name: 'restartToApplyLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Design`
  String get design {
    return Intl.message(
      'Design',
      name: 'design',
      desc: '',
      args: [],
    );
  }

  /// `Use system settings`
  String get useSystemSettings {
    return Intl.message(
      'Use system settings',
      name: 'useSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message(
      'Light Mode',
      name: 'lightMode',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Theme color`
  String get themeColor {
    return Intl.message(
      'Theme color',
      name: 'themeColor',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get defaultStr {
    return Intl.message(
      'Default',
      name: 'defaultStr',
      desc: '',
      args: [],
    );
  }

  /// `Please input your server address, username AND password`
  String get errorInputMissing {
    return Intl.message(
      'Please input your server address, username AND password',
      name: 'errorInputMissing',
      desc: '',
      args: [],
    );
  }

  /// `You already added this server`
  String get youAlreadyAddedThisServer {
    return Intl.message(
      'You already added this server',
      name: 'youAlreadyAddedThisServer',
      desc: '',
      args: [],
    );
  }

  /// `Wrong username or password`
  String get wrongUsernameOrPassword {
    return Intl.message(
      'Wrong username or password',
      name: 'wrongUsernameOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `New server`
  String get newServer {
    return Intl.message(
      'New server',
      name: 'newServer',
      desc: '',
      args: [],
    );
  }

  /// `The new server got added successfully`
  String get newServerAdded {
    return Intl.message(
      'The new server got added successfully',
      name: 'newServerAdded',
      desc: '',
      args: [],
    );
  }

  /// `Please accept the warning and login again`
  String get acceptWarningTryAgain {
    return Intl.message(
      'Please accept the warning and login again',
      name: 'acceptWarningTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Cannot reach "{ip}"`
  String cannotReachIp(Object ip) {
    return Intl.message(
      'Cannot reach "$ip"',
      name: 'cannotReachIp',
      desc: 'Example: Cannot reach "192.168.2.100"',
      args: [ip],
    );
  }

  /// `Cannot reach "{ip}" over HTTPS`
  String cannotReachIpOverHttps(Object ip) {
    return Intl.message(
      'Cannot reach "$ip" over HTTPS',
      name: 'cannotReachIpOverHttps',
      desc: 'Example: Cannot reach "192.168.2.100" over HTTPS',
      args: [ip],
    );
  }

  /// `Support me`
  String get helpMe {
    return Intl.message(
      'Support me',
      name: 'helpMe',
      desc: '',
      args: [],
    );
  }

  /// `Donate`
  String get donate {
    return Intl.message(
      'Donate',
      name: 'donate',
      desc: '',
      args: [],
    );
  }

  /// `Help me keep this app alive`
  String get helpMeKeepThisAppAlive {
    return Intl.message(
      'Help me keep this app alive',
      name: 'helpMeKeepThisAppAlive',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Material 3`
  String get material3 {
    return Intl.message(
      'Material 3',
      name: 'material3',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic color`
  String get dynamicColor {
    return Intl.message(
      'Dynamic color',
      name: 'dynamicColor',
      desc: '',
      args: [],
    );
  }

  /// `Get in touch`
  String get getInTouch {
    return Intl.message(
      'Get in touch',
      name: 'getInTouch',
      desc: '',
      args: [],
    );
  }

  /// `Discord`
  String get discord {
    return Intl.message(
      'Discord',
      name: 'discord',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail`
  String get email {
    return Intl.message(
      'E-Mail',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `SpigotMC`
  String get spigotmc {
    return Intl.message(
      'SpigotMC',
      name: 'spigotmc',
      desc: '',
      args: [],
    );
  }

  /// `GitHub`
  String get github {
    return Intl.message(
      'GitHub',
      name: 'github',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Licenses`
  String get licenses {
    return Intl.message(
      'Licenses',
      name: 'licenses',
      desc: '',
      args: [],
    );
  }

  /// `Data privacy`
  String get dataPrivacy {
    return Intl.message(
      'Data privacy',
      name: 'dataPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `About ServerCtrl`
  String get aboutServerctrl {
    return Intl.message(
      'About ServerCtrl',
      name: 'aboutServerctrl',
      desc: '',
      args: [],
    );
  }

  /// `Account {name}`
  String accountAndName(Object name) {
    return Intl.message(
      'Account $name',
      name: 'accountAndName',
      desc: 'Example: Account Admin',
      args: [name],
    );
  }

  /// `Generate`
  String get generate {
    return Intl.message(
      'Generate',
      name: 'generate',
      desc: '',
      args: [],
    );
  }

  /// `Nothing selected`
  String get nothingSelected {
    return Intl.message(
      'Nothing selected',
      name: 'nothingSelected',
      desc: '',
      args: [],
    );
  }

  /// `IMPORTANT!`
  String get important {
    return Intl.message(
      'IMPORTANT!',
      name: 'important',
      desc: '',
      args: [],
    );
  }

  /// `This app requires a plugin to be installed on your existing Minecraft server. Please click "More info" for ... well ... more info :)`
  String get InstallPlugin {
    return Intl.message(
      'This app requires a plugin to be installed on your existing Minecraft server. Please click "More info" for ... well ... more info :)',
      name: 'InstallPlugin',
      desc: '',
      args: [],
    );
  }

  /// `More info`
  String get moreInfo {
    return Intl.message(
      'More info',
      name: 'moreInfo',
      desc: '',
      args: [],
    );
  }

  /// `Please input your username and password`
  String get pleaseInputYourUsernameAndPassword {
    return Intl.message(
      'Please input your username and password',
      name: 'pleaseInputYourUsernameAndPassword',
      desc: '',
      args: [],
    );
  }

  /// `Successfully logged in`
  String get successfullyLoggedIn {
    return Intl.message(
      'Successfully logged in',
      name: 'successfullyLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Certificate changed. Please verify and accept the new certificate.`
  String get acceptNewCert {
    return Intl.message(
      'Certificate changed. Please verify and accept the new certificate.',
      name: 'acceptNewCert',
      desc: '',
      args: [],
    );
  }

  /// `File too large`
  String get fileTooLarge {
    return Intl.message(
      'File too large',
      name: 'fileTooLarge',
      desc: '',
      args: [],
    );
  }

  /// `The file you are trying to open is too large for the internal editor.`
  String get fileTooLargeText {
    return Intl.message(
      'The file you are trying to open is too large for the internal editor.',
      name: 'fileTooLargeText',
      desc: '',
      args: [],
    );
  }

  /// `How can I log in?`
  String get howCanILogIn {
    return Intl.message(
      'How can I log in?',
      name: 'howCanILogIn',
      desc: '',
      args: [],
    );
  }

  /// `After you installed the Plugin on your Bukkit / Spigot / Paper server, the Plugin will show the password for the user "admin" in your console. This only happens on the first startup or when no user named "admin" is registered.\n\nIf you forgot the password or didn't got the console log anymore simple delete the "config.yml" file inside the "ServerCtrl" folder or just the user "admin" inside this file.\n\nFor more help join my Discord server.`
  String get howCanILogInText {
    return Intl.message(
      'After you installed the Plugin on your Bukkit / Spigot / Paper server, the Plugin will show the password for the user "admin" in your console. This only happens on the first startup or when no user named "admin" is registered.\n\nIf you forgot the password or didn\'t got the console log anymore simple delete the "config.yml" file inside the "ServerCtrl" folder or just the user "admin" inside this file.\n\nFor more help join my Discord server.',
      name: 'howCanILogInText',
      desc: '',
      args: [],
    );
  }

  /// `Two-factor authentication`
  String get twofactorAuthentication {
    return Intl.message(
      'Two-factor authentication',
      name: 'twofactorAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Please input your Code`
  String get pleaseInputYourCode {
    return Intl.message(
      'Please input your Code',
      name: 'pleaseInputYourCode',
      desc: '',
      args: [],
    );
  }

  /// `TOTP Code`
  String get totpCode {
    return Intl.message(
      'TOTP Code',
      name: 'totpCode',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Code`
  String get wrongCode {
    return Intl.message(
      'Wrong Code',
      name: 'wrongCode',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get currentPassword {
    return Intl.message(
      'Current password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Configure Two-factor authentication`
  String get configureTwofactorAuthentication {
    return Intl.message(
      'Configure Two-factor authentication',
      name: 'configureTwofactorAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `e.g. with Google Authenticator`
  String get egWithGoogleAuthenticator {
    return Intl.message(
      'e.g. with Google Authenticator',
      name: 'egWithGoogleAuthenticator',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get wrongPassword {
    return Intl.message(
      'Wrong password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please wait`
  String get pleaseWait {
    return Intl.message(
      'Please wait',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Remove two-factor authentication?`
  String get removeTwofactorAuthentication {
    return Intl.message(
      'Remove two-factor authentication?',
      name: 'removeTwofactorAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `You already configured two-factor authentication, do you want to remove it?`
  String get youAlreadyConfigured2FA {
    return Intl.message(
      'You already configured two-factor authentication, do you want to remove it?',
      name: 'youAlreadyConfigured2FA',
      desc: '',
      args: [],
    );
  }

  /// `Input your password and current 2FA`
  String get inputYourPasswordAndCurrent2fa {
    return Intl.message(
      'Input your password and current 2FA',
      name: 'inputYourPasswordAndCurrent2fa',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your password and the 2FA code for removing your two-factor authentication`
  String get verifyPasswordForRemoving2FA {
    return Intl.message(
      'Please verify your password and the 2FA code for removing your two-factor authentication',
      name: 'verifyPasswordForRemoving2FA',
      desc: '',
      args: [],
    );
  }

  /// `Successfully removed 2FA`
  String get successfullyRemoved2fa {
    return Intl.message(
      'Successfully removed 2FA',
      name: 'successfullyRemoved2fa',
      desc: '',
      args: [],
    );
  }

  /// `Error while removing 2FA`
  String get errorWhileRemoving2fa {
    return Intl.message(
      'Error while removing 2FA',
      name: 'errorWhileRemoving2fa',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Input your password`
  String get inputYourPassword {
    return Intl.message(
      'Input your password',
      name: 'inputYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please put in your current password`
  String get pleasePutInYourCurrentPassword {
    return Intl.message(
      'Please put in your current password',
      name: 'pleasePutInYourCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Verify with two-factor authentication`
  String get verifyYourTwofactorAuthentication {
    return Intl.message(
      'Verify with two-factor authentication',
      name: 'verifyYourTwofactorAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Please add the two-factor authentication to your App (e.g. Google Authenticator) by scanning the QR-Code or copying the secret`
  String get add2FAtoApp {
    return Intl.message(
      'Please add the two-factor authentication to your App (e.g. Google Authenticator) by scanning the QR-Code or copying the secret',
      name: 'add2FAtoApp',
      desc: '',
      args: [],
    );
  }

  /// `Secret copied to clipboard`
  String get secretCopiedToClipboard {
    return Intl.message(
      'Secret copied to clipboard',
      name: 'secretCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Copy secret`
  String get copySecret {
    return Intl.message(
      'Copy secret',
      name: 'copySecret',
      desc: '',
      args: [],
    );
  }

  /// `Successfully added 2FA to your account`
  String get successfullyAdded2faToYourAccount {
    return Intl.message(
      'Successfully added 2FA to your account',
      name: 'successfullyAdded2faToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'nl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
