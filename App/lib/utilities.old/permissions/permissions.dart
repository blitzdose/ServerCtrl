class Permissions {
  static const String PERMISSION_ADMIN = "admin";
  static const String PERMISSION_KICK = "kick";
  static const String PERMISSION_BAN = "ban";
  static const String PERMISSION_OP = "op";
  static const String PERMISSION_CONSOLE = "console";
  static const String PERMISSION_PLUGINSETTINGS = "pluginsettings";
  static const String PERMISSION_SERVERSETTINGS = "serversettings";
  static const String PERMISSION_LOG = "log";
  static const String PERMISSION_FILES = "files";

  static const TAB_CONSOLE = "tab_console";
  static const TAB_PLAYERS = "tab_players";
  static const TAB_FILES = "tab_files";
  static const TAB_LOG = "tab_log";
  static const TAB_ACCOUNTS = "tab_accounts";
  static const TAB_SETTINGS = "tab_settings";

  final List<String> _permissions;

  Permissions(this._permissions);

  bool hasPermission(String permission) {
    return _permissions.contains(permission) || _permissions.contains(PERMISSION_ADMIN);
  }

  bool hasPermissionsFor(String tab) {
    if (hasPermission(PERMISSION_ADMIN)) {
      return true;
    }
    switch (tab) {
      case TAB_CONSOLE:
        return hasPermission(PERMISSION_CONSOLE);
      case TAB_PLAYERS:
        return hasPermission(PERMISSION_KICK) || hasPermission(PERMISSION_BAN) ||hasPermission(PERMISSION_OP);
      case TAB_FILES:
        return hasPermission(PERMISSION_FILES);
      case TAB_LOG:
        return hasPermission(PERMISSION_LOG);
      case TAB_ACCOUNTS:
        return hasPermission(PERMISSION_ADMIN);
      case TAB_SETTINGS:
        return hasPermission(PERMISSION_PLUGINSETTINGS) || hasPermission(PERMISSION_SERVERSETTINGS);
    }
    return false;
  }

  int getTabCount() {
    int tabCount = 2;
    if (hasPermission(PERMISSION_ADMIN)) {
      return 7;
    } else {
      if (hasPermissionsFor(TAB_CONSOLE)) {
        tabCount++;
      }
      if (hasPermissionsFor(TAB_PLAYERS)) {
        tabCount++;
      }
      if (hasPermissionsFor(TAB_FILES)) {
        tabCount++;
      }  
      if (hasPermissionsFor(TAB_LOG)) {
        tabCount++;
      }
    }
    return tabCount;
  }

}