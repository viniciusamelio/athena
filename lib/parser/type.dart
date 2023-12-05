import 'package:frida_query_builder/frida_query_builder.dart';

import '../model/fields/fields.dart';

ColumnDataType parseTypeToFrida(FieldType type) {
  switch (type) {
    case FieldType.varchar:
      return ColumnDataType.text;
    case FieldType.int:
      return ColumnDataType.integer;
    case FieldType.double:
      return ColumnDataType.real;
    case FieldType.bool:
      return ColumnDataType.integer;
    default:
      return ColumnDataType.text;
  }
}
