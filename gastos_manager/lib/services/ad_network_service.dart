import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Serviço para monitorar conectividade e afetar comportamento de anúncios
class AdNetworkService {
  static final AdNetworkService _instance = AdNetworkService._internal();
  factory AdNetworkService() => _instance;
  AdNetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isConnected = true;
  bool _isInitialized = false;

  bool get isConnected => _isConnected;
  bool get isInitialized => _isInitialized;

  /// Inicializar monitoramento de rede
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Verificar estado inicial
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);

      // Monitorar mudanças
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
        onError: (error) {
          debugPrint('❌ NETWORK: Erro ao monitorar conectividade: $error');
        },
      );

      _isInitialized = true;
      debugPrint('✅ NETWORK: Monitoramento de rede inicializado');
    } catch (e) {
      debugPrint('❌ NETWORK: Erro ao inicializar monitoramento: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;

    // Considerar conectado se tiver qualquer tipo de conexão
    _isConnected = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );

    if (wasConnected != _isConnected) {
      debugPrint(
        '🌐 NETWORK: Status de conectividade alterado: ${_isConnected ? "CONECTADO" : "DESCONECTADO"}',
      );

      if (_isConnected) {
        debugPrint(
          '✅ NETWORK: Conexão restaurada - anúncios podem ser carregados',
        );
      } else {
        debugPrint('⚠️ NETWORK: Sem conexão - anúncios não serão carregados');
      }
    }
  }

  /// Verificar se pode tentar carregar anúncios baseado na conectividade
  bool canLoadAds() {
    if (!_isInitialized) {
      debugPrint(
        '⚠️ NETWORK: Serviço não inicializado, assumindo conexão disponível',
      );
      return true;
    }

    return _isConnected;
  }

  /// Obter tipo de conexão atual para debug
  Future<String> getConnectionType() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) return 'none';

      final types = results.map((result) {
        switch (result) {
          case ConnectivityResult.wifi:
            return 'wifi';
          case ConnectivityResult.mobile:
            return 'mobile';
          case ConnectivityResult.ethernet:
            return 'ethernet';
          case ConnectivityResult.vpn:
            return 'vpn';
          case ConnectivityResult.bluetooth:
            return 'bluetooth';
          case ConnectivityResult.other:
            return 'other';
          case ConnectivityResult.none:
            return 'none';
        }
      }).toList();

      return types.join(', ');
    } catch (e) {
      debugPrint('❌ NETWORK: Erro ao obter tipo de conexão: $e');
      return 'unknown';
    }
  }

  /// Teste de conectividade mais específico para anúncios
  Future<bool> testAdConnectivity() async {
    if (!_isConnected) return false;

    // Aqui poderia fazer um ping para servidores do AdMob
    // Por enquanto, só retorna o status básico de conectividade
    return _isConnected;
  }

  /// Limpar recursos
  void dispose() {
    _connectivitySubscription?.cancel();
    _isInitialized = false;
    debugPrint('🧹 NETWORK: Serviço de rede limpo');
  }
}
