import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/icon/novo_icone.png');
  if (!file.existsSync()) {
    debugPrint('Arquivo não encontrado: assets/icon/novo_icone.png');
    return;
  }

  final bytes = file.readAsBytesSync();
  final image = img.decodePng(bytes);
  if (image == null) {
    debugPrint('Erro ao decodificar a imagem.');
    return;
  }

  debugPrint('Dimensões do ícone: ${image.width}x${image.height}');
  if (image.width == 1024 && image.height == 1024) {
    debugPrint('Dimensões corretas!');
  } else {
    debugPrint('Dimensões incorretas. Deve ser 1024x1024.');
  }
}