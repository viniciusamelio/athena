import 'package:frida_query_builder/frida_query_builder.dart';

import '../parser/type.dart';
import 'fields/fields.dart';

abstract interface class DataCollection {
  String get name;
  List<CollectionField> get fields;
  List<ForeignKeyField> get foreignKeys;

  String insert(Map<String, dynamic> data);
  String create();
}

class DataTable implements DataCollection {
  const DataTable({
    required this.name,
    required this.fields,
    required this.foreignKeys,
  });

  @override
  final String name;
  @override
  final List<CollectionField> fields;
  @override
  final List<ForeignKeyField> foreignKeys;

  @override
  String insert(Map<String, dynamic> data) {
    return FridaQueryBuilder(
      Insert(
        into: name,
        values: data,
      ),
    ).build();
  }

  @override
  String create() {
    return FridaQueryBuilder(
      Create(
        tableName: name,
        columns: fields
            .map(
              (e) => Column(
                name: e.name,
                isPrimaryKey: e.primary,
                isNotNull: !e.nullable,
                defaultValue: e.defaultValue,
                type: parseTypeToFrida(e.type),
              ),
            )
            .toList(),
      ),
    ).build();
  }
}
