import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../services/app_state.dart';
import '../services/theme_service.dart';
import '../widgets/design_system.dart';
import '../widgets/smart_ad_banner_widget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  String _iconeSelecionado = '💰';
  Color _corSelecionada = Colors.blue;

  final List<String> _icones = [
    '💰',
    '🍔',
    '🚗',
    '⚕️',
    '🎮',
    '📚',
    '🏠',
    '💡',
    '👔',
    '📱',
    '🎁',
    '✈️',
    '🎵',
    '🏋️',
    '🛍️',
    '☕',
    '🎨',
    '🐕',
    '🌿',
    '📊',
    '🔧',
    '💊',
    '🎯',
    '🎪',
  ];

  final List<Color> _cores = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.brown,
    Colors.grey,
    Colors.cyan,
    Colors.lime,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.yellow,
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _mostrarDialogCategoria({Categoria? categoria}) {
    if (categoria != null) {
      _nomeController.text = categoria.nome;
      _iconeSelecionado = categoria.icone;
      _corSelecionada = Color(categoria.cor);
    } else {
      _nomeController.clear();
      _iconeSelecionado = '💰';
      _corSelecionada = Colors.blue;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            categoria == null ? 'Nova Categoria' : 'Editar Categoria',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Categoria',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite um nome para a categoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selecione um Ícone:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: AppSpacing.smPadding,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      itemCount: _icones.length,
                      itemBuilder: (context, index) {
                        final icone = _icones[index];
                        final isSelected = icone == _iconeSelecionado;
                        return InkWell(
                          onTap: () =>
                              setDialogState(() => _iconeSelecionado = icone),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        _corSelecionada.withValues(alpha: 0.3),
                                        _corSelecionada.withValues(alpha: 0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: Border.all(
                                color: isSelected
                                    ? _corSelecionada
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                icone,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selecione uma Cor:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: AppSpacing.smPadding,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _cores.length,
                      itemBuilder: (context, index) {
                        final cor = _cores[index];
                        final isSelected =
                            cor.toARGB32() == _corSelecionada.toARGB32();
                        return InkWell(
                          onTap: () =>
                              setDialogState(() => _corSelecionada = cor),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: cor.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final appState = Provider.of<AppState>(
                    context,
                    listen: false,
                  );
                  if (categoria == null) {
                    final novaCategoria = Categoria.fromPortuguese(
                      nome: _nomeController.text.trim(),
                      icone: _iconeSelecionado,
                      cor: _corSelecionada.toARGB32(),
                    );
                    appState.adicionarCategoria(novaCategoria);
                  } else {
                    final categoriaAtualizada = categoria.copyWith(
                      name: _nomeController.text.trim(),
                      icon: _iconeSelecionado,
                      color: _corSelecionada,
                    );
                    appState.atualizarCategoria(categoriaAtualizada);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        categoria == null
                            ? 'Categoria criada!'
                            : 'Categoria atualizada!',
                      ),
                    ),
                  );
                }
              },
              child: Text(categoria == null ? 'Criar' : 'Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarExclusao(Categoria categoria) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja excluir \"\"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AppState>(
                context,
                listen: false,
              ).removerCategoria(categoria.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Categoria excluída')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, ThemeService>(
      builder: (context, appState, themeService, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Categorias'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.8),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: appState.categorias.isEmpty
                    ? _buildEmptyState(isDark)
                    : _buildCategoriesList(appState.categorias, isDark),
              ),
              const SmartAdBannerWidget(debugLabel: 'categories'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _mostrarDialogCategoria(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: isDark ? Colors.white54 : Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'Nenhuma categoria criada',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crie sua primeira categoria para organizar suas transações',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _mostrarDialogCategoria(),
            icon: const Icon(Icons.add),
            label: const Text('Criar Categoria'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(List<Categoria> categorias, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(categoria.cor).withValues(alpha: 0.3),
                    Color(categoria.cor).withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(categoria.cor).withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  categoria.icone,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            title: Text(categoria.nome),
            subtitle: Text(categoria.ativa ? 'Ativa' : 'Inativa'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'editar':
                    _mostrarDialogCategoria(categoria: categoria);
                    break;
                  case 'excluir':
                    _confirmarExclusao(categoria);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'editar', child: Text('Editar')),
                const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
              ],
            ),
          ),
        );
      },
    );
  }
}
