// TODO add dependencies to pubspec.yaml
// dependencies:
//   # Fluent API for sqlite
//   moor_flutter:
//
// dev_dependencies:
//   # Generates the actual implementation of database specification
//   moor_generator:
//   # Provides commands for generating source files
//   build_runner:

import 'package:moor_flutter/moor_flutter.dart';

// TODO run `flutter packages pub run build_runner [watch|build] --delete-conflicting-outputs`
part 'moor_db.g.dart';

// TODO rename database
const String DATABASE_PATH = "database.sqlite";

@UseMoor(tables: [
  // TODO add tables (just the class name)
], daos: [
  // TODO add daos (just the class name)
])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          FlutterQueryExecutor.inDatabaseFolder(
            path: DATABASE_PATH,
            logStatements: true, // TODO remove, only for debugging
          ),
        ) {
    this.customStatement("PRAGMA foreign_keys = ON");
  }

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration =>
  //     MigrationStrategy(beforeOpen: (openingDetails) async {
  //       if (true) {
  //         final m = this.createMigrator(); // changed to this
  //         for (final table in allTables) {
  //           await m.deleteTable(table.actualTableName);
  //           await m.createTable(table);
  //         }
  //       }
  //     });
}
