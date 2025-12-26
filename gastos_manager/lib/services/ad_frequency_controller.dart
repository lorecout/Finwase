import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdFrequencyController {
  static final AdFrequencyController _instance =
      AdFrequencyController._internal();
  factory AdFrequencyController() => _instance;
  AdFrequencyController._internal();

  DateTime? _lastInterstitial;
  final Duration minInterval = const Duration(minutes: 2);

  bool canShowInterstitial() {
    if (_lastInterstitial == null) return true;
    return DateTime.now().difference(_lastInterstitial!) > minInterval;
  }

  void markInterstitialShown() {
    _lastInterstitial = DateTime.now();
  }
}
