import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/models/station.dart';
import '../domain/models/game_meta.dart';

class IsarDb {
  final Isar isar;
  IsarDb._(this.isar);

  static Future<IsarDb> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([
      StationEntitySchema,
      GameMetaSchema,
    ], directory: dir.path);
    return IsarDb._(isar);
  }
}
