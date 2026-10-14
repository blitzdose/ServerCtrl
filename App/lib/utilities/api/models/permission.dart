class UserPermissions {
  bool isSuperAdmin;
  Map<String, List<Permission>> systemPermissions;

  UserPermissions(this.isSuperAdmin, this.systemPermissions);

  static Permission parsePermission(String permission) {
    return Permission.values.firstWhere((element) => element.name == permission, orElse: () => Permission.ACCESS);
  }

  Map<String, List<String>> serialize() {
    return systemPermissions.map((key, value) => MapEntry(key, value.map((e) => e.name).toList()));
  }

  List<Permission> getPermissionsForSystem(String system) {
    if (isSuperAdmin) {
      return Permission.values;
    }
    List<Permission>? permissions = systemPermissions[system];
    return permissions ?? [];
  }

}

enum Permission {
  ACCESS,
  KICK,
  BAN,
  OP,
  CONSOLE,
  SERVERSETTINGS,
  LOG,
  FILES,
  ADMIN;
}