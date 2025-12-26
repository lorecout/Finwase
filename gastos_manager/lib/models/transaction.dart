import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

/// Tipos de transação (padrão)
enum TransactionType { income, expense }

/// Tipos de transação (compatibilidade com modelo antigo em português)
enum TipoTransacao { receita, despesa }

/// Tipos de recorrência
enum RecurringType { daily, weekly, monthly, yearly }

/// Modelo unificado de transação
/// Consolidação de TransactionModel e Transacao
class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String description;
  final bool isRecurring;
  final RecurringType? recurringType;
  final int?
  frequencyDays; // Compatibilidade: dias de frequência (30 = mensal, etc.)

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.description = '',
    this.isRecurring = false,
    this.recurringType,
    this.frequencyDays,
  });

  /// Construtor para criar nova transação com ID gerado automaticamente
  factory TransactionModel.create({
    required String title,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String description = '',
    bool isRecurring = false,
    RecurringType? recurringType,
    int? frequencyDays,
  }) {
    return TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      description: description,
      isRecurring: isRecurring,
      recurringType: recurringType,
      frequencyDays: frequencyDays,
    );
  }

  /// Construtor para backward compatibility com nomes em português
  factory TransactionModel.fromPortuguese({
    String? id,
    required String descricao,
    required double valor,
    required TipoTransacao tipo,
    required String categoriaId,
    required DateTime data,
    String? observacoes,
    bool recorrente = false,
    int? frequenciaDias,
  }) {
    return TransactionModel(
      id: id ?? const Uuid().v4(),
      title: descricao,
      amount: valor,
      type: tipo == TipoTransacao.receita
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: categoriaId,
      date: data,
      description: observacoes ?? '',
      isRecurring: recorrente,
      frequencyDays: frequenciaDias,
    );
  }

  /// Compatibilidade: getters no estilo do modelo antigo (Transacao)
  String get descricao => title;
  double get valor => amount;
  TipoTransacao get tipo => type == TransactionType.income
      ? TipoTransacao.receita
      : TipoTransacao.despesa;
  String get categoriaId => categoryId;
  DateTime get data => date;
  String? get observacoes => description.isEmpty ? null : description;
  bool get recorrente => isRecurring;
  int? get frequenciaDias => frequencyDays;

  // Criar cópia com modificações
  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? categoryId,
    DateTime? date,
    String? description,
    bool? isRecurring,
    RecurringType? recurringType,
    int? frequencyDays,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      description: description ?? this.description,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      frequencyDays: frequencyDays ?? this.frequencyDays,
    );
  }

  // Converter para Map (para Firestore e banco local)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'description': description,
      'isRecurring': isRecurring,
      'recurringType': recurringType?.name,
      'frequencyDays': frequencyDays,
      // Compatibilidade com modelo antigo
      'descricao': title,
      'valor': amount,
      'tipo': type == TransactionType.income ? 0 : 1, // TipoTransacao.index
      'categoria_id': categoryId,
      'data': date.toIso8601String(),
      'observacoes': description,
      'recorrente': isRecurring ? 1 : 0,
      'frequencia_dias': frequencyDays,
    };
  }

  // Criar a partir de Map (do Firestore ou banco local)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    // Suporte para ambos os formatos (inglês e português)
    final title = map['title'] ?? map['descricao'] ?? '';
    final amount = (map['amount'] ?? map['valor'] ?? 0.0).toDouble();
    final categoryId = map['categoryId'] ?? map['categoria_id'] ?? '';
    final description = map['description'] ?? map['observacoes'] ?? '';

    // Lidar com data - pode ser String (ISO), Timestamp (Firestore) ou DateTime
    final dateValue = map['date'] ?? map['data'];
    DateTime date;
    if (dateValue is DateTime) {
      date = dateValue;
    } else if (dateValue != null) {
      try {
        // Verificar se é um Timestamp do Firestore pela existência do método toDate
        if (dateValue.runtimeType.toString().contains('Timestamp')) {
          // É um Timestamp do Firestore
          date = dateValue.toDate() as DateTime;
        } else {
          // Tentar parse como string ISO
          date = DateTime.parse(dateValue.toString());
        }
      } catch (e) {
        // Fallback para data atual se não conseguir converter
        debugPrint(
          '⚠️ TRANSACTION_MODEL: Erro ao converter data: $e, usando data atual',
        );
        date = DateTime.now();
      }
    } else {
      date = DateTime.now();
    }

    // Determinar tipo (suporta ambos os formatos)
    TransactionType type;
    if (map['type'] != null) {
      type = TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      );
    } else if (map['tipo'] != null) {
      type = map['tipo'] == 0
          ? TransactionType.income
          : TransactionType.expense;
    } else {
      type = TransactionType.expense;
    }

    // Determinar isRecurring
    final isRecurring = map['isRecurring'] ?? (map['recorrente'] == 1) ?? false;

    // Determinar frequencyDays
    final frequencyDays = map['frequencyDays'] ?? map['frequencia_dias'];

    return TransactionModel(
      id: map['id'] ?? '',
      title: title,
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      description: description,
      isRecurring: isRecurring,
      recurringType: map['recurringType'] != null
          ? RecurringType.values.firstWhere(
              (e) => e.name == map['recurringType'],
              orElse: () => RecurringType.monthly,
            )
          : null,
      frequencyDays: frequencyDays,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, type: $type, categoryId: $categoryId, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.type == type &&
        other.categoryId == categoryId &&
        other.date == date &&
        other.description == description &&
        other.isRecurring == isRecurring &&
        other.recurringType == recurringType &&
        other.frequencyDays == frequencyDays;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        categoryId.hashCode ^
        date.hashCode ^
        description.hashCode ^
        isRecurring.hashCode ^
        recurringType.hashCode ^
        frequencyDays.hashCode;
  }
}

// Aliases para compatibilidade com código legado
typedef Transacao = TransactionModel;
