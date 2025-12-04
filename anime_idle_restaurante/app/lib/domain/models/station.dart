import 'package:isar/isar.dart';

part 'station.g.dart';

@collection
class StationEntity {
  Id id = Isar.autoIncrement; // interno Isar
  late String key; // identificador lógico (ex: 'fogao')
  int level = 1;
  double baseRatePerSec = 1.0;
  double valuePerDish = 1.0;
  double multiplier = 1.0;

  double productionPerSec() => baseRatePerSec * multiplier * level;
  double dishValue() => valuePerDish * (1 + (level - 1) * 0.1) * multiplier;
}
