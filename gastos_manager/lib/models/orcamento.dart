import 'package:uuid/uuid.dart';

/// Modelo para representar um orçamento
class Orcamento {
  final String id;
  final String nome;
  final double valorLimite;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String? categoriaId; // null = orçamento geral
  final bool ativo;
  final bool notificarExcesso;
  final double? porcentagemAlerta; // 0.8 = 80% do limite

  Orcamento({
    String? id,
    required this.nome,
    required this.valorLimite,
    required this.dataInicio,
    required this.dataFim,
    this.categoriaId,
    this.ativo = true,
    this.notificarExcesso = true,
    this.porcentagemAlerta = 0.8,
  }) : id = id ?? const Uuid().v4();

  /// Construtor a partir de Map (para banco de dados)
  factory Orcamento.fromMap(Map<String, dynamic> map) {
    return Orcamento(
      id: map['id'],
      nome: map['nome'],
      valorLimite: map['valor_limite'].toDouble(),
      dataInicio: DateTime.parse(map['data_inicio']),
      dataFim: DateTime.parse(map['data_fim']),
      categoriaId: map['categoria_id'],
      ativo: map['ativo'] == 1,
      notificarExcesso: map['notificar_excesso'] == 1,
      porcentagemAlerta: map['porcentagem_alerta']?.toDouble(),
    );
  }

  /// Converter para Map (para banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'valor_limite': valorLimite,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim.toIso8601String(),
      'categoria_id': categoriaId,
      'ativo': ativo ? 1 : 0,
      'notificar_excesso': notificarExcesso ? 1 : 0,
      'porcentagem_alerta': porcentagemAlerta,
    };
  }

  /// Verificar se o orçamento está ativo no período atual
  bool get estaAtivo {
    final agora = DateTime.now();
    return ativo && 
           agora.isAfter(dataInicio) && 
           agora.isBefore(dataFim.add(const Duration(days: 1)));
  }

  /// Calcular porcentagem usada baseada no valor gasto
  double calcularPorcentagemUsada(double valorGasto) {
    if (valorLimite <= 0) return 0.0;
    return (valorGasto / valorLimite).clamp(0.0, 1.0);
  }

  /// Verificar se deve alertar sobre o gasto
  bool deveAlertar(double valorGasto) {
    if (porcentagemAlerta == null) return false;
    return calcularPorcentagemUsada(valorGasto) >= porcentagemAlerta!;
  }

  /// Verificar se o orçamento foi excedido
  bool foiExcedido(double valorGasto) {
    return valorGasto > valorLimite;
  }

  /// Criar cópia com valores alterados
  Orcamento copyWith({
    String? id,
    String? nome,
    double? valorLimite,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? categoriaId,
    bool? ativo,
    bool? notificarExcesso,
    double? porcentagemAlerta,
  }) {
    return Orcamento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      valorLimite: valorLimite ?? this.valorLimite,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      categoriaId: categoriaId ?? this.categoriaId,
      ativo: ativo ?? this.ativo,
      notificarExcesso: notificarExcesso ?? this.notificarExcesso,
      porcentagemAlerta: porcentagemAlerta ?? this.porcentagemAlerta,
    );
  }

  @override
  String toString() {
    return 'Orcamento(id: $id, nome: $nome, valorLimite: $valorLimite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Orcamento && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
