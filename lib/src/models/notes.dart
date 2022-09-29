import 'package:isar/isar.dart';
part 'notes.g.dart';

@Collection()
class Notes {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;
  late DateTime date;
}
