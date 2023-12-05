enum FieldType {
  varchar("VARCHAR"),
  int("INTEGER"),
  double("REAL"),
  bool("BOOLEAN"),
  datetime("TEXT");

  final String value;
  const FieldType(this.value);
}

abstract interface class CollectionField {
  const CollectionField();

  String get name;
  FieldType get type;
  int? get length;
  dynamic get defaultValue;

  bool get unique;
  bool get primary;
  bool get nullable;
}
