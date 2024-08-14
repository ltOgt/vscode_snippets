// -----------------------------------------------------------------------------
// yaml - check versions
/*
  drift: ^2.8.0
  sqlite3_flutter_libs: ^0.5.0
dev_dependencies:
  build_runner: ^2.4.4
  drift_dev: ^2.8.2
*/

// -----------------------------------------------------------------------------
// db.dart

// To open the database, add these imports to the existing file defining the
// database class. They are used to open the database.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '/db/tables.dart';

part 'db.g.dart';
part 'queries.dart';

@DriftDatabase(tables: [MyTable])
class LocalDB extends _$LocalDB {
  // we tell the database where to store the data with this constructor
  LocalDB() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(myTable, myTable.newColumn);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    final dbFolder = await PathConfig.dbFolderFuture;
    if (!dbFolder.existsSync()) {
      dbFolder.createSync(recursive: true);
    }
    final file = File(p.join(dbFolder.path, 'myapp.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// -----------------------------------------------------------------------------
// db.g.dart - create empty

// -----------------------------------------------------------------------------
// queries.dart
extension ApiQueriesX on LocalDB {
  Future<List<ApiKey>> readApiKeys() => select(apiKeys).get();

  // Function to create a new entry
  Future<void> createApiKey(String value) => into(apiKeys).insert(
        ApiKeysCompanion(value: Value(value)),
      );

  // Function to delete an entry by value
  Future<int> deleteApiKey(String value) => (delete(apiKeys)
        ..where(
          (tbl) => tbl.value.equals(value),
        ))
      .go();
}

// -----------------------------------------------------------------------------
// tables.dart
class ApiKeys extends Table {
  TextColumn get value => text().unique()();
}
