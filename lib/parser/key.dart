import '../model/fields/key.dart';

extension FkParser on ForeignKeyField {
  String parse() {
    return "FOREIGN KEY ($name) references $collectionName($fieldName)";
  }
}
