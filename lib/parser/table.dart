import '../model/collection.dart';
import 'field.dart';
import 'key.dart';

extension Parser on DataTable {
  String parse() {
    return "$name (${fields.map((e) => e.parse()).join(", ")}) ${foreignKeys.map((e) => e.parse()).join(", ")}";
  }

  String toCreateString() {
    return "CREATE TABLE ${parse()}";
  }
}
