import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class ErrorBanner extends StatelessWidget {
  final VoidCallback? onDismissed;
  final Duration displayDuration;

  const ErrorBanner({
    super.key,
    this.onDismissed,
    this.displayDuration = const Duration(seconds: 5),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.error == null) return const SizedBox.shrink();

        // Esconde o banner após o tempo definido
        Future.delayed(displayDuration, () {
          if (appState.error != null) {
            appState.clearError();
            onDismissed?.call();
          }
        });

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.redAccent,
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  appState.error!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  appState.clearError();
                  onDismissed?.call();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
