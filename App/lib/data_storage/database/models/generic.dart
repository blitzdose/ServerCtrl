abstract class DatabaseModel {
  DatabaseModel();
  DatabaseModel.fromMap(Map<String, Object?> map);
  Map<String, Object?> toMap();
  Object getPrimaryKey();
}