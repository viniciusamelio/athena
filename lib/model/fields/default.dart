import 'fields.dart';

class DataField implements CollectionField {
  const DataField({
    this.length,
    this.defaultValue,
    this.nullable = true,
    this.primary = false,
    this.unique = false,
    required this.type,
    required this.name,
  });

  @override
  final int? length;

  @override
  final String name;

  @override
  final bool nullable;

  @override
  final bool primary;

  @override
  final FieldType type;

  @override
  final bool unique;

  @override
  final dynamic defaultValue;
}
