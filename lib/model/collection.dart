import 'fields/fields.dart';

abstract interface class DataCollection {
  String get name;
  List<CollectionField> get fields;
  List<ForeignKeyField> get foreignKeys;
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
}
