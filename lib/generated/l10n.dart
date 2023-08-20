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
      desc: '',
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

  /// `Account {name}`
  String accountAndName(String name) {
    return Intl.message(
      'Account $name',
      name: 'accountAndName',
      desc: '',
      args: [name],
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
  String deleteAccountMessage(String accountName) {
    return Intl.message(
      'The account "$accountName" will be permanently removed.',
      name: 'deleteAccountMessage',
      desc: '',
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
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
