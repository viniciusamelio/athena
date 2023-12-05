import 'package:athena/athena.dart';

class UserTable extends TableCollection {
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

class AddressTable extends TableCollection {
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
