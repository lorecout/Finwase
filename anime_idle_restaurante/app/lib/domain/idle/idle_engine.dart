import 'dart:async';
import '../models/staff_member.dart';
import '../models/station.dart';

class IdleEngine {
  final List<StationEntity> stations;
  final List<StaffMember> staff;
  Timer? _timer;
  double _pendingCurrency = 0;
  DateTime _lastTick = DateTime.now();
  final void Function(double generated)? onCurrencyGenerated;

  IdleEngine({
    required this.stations,
    required this.staff,
    this.onCurrencyGenerated,
  });

  void start() {
    _lastTick = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void stop() {
    _timer?.cancel();
  }

  void _tick() {
    final now = DateTime.now();
    final deltaSec = now.difference(_lastTick).inMilliseconds / 1000.0;
    _lastTick = now;

    double cycleProduction = 0;
    final staffMultiplier = _staffProductionMultiplier();
    for (final s in stations) {
      cycleProduction += s.productionPerSec() * deltaSec * staffMultiplier;
    }
    _pendingCurrency += cycleProduction;
    if (_pendingCurrency >= 1) {
      final toEmit = _pendingCurrency.floorToDouble();
      _pendingCurrency -= toEmit;
      onCurrencyGenerated?.call(toEmit);
    }
  }

  double offlineGain(DateTime lastSaved) {
    final now = DateTime.now();
    final deltaSec = now.difference(lastSaved).inSeconds.toDouble();
    double production = 0;
    final staffMultiplier = _staffProductionMultiplier();
    for (final s in stations) {
      production += s.productionPerSec() * deltaSec * staffMultiplier;
    }
    return production;
  }

  double _staffProductionMultiplier() {
    double mult = 1.0;
    for (final m in staff) {
      mult *= m.totalProductionMultiplier();
    }
    return mult;
  }
}

// StationSimple removida: usar StationEntity persistida em Isar
