import 'package:athena/model/fields/fields.dart';
import 'package:athena/parser/field.dart';
import 'package:test/test.dart';

void main() {
  group(
    "FIELD PARSER: ",
    () {
      test(
        "sut should parse the simplest field",
        () {
          const sut = DataField(
            name: "name",
            type: FieldType.varchar,
            length: 80,
          );

          final result = sut.parse();

          expect(result, equals("name VARCHAR(80)"));
        },
      );

      test(
        "sut should parse an unique",
        () {
          const sut = DataField(
            name: "id",
            type: FieldType.varchar,
            length: 16,
            unique: true,
          );

          final result = sut.parse();

          expect(result, equals("id VARCHAR(16) UNIQUE"));
        },
      );

      test(
        "sut should parse a nullable",
        () {
          const sut = DataField(
            name: "amount",
            type: FieldType.int,
            length: 12,
            nullable: false,
          );

          final result = sut.parse();

          expect(result, equals("amount INTEGER(12) NOT NULL"));
        },
      );

      test(
        "sut should parse a PK",
        () {
          const sut = DataField(
            name: "id",
            type: FieldType.varchar,
            nullable: false,
            primary: true,
          );

          final result = sut.parse();

          expect(result, equals("id VARCHAR NOT NULL PRIMARY KEY"));
        },
      );

      test(
        "sut should parse a PK, not nullable and unique",
        () {
          const sut = DataField(
            name: "id",
            type: FieldType.double,
            nullable: false,
            primary: true,
            unique: true,
          );

          final result = sut.parse();

          expect(result, equals("id REAL NOT NULL UNIQUE PRIMARY KEY"));
        },
      );
    },
  );
}
