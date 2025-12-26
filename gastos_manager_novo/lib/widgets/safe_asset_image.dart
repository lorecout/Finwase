import 'package:flutter/material.dart';
import 'dart:convert';

/// Widget que carrega um asset de imagem com fallback e tratamento de erro.
/// Use-o no lugar de `Image.asset` quando o asset puder não existir em tempo de execução
/// (por exemplo assets dinâmicos ou problemas de packaging em testes/emulador).
class SafeAssetImage extends StatelessWidget {
  final String assetPath;
  final String? fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final String? semanticLabel;

  const SafeAssetImage(
    this.assetPath, {
    super.key,
    this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    // Tenta carregar a imagem principal. Se falhar, tenta o fallback (se fornecido)
    // e por fim exibe um placeholder discreto.
    return FutureBuilder<bool>(
      future: _assetExists(context, assetPath),
      builder: (context, snap) {
        final exists = snap.data ?? false;
        if (exists) {
          return Image.asset(
            assetPath,
            width: width,
            height: height,
            fit: fit,
            color: color,
            semanticLabel: semanticLabel,
            errorBuilder: (context, error, stack) {
              if (fallbackAsset != null && fallbackAsset != assetPath) {
                return Image.asset(
                  fallbackAsset!,
                  width: width,
                  height: height,
                  fit: fit,
                  color: color,
                  semanticLabel: semanticLabel,
                  errorBuilder: (ctx, err2, stack2) => _buildPlaceholder(),
                );
              }
              return _buildPlaceholder();
            },
          );
        }
        if (fallbackAsset != null) {
          return FutureBuilder<bool>(
            future: _assetExists(context, fallbackAsset!),
            builder: (context, snap2) {
              final fbExists = snap2.data ?? false;
              if (fbExists) {
                return Image.asset(
                  fallbackAsset!,
                  width: width,
                  height: height,
                  fit: fit,
                  color: color,
                  semanticLabel: semanticLabel,
                  errorBuilder: (ctx, err2, stack2) => _buildPlaceholder(),
                );
              }
              return _buildPlaceholder();
            },
          );
        }
        return _buildPlaceholder();
      },
    );
  }

  Future<bool> _assetExists(BuildContext context, String path) async {
    try {
      final manifestJson = await DefaultAssetBundle.of(
        context,
      ).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap =
          json.decode(manifestJson) as Map<String, dynamic>;
      return manifestMap.containsKey(path);
    } catch (_) {
      return false;
    }
  }

  Widget _buildPlaceholder() {
    // Um ícone simples, alinhado e com tamanho baseado nas dimensões passadas
    final iconSize = (width ?? height ?? 40) * 0.6;
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: iconSize.clamp(12, 120),
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
