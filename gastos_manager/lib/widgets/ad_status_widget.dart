import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ad_service.dart';
import '../services/premium_service.dart';

/// Widget para mostrar status detalhado do sistema de anúncios
class AdStatusWidget extends StatefulWidget {
  const AdStatusWidget({Key? key}) : super(key: key);

  @override
  State<AdStatusWidget> createState() => _AdStatusWidgetState();
}

class _AdStatusWidgetState extends State<AdStatusWidget> {
  Map<String, dynamic> _adStatus = {};

  @override
  void initState() {
    super.initState();
    _updateStatus();

    // Atualizar status a cada 5 segundos
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _updateStatus();
      } else {
        timer.cancel();
      }
    });
  }

  void _updateStatus() {
    setState(() {
      _adStatus = AdService.getAdStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 STATUS DO SISTEMA DE ANÚNCIOS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'AdMob Inicializado',
            _adStatus['initialized'] == true,
          ),
          _buildStatusRow(
            'Rede Conectada',
            _adStatus['networkConnected'] == true,
          ),
          _buildStatusRow('Usuário Premium', premiumService.isPremium),
          _buildStatusRow('Anúncios Bloqueados', _adStatus['blocked'] == true),
          _buildStatusRow(
            'Pode Solicitar Anúncio',
            _adStatus['canRequestAd'] == true,
          ),

          const SizedBox(height: 8),
          Text(
            'Falhas Consecutivas: ${_adStatus['consecutiveFailures'] ?? 0}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),

          if (_adStatus['lastAdRequest'] != null) ...[
            Text(
              'Última Requisição: ${_formatTime(_adStatus['lastAdRequest'])}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],

          if (_adStatus['blockStartTime'] != null) ...[
            Text(
              'Início do Bloqueio: ${_formatTime(_adStatus['blockStartTime'])}',
              style: TextStyle(fontSize: 12, color: Colors.red.shade700),
            ),
          ],

          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: _updateStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                child: const Text('Atualizar', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              if (premiumService.isPremium)
                ElevatedButton(
                  onPressed: () => premiumService.downgradeToFree(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                  child: const Text('→ Free', style: TextStyle(fontSize: 12)),
                )
              else
                ElevatedButton(
                  onPressed: () => premiumService.upgradeToPremium('debug'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                  child: const Text(
                    '→ Premium',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            color: status ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: ${status ? 'SIM' : 'NÃO'}',
              style: TextStyle(
                fontSize: 12,
                color: status ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? isoString) {
    if (isoString == null) return 'N/A';

    try {
      final dateTime = DateTime.parse(isoString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds}s atrás';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}min atrás';
      } else {
        return '${difference.inHours}h atrás';
      }
    } catch (e) {
      return 'Formato inválido';
    }
  }
}
