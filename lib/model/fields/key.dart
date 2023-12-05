class ForeignKeyField {
  const ForeignKeyField({
    required this.name,
    required this.collectionName,
    required this.fieldName,
  });
  final String name;
  final String collectionName;
  final String fieldName;
}
