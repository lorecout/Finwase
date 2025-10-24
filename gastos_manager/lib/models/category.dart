import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Tipos de categoria
enum CategoryType { income, expense }

/// Modelo unificado de categoria
/// Consolidação de CategoryModel e Categoria
class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final CategoryType type;
  final bool isDefault;
  final bool isActive; // Campo adicionado de Categoria (ativa)

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.isDefault = false,
    this.isActive = true,
  });

  /// Construtor para criar nova categoria com ID gerado automaticamente
  factory CategoryModel.create({
    required String name,
    required String icon,
    required Color color,
    required CategoryType type,
    bool isDefault = false,
    bool isActive = true,
  }) {
    return CategoryModel(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      color: color,
      type: type,
      isDefault: isDefault,
      isActive: isActive,
    );
  }

  /// Construtor para backward compatibility com nomes em português
  factory CategoryModel.fromPortuguese({
    String? id,
    required String nome,
    required String icone,
    required int cor,
    CategoryType? tipo,
    bool isDefault = false,
    bool ativa = true,
  }) {
    return CategoryModel(
      id: id ?? const Uuid().v4(),
      name: nome,
      icon: icone,
      color: Color(cor),
      type: tipo ?? CategoryType.expense, // default expense se não especificado
      isDefault: isDefault,
      isActive: ativa,
    );
  }

  /// Compatibilidade: getters no estilo do modelo antigo (Categoria)
  String get nome => name;
  String get icone => icon;
  int get cor => color.toARGB32();
  bool get ativa => isActive;
  Color get colorValue => color;

  // Criar cópia com modificações
  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    Color? color,
    CategoryType? type,
    bool? isDefault,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
    );
  }

  // Converter para Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.toARGB32(),
      'type': type.name,
      'isDefault': isDefault,
      'isActive': isActive,
      // Compatibilidade com modelo antigo
      'nome': name,
      'icone': icon,
      'cor': color.toARGB32(),
      'ativa': isActive ? 1 : 0,
    };
  }

  // Criar a partir de Map (do Firestore)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    // Suporte para ambos os formatos (inglês e português)
    final name = map['name'] ?? map['nome'] ?? '';
    final icon = map['icon'] ?? map['icone'] ?? '📁';
    final colorValue = map['color'] ?? map['cor'] ?? 0xFF2196F3;

    // Determinar isActive (suporta ambos os formatos)
    final isActive = map['isActive'] ?? (map['ativa'] == 1) ?? true;

    return CategoryModel(
      id: map['id'] ?? '',
      name: name,
      icon: icon,
      color: Color(colorValue),
      type: CategoryType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CategoryType.expense,
      ),
      isDefault: map['isDefault'] ?? false,
      isActive: isActive,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, icon: $icon, color: $color, type: $type, isDefault: $isDefault, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.color == color &&
        other.type == type &&
        other.isDefault == isDefault &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        icon.hashCode ^
        color.hashCode ^
        type.hashCode ^
        isDefault.hashCode ^
        isActive.hashCode;
  }
}

// Alias para compatibilidade com código legado
typedef Categoria = CategoryModel;
