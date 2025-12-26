import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

/// Central place to evaluate premium / ads behavior.
///
/// Usage:
///   final pm = await PremiumManager.instance;
///   final isPremium = await pm.isPremium(adSupported: true);
///   final showAds = await pm.shouldShowAds();
class PremiumManager {
  PremiumManager._internal();

  static final Future<PremiumManager> _instance = _create();
  static Future<PremiumManager> get instance => _instance;

  static Future<PremiumManager> _create() async {
    final m = PremiumManager._internal();
    await m._init();
    return m;
  }

  late SharedPreferences _prefs;
  static const String _kPurchasedRemoveAds = 'purchased_remove_ads';

  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      // If SharedPreferences isn't available in some test contexts,
      // create a minimal in-memory shim.
      if (kDebugMode) {
        debugPrint(
          'SharedPreferences unavailable, using in-memory fallback: $e',
        );
      }
      _prefs = _InMemoryPreferences();
    }
  }

  /// Mark that user purchased the remove-ads product (or subscription).
  Future<void> setPurchasedRemoveAds(bool purchased) async {
    await _prefs.setBool(_kPurchasedRemoveAds, purchased);
  }

  /// Returns whether the user has purchased remove-ads.
  bool _hasPurchasedRemoveAds() {
    return _prefs.getBool(_kPurchasedRemoveAds) ?? false;
  }

  /// Determine if the user should be treated as premium.
  ///
  /// Rules (implemented):
  /// - If FORCE_PREMIUM is true -> premium (MODO GRATUITO TOTAL).
  /// - If user purchased remove-ads -> premium (they paid).
  /// - If ADS_MODE_GIVES_PREMIUM is true AND adSupported == true -> premium.
  /// - Otherwise not premium.
  Future<bool> isPremium({required bool adSupported}) async {
    // MODO GRATUITO TOTAL: sempre premium
    if (FORCE_PREMIUM) return true;
    if (_hasPurchasedRemoveAds()) return true;
    if (ADS_MODE_GIVES_PREMIUM && adSupported) return true;
    return false;
  }

  /// Should the app show ads to the user?
  /// 
  /// MODO GRATUITO TOTAL: nunca mostrar anúncios
  /// Ads are shown if the user hasn't purchased remove-ads.
  /// The ADS_MODE_GIVES_PREMIUM flag does not remove ads — it only grants
  /// premium features while keeping ads enabled.
  Future<bool> shouldShowAds() async {
    // FORÇA PREMIUM = sem anúncios
    if (FORCE_PREMIUM) return false;
    return !_hasPurchasedRemoveAds();
  }

  /// Helper to check whether removing ads requires a purchase.
  bool removeAdsRequiresPurchase() => REMOVE_ADS_PURCHASE_REQUIRED;
}

// Minimal in-memory shim implementing the SharedPreferences API surface
// used above to avoid runtime crashes in test contexts where the plugin
// might not be available.
class _InMemoryPreferences implements SharedPreferences {
  final Map<String, Object> _map = {};

  @override
  Future<bool> commit() async => true;

  @override
  Object? get(String key) => _map[key];

  @override
  Future<bool> clear() async {
    _map.clear();
    return true;
  }

  @override
  bool? getBool(String key) => _map[key] as bool?;

  @override
  double? getDouble(String key) => _map[key] as double?;

  @override
  int? getInt(String key) => _map[key] as int?;

  @override
  Set<String> getKeys() => _map.keys.toSet();

  @override
  String? getString(String key) => _map[key] as String?;

  @override
  List<String>? getStringList(String key) => _map[key] as List<String>?;

  @override
  Future<bool> remove(String key) async {
    _map.remove(key);
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _map[key] = value;
    return true;
  }

  // The following members are unused in this project but must be
  // implemented to satisfy the interface.

  @override
  bool containsKey(String key) => _map.containsKey(key);

  @override
  Future<void> reload() async {}

  @override
  String? getStringSync(String key) => getString(key);
}
