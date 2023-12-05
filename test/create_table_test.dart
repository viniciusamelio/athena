import 'package:athena/model/collection.dart';
import 'package:athena/model/fields/fields.dart';
import 'package:athena/parser/table.dart';
import 'package:faker/faker.dart';
import 'package:frida_query_builder/frida_query_builder.dart';
import 'package:test/test.dart';
import "package:sqlite3/sqlite3.dart";

void main() {
  group("[QUERY BUILDING] CREATE TABLE: ", () {
    late Database db;
    setUp(
      () async {
        db = sqlite3.openInMemory();
      },
    );

    tearDown(() {
      db.dispose();
    });

    test(
      "database should be created according to table definition",
      () async {
        const sut = DataTable(
          name: "user",
          fields: [
            DataField(
              type: FieldType.varchar,
              primary: true,
              name: "id",
            ),
            DataField(
              type: FieldType.varchar,
              unique: true,
              length: 100,
              name: "email",
              nullable: false,
            ),
            DataField(
              type: FieldType.varchar,
              name: "hash",
              nullable: false,
            ),
          ],
          foreignKeys: [],
        );

        db.execute(
          sut.toCreateString(),
        );
        final id = faker.guid.guid();

        db.execute(
          "INSERT INTO user (id, email, hash) VALUES (?, ?, ?)",
          [
            id,
            faker.internet.email(),
            faker.guid.guid(),
          ],
        );

        final result = db.select(
          "SELECT * FROM user",
        );

        expect(result.rows.length, equals(1));
        expect(result.first["id"], equals(id));
      },
    );

    test(
      "database should be created according to table definition when handling datefields",
      () async {
        const sut = DataTable(
          name: "user",
          fields: [
            DataField(
              type: FieldType.varchar,
              primary: true,
              name: "id",
            ),
            DataField(
              type: FieldType.datetime,
              name: "created_at",
              nullable: false,
            ),
          ],
          foreignKeys: [],
        );

        db.execute(
          sut.toCreateString(),
        );
        final id = faker.guid.guid();

        db.execute(
          "INSERT INTO user (id, created_at) VALUES (?, ?)",
          [
            id,
            DateTime.now().toIso8601String(),
          ],
        );

        final result = db.select(
          "SELECT * FROM user WHERE created_at BETWEEN ? AND ?",
          [
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          ],
        );

        expect(result.rows.length, equals(1));
        expect(result.first["id"], equals(id));
      },
    );

    test(
      "table creation should have the same effect using frida",
      () async {
        const sut = DataTable(
          name: "user",
          fields: [
            DataField(
              type: FieldType.varchar,
              primary: true,
              name: "id",
            ),
            DataField(
              type: FieldType.datetime,
              name: "created_at",
              nullable: false,
            ),
          ],
          foreignKeys: [],
        );

        db.execute(
          sut.toCreateString(),
        );
        final id = faker.guid.guid();

        final query = sut.insert({
          "id": id,
          "created_at": DateTime.now().toIso8601String(),
        });

        db.execute(query);

        final result = db.select(
          "SELECT * FROM user WHERE created_at BETWEEN ? AND ?",
          [
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          ],
        );

        expect(result.rows.length, equals(1));
        expect(result.first["id"], equals(id));
      },
    );

    test(
      "table creation should work with foreign keys",
      () {
        final userId = faker.guid.guid();
        final userTable = UserTable();
        final addressTable = AddressTable();

        db.execute(userTable.create());
        db.execute(addressTable.create());

        db.execute(userTable.insert({
          "id": userId,
          "created_at": DateTime.now().toIso8601String(),
        }));
        db.execute(addressTable.insert({
          "id": faker.guid.guid(),
          "zip_code": "000",
          "user_id": userId,
        }));

        final query = FridaQueryBuilder(
          Select(
            from: "user",
            joins: [
              Join(
                "address",
                alias: "address",
                criteria: [
                  Equals(
                    "user.id",
                    "address.user_id",
                    firstFieldQuoted: false,
                    secondFieldQuoted: false,
                  ),
                ],
              ),
            ],
          ),
        ).build();
        final result = db.select(query);

        print(result.first);

        expect(result.rows.length, equals(1));
      },
    );
  });
}

class UserTable extends DataTable {
  UserTable()
      : super(
          name: "user",
          fields: const [
            DataField(
              type: FieldType.varchar,
              primary: true,
              name: "id",
            ),
            DataField(
              type: FieldType.datetime,
              name: "created_at",
              nullable: false,
            ),
          ],
          foreignKeys: [],
        );
}

class AddressTable extends DataTable {
  AddressTable()
      : super(
          name: "address",
          fields: const [
            DataField(
              type: FieldType.varchar,
              primary: true,
              name: "id",
            ),
            DataField(
              type: FieldType.varchar,
              name: "zip_code",
            ),
            DataField(
              type: FieldType.varchar,
              name: "user_id",
              nullable: false,
            ),
          ],
          foreignKeys: const [
            ForeignKeyField(
              name: "user_id",
              collectionName: "user",
              fieldName: "id",
            ),
          ],
        );
}
