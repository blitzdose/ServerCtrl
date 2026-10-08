abstract interface class StorageDatabaseException implements Exception { }

class AlreadyExistsException implements StorageDatabaseException { }

class NotFoundException implements StorageDatabaseException { }

class UnknownException implements StorageDatabaseException { }
