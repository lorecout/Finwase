import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../services/firebase_service.dart';

class BackupService extends ChangeNotifier {
  bool _isBackupEnabled = false;
  DateTime? _lastBackupDate;
  bool _isBackingUp = false;
  double _backupProgress = 0.0;

  bool get isBackupEnabled => _isBackupEnabled;
  DateTime? get lastBackupDate => _lastBackupDate;
  bool get isBackingUp => _isBackingUp;
  double get backupProgress => _backupProgress;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();

  // Ativar/desativar backup
  Future<void> toggleBackup(bool enabled) async {
    _isBackupEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('backup_enabled', enabled);
    notifyListeners();

    if (enabled) {
      await performBackup();
    }
  }

  // Executar backup
  Future<void> performBackup() async {
    if (!_isBackupEnabled || _firebaseService.userId == null) return;

    _isBackingUp = true;
    _backupProgress = 0.0;
    notifyListeners();

    try {
      // Obter dados do usuário
      final userData = await _firebaseService.getUserData();
      final transactions = await _firebaseService.getTransactions();
      final categories = await _firebaseService.getCategories();

      _backupProgress = 0.2;
      notifyListeners();

      // Criar dados de backup
      final backupData = {
        'userData': userData,
        'transactions': transactions
            .map(
              (t) => {
                'id': t.id,
                'title': t.title,
                'amount': t.amount,
                'type': t.type.name,
                'categoryId': t.categoryId,
                'date': t.date.toIso8601String(),
                'description': t.description,
                'isRecurring': t.isRecurring,
                'recurringType': t.recurringType?.name,
              },
            )
            .toList(),
        'categories': categories
            .map(
              (c) => {
                'id': c.id,
                'name': c.name,
                'icon': c.icon,
                'color': c.color.toARGB32(),
                'type': c.type.name,
                'isDefault': c.isDefault,
              },
            )
            .toList(),
        'backupDate': DateTime.now().toIso8601String(),
        'version': '1.0.0',
      };

      _backupProgress = 0.5;
      notifyListeners();

      // Converter para JSON
      final jsonData = jsonEncode(backupData);
      final bytes = utf8.encode(jsonData);

      // Criar arquivo temporário
      final tempDir = await getTemporaryDirectory();
      final backupFile = File(
        '${tempDir.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await backupFile.writeAsBytes(bytes);

      _backupProgress = 0.7;
      notifyListeners();

      // Upload para Firebase Storage
      final userId = _firebaseService.userId;
      if (userId == null) {
        throw Exception(
            'Usuário não autenticado. Backup não permitido no modo visitante.');
      }
      final fileName = 'backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final storageRef = _storage.ref().child('backups/$userId/$fileName');

      await storageRef.putFile(backupFile);

      // Obter URL de download
      final downloadUrl = await storageRef.getDownloadURL();

      _backupProgress = 0.9;
      notifyListeners();

      // Salvar metadados do backup no Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('backups')
          .add({
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'backupDate': FieldValue.serverTimestamp(),
        'size': bytes.length,
        'version': '1.0.0',
      });

      // Limpar arquivo temporário
      await backupFile.delete();

      // Atualizar data do último backup
      _lastBackupDate = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_backup', _lastBackupDate!.toIso8601String());

      _backupProgress = 1.0;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro no backup: $e');
      rethrow;
    } finally {
      _isBackingUp = false;
      _backupProgress = 0.0;
      notifyListeners();
    }
  }

  // Restaurar backup
  Future<void> restoreBackup() async {
    if (_firebaseService.userId == null) return;

    _isBackingUp = true;
    _backupProgress = 0.0;
    notifyListeners();

    try {
      final userId = _firebaseService.userId;
      if (userId == null) {
        throw Exception(
            'Usuário não autenticado. Backup não permitido no modo visitante.');
      }

      // Obter lista de backups
      final backupsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('backups')
          .orderBy('backupDate', descending: true)
          .limit(1)
          .get();

      if (backupsSnapshot.docs.isEmpty) {
        throw Exception('Nenhum backup encontrado');
      }

      final latestBackup = backupsSnapshot.docs.first;
      final downloadUrl = latestBackup['downloadUrl'] as String;

      _backupProgress = 0.3;
      notifyListeners();

      // Baixar arquivo de backup
      final tempDir = await getTemporaryDirectory();
      final backupFile = File('${tempDir.path}/restore_backup.json');

      final storageRef = _storage.refFromURL(downloadUrl);
      await storageRef.writeToFile(backupFile);

      _backupProgress = 0.6;
      notifyListeners();

      // Ler dados do backup
      // final jsonData = await backupFile.readAsString();
      // final backupData = jsonDecode(jsonData) as Map<String, dynamic>;

      // Restaurar transações
      // final transactions = (backupData['transactions'] as List).map((t) {
      //   // Aqui seria necessário converter os dados de volta para TransactionModel
      //   // e salvar no Firestore através do FirebaseService
      //   return t;
      // }).toList();

      // Restaurar categorias
      // final categories = (backupData['categories'] as List).map((c) {
      //   // Aqui seria necessário converter os dados de volta para Category
      //   // e salvar no Firestore através do FirebaseService
      //   return c;
      // }).toList();

      _backupProgress = 0.9;
      notifyListeners();

      // Limpar arquivo temporário
      await backupFile.delete();

      _backupProgress = 1.0;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro na restauração: $e');
      rethrow;
    } finally {
      _isBackingUp = false;
      _backupProgress = 0.0;
      notifyListeners();
    }
  }

  // Carregar configurações salvas
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isBackupEnabled = prefs.getBool('backup_enabled') ?? false;
    final lastBackupString = prefs.getString('last_backup');
    if (lastBackupString != null) {
      _lastBackupDate = DateTime.parse(lastBackupString);
    }
    notifyListeners();
  }

  // Verificar se precisa de backup (a cada 24 horas)
  bool get needsBackup {
    if (!_isBackupEnabled || _lastBackupDate == null) return true;
    final hoursSinceLastBackup =
        DateTime.now().difference(_lastBackupDate!).inHours;
    return hoursSinceLastBackup >= 24;
  }
}
