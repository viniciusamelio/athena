import '../model/fields/field.dart';

extension Parser on CollectionField {
  String parse() {
    String string = "$name ${type.value}";
    if ([FieldType.int, FieldType.varchar].contains(type) && length != null) {
      string += "($length)";
    }
    if (defaultValue != null) {
      string += " DEFAULT $defaultValue";
    }
    if (!nullable) {
      string += " NOT NULL";
    }
    if (unique) {
      string += " UNIQUE";
    }
    if (primary) {
      string += " PRIMARY KEY";
    }

    return string;
  }
}
