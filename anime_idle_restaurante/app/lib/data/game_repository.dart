import 'package:isar/isar.dart';
import '../domain/models/station.dart';
import '../domain/models/game_meta.dart';

class GameRepository {
  final Isar isar;
  GameRepository(this.isar);

  Future<void> seedIfNeeded() async {
    final stationCount = await isar.stationEntitys.count();
    if (stationCount == 0) {
      final stations = [
        StationEntity()..key = 'fogao'..baseRatePerSec = 1.2,
        StationEntity()..key = 'forno'..baseRatePerSec = 0.8,
      ];
      await isar.writeTxn(() async {
        await isar.stationEntitys.putAll(stations);
        await isar.gameMetas.put(GameMeta()..id = 0..currency = 0);
      });
    }
  }

  Future<List<StationEntity>> getStations() async {
    return await isar.stationEntitys.where().findAll();
  }

  Future<GameMeta> getMeta() async {
    final meta = await isar.gameMetas.get(0);
    if (meta == null) {
      final newMeta = GameMeta()..id = 0..currency = 0;
      await isar.writeTxn(() async => await isar.gameMetas.put(newMeta));
      return newMeta;
    }
    return meta;
  }

  Future<void> saveCurrency(double value) async {
    await isar.writeTxn(() async {
      final meta = await getMeta();
      meta.currency = value;
      meta.lastOpened = DateTime.now();
      await isar.gameMetas.put(meta);
    });
  }
}
