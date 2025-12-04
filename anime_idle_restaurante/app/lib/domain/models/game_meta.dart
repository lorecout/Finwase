import 'package:isar/isar.dart';

part 'game_meta.g.dart';

@collection
class GameMeta {
  Id id = 0; // único
  double currency = 0;
  DateTime lastOpened = DateTime.now();
}
