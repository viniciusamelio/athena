import '../model/fields/key.dart';

extension Parser on ForeignKeyField {
  String parse() {
    return "FOREIGN KEY ($name) references $collectionName($fieldName)";
  }
}
