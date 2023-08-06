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
