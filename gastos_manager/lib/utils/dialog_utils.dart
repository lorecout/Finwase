import 'package:flutter/material.dart';

/// Utilitário para exibir diálogos comuns de forma consistente
class DialogUtils {
  /// Exibe um diálogo de confirmação simples
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: confirmColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Exibe um diálogo de informação simples
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String content,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Exibe um diálogo com campo de texto
  static Future<String?> showTextInputDialog(
    BuildContext context, {
    required String title,
    required String labelText,
    String? initialValue,
    String confirmText = 'Salvar',
    String cancelText = 'Cancelar',
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    final controller = TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Exibe um diálogo de seleção única
  static Future<int?> showSingleChoiceDialog(
    BuildContext context, {
    required String title,
    required List<String> options,
    int? initialValue,
    String confirmText = 'Selecionar',
    String cancelText = 'Cancelar',
  }) {
    int? selectedValue = initialValue;

    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return InkWell(
                onTap: () => setState(() => selectedValue = index),
                child: Row(
                  children: [
                    Icon(
                      selectedValue == index
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(option)),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: selectedValue != null
                  ? () => Navigator.pop(context, selectedValue)
                  : null,
              child: Text(confirmText),
            ),
          ],
        ),
      ),
    );
  }

  /// Exibe um diálogo de carregamento
  static Future<void> showLoadingDialog(
    BuildContext context, {
    required String message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  /// Fecha o diálogo atual
  static void hideDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
