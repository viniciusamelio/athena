import '../model/collection.dart';
import 'field.dart';
import 'key.dart';

extension TableParser on TableCollection {
  String parse() {
    return "$name (${fields.map((e) => e.parse()).join(", ")}) ${foreignKeys.map((e) => e.parse()).join(", ")}";
  }

  String toCreateString() {
    return "CREATE TABLE ${parse()}";
  }
}
