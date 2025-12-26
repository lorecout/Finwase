import 'dart:io';
import 'package:image/image.dart';

void main(List<String> args) async {
  const srcPath = 'assets/onboarding/welcome.png';
  const dstPath = 'assets/onboarding/welcome_clean.png';

  final srcFile = File(srcPath);
  if (!await srcFile.exists()) {
    stdout.writeln('Arquivo não encontrado: $srcPath');
    return;
  }

  try {
    final bytes = await srcFile.readAsBytes();
    final image = decodeImage(bytes);
    if (image == null) {
      stdout.writeln('Falha ao decodificar a imagem: $srcPath');
      return;
    }

    // Redimensionar para 512x512
    final resized = copyResize(image, width: 512, height: 512, interpolation: Interpolation.average);

    // Garantir fundo branco (sem transparência)
    final background = Image(width: 512, height: 512);
    // Use solid white background (set pixels to white)
    for (var y = 0; y < 512; y++) {
      for (var x = 0; x < 512; x++) {
        background.setPixelRgba(x, y, 255, 255, 255, 255);
      }
    }

    // Center the resized image onto the white background
    final x = ((512 - resized.width) / 2).round();
    final y = ((512 - resized.height) / 2).round();
    compositeImage(background, resized, dstX: x, dstY: y);

    // Encode and write
    final outBytes = encodePng(background, level: 6);
    final outFile = File(dstPath);
    await outFile.writeAsBytes(outBytes);

    // Replace the original file (backup original)
    const backupPath = 'assets/onboarding/welcome_backup.png';
    await srcFile.rename(backupPath);
    await outFile.rename(srcPath);

    stdout.writeln('Imagem reprocessada com sucesso: $srcPath (backup: $backupPath)');
  } catch (e, st) {
    stderr.writeln('Erro ao processar a imagem: $e');
    stderr.writeln(st);
  }
}
