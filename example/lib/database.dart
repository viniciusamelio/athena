import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'tables.dart';

late Database db;

Future<void> initDatabase() async {
  final docPath = await getApplicationDocumentsDirectory();
  db = await openDatabase("$docPath/database.db",
      version: 1, password: "myPassword", onCreate: (db, _) async {
    final user = UserTable();
    final address = AddressTable();

    await db.execute(user.create());
    await db.execute(address.create());
    await db.execute(user.insert({
      "id": "mockedId",
      "created_at": DateTime.now().toIso8601String(),
    }));

    await db.execute(address.insert({
      "id": "mockedAddressId",
      "zip_code": "01600-000",
      "user_id": "mockedId"
    }));
  });
}
