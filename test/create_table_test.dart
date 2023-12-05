import 'package:athena/model/collection.dart';
import 'package:athena/model/fields/fields.dart';
import 'package:athena/parser/table.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import "package:sqlite3/sqlite3.dart";

void main() {
  group("[INTEGRATION] CREATE TABLE: ", () {
    late final Database db;
    setUpAll(
      () async {
        db = sqlite3.openInMemory();
      },
    );

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
  });
}
