import 'package:athena/model/collection.dart';
import 'package:athena/model/fields/fields.dart';
import 'package:athena/parser/table.dart';
import 'package:test/test.dart';

void main() {
  group(
    "DATATABLE PARSER: ",
    () {
      test(
        "sut should parse as expected",
        () {
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

          final result = sut.parse();

          expect(
            result,
            equals(
              "user (id VARCHAR PRIMARY KEY, email VARCHAR(100) NOT NULL UNIQUE, hash VARCHAR NOT NULL) ",
            ),
          );
        },
      );

      test(
        "sut should parse to create as expected",
        () {
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
              DataField(
                type: FieldType.datetime,
                name: "created_at",
                nullable: false,
              ),
            ],
            foreignKeys: [
              ForeignKeyField(
                name: "address_fk",
                collectionName: "address",
                fieldName: "id",
              ),
            ],
          );

          final result = sut.toCreateString();

          expect(
            result,
            equals(
              "CREATE TABLE user (id VARCHAR PRIMARY KEY, email VARCHAR(100) NOT NULL UNIQUE, hash VARCHAR NOT NULL, created_at TEXT NOT NULL) FOREIGN KEY (address_fk) references address(id)",
            ),
          );
        },
      );
    },
  );
}
