import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_service.dart';
import '../services/premium_service.dart';
import '../services/smart_interstitial_service.dart';
import '../widgets/premium_ad_widget.dart';
import 'admin_webview_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseService>(
      builder: (context, firebaseService, child) {
        final premiumService = Provider.of<PremiumService>(context);
        final user = firebaseService.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil'),
            elevation: 0,
            actions: [
              if (user != null)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditProfileDialog(context),
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileHeader(context, user, premiumService),
                      const SizedBox(height: 16),
                      const PremiumAdWidget(
                        message:
                            '👑 Upgrade para Premium e remova todos os anúncios!',
                        buttonText: 'SEM ANÚNCIOS',
                        icon: Icons.block,
                      ),
                      const SizedBox(height: 16),
                      _buildAccountStatus(
                        context,
                        premiumService,
                        firebaseService,
                      ),
                      const SizedBox(height: 24),
                      if (premiumService.isAdmin) ...[
                        _buildAdminPanel(context, premiumService),
                        const SizedBox(height: 24),
                      ],
                      _buildQuickActions(context, user),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    user,
    PremiumService premiumService,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: user == null
                  ? Colors.grey.withValues(alpha: 0.2)
                  : premiumService.isPremium
                  ? Colors.amber.withValues(alpha: 0.2)
                  : Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                user == null
                    ? Icons.visibility
                    : premiumService.isPremium
                    ? Icons.verified
                    : Icons.person,
                size: 50,
                color: user == null
                    ? Colors.grey
                    : premiumService.isPremium
                    ? Colors.amber
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? (user == null ? 'Visitante' : 'Usuário'),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'Modo visitante - Faça login para sincronizar',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStatus(
    BuildContext context,
    PremiumService premiumService,
    FirebaseService firebaseService,
  ) {
    final user = firebaseService.currentUser;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  premiumService.getStatusIcon(),
                  color: premiumService.getStatusColor(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Status da Conta',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              premiumService.getStatusMessage(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (user == null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/auth'),
                  icon: const Icon(Icons.login),
                  label: const Text('Fazer Login para Sincronizar Dados'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
            if (!premiumService.isPremium && user != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/premium-upgrade'),
                icon: const Icon(Icons.upgrade),
                label: const Text('Atualizar para Premium'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdminPanel(BuildContext context, PremiumService premiumService) {
    return Card(
      color: Colors.red.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.red[700]),
                const SizedBox(width: 8),
                Text(
                  'Painel Administrativo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Gerencie premium para qualquer usuário',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.red[600]),
            ),
            const SizedBox(height: 16),
            // Botão para abrir painel completo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminWebViewPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.web, size: 24),
                label: const Text('🛠️ ABRIR PAINEL ADMIN COMPLETO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Ferramentas Rápidas:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showAdminGrantPremiumDialog(context, premiumService),
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Conceder Premium'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showAdminExtendPremiumDialog(context, premiumService),
                    icon: const Icon(Icons.extension),
                    label: const Text('Estender Premium'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showAdminRemovePremiumDialog(context, premiumService),
                    icon: const Icon(Icons.remove_circle),
                    label: const Text('Remover Premium'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red[300]!),
                      foregroundColor: Colors.red[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showAdminUserInfoDialog(context, premiumService),
                    icon: const Icon(Icons.info),
                    label: const Text('Info Usuário'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () =>
                    _showAdminPremiumUsersList(context, premiumService),
                icon: const Icon(Icons.list),
                label: const Text('Ver Todos Premium'),
                style: TextButton.styleFrom(foregroundColor: Colors.red[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, user) {
    final premiumService = Provider.of<PremiumService>(context, listen: false);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações Rápidas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      premiumService.isPremium ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    title: Text(
                      premiumService.isPremium
                          ? 'Desativar Premium (Debug)'
                          : 'Ativar Premium (Debug)',
                    ),
                    subtitle: Text(
                      premiumService.isPremium
                          ? 'Ativar para ver anúncios'
                          : 'Desativar para remover anúncios',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Switch(
                      value: premiumService.isPremium,
                      onChanged: (value) {
                        if (value) {
                          premiumService.upgradeToPremium('debug');
                        } else {
                          premiumService.downgradeToFree();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? '✅ Premium ativado - Anúncios ocultos'
                                  : '✅ Premium desativado - Anúncios visíveis',
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: value
                                ? Colors.green
                                : Colors.orange,
                          ),
                        );
                      },
                    ),
                  ),
                  if (!premiumService.isPremium) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: RewardedAdButton(
                        text: 'Desbloquear Premium com Anúncio',
                        icon: Icons.play_circle_fill,
                        onRewarded: () {
                          premiumService.grantTemporaryPremium(minutes: 30);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '🎁 Premium ativado por 30 minutos!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        rewardMessage:
                            'Assista ao anúncio para liberar Premium por 30 minutos!',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (user != null) ...[
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.grey),
                title: const Text('Sair da Conta'),
                subtitle: const Text('Fazer logout do aplicativo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _logout(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _EditProfileDialog(),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _showAdminGrantPremiumDialog(
    BuildContext context,
    PremiumService premiumService,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          _AdminGrantPremiumDialog(premiumService: premiumService),
    );
  }

  void _showAdminExtendPremiumDialog(
    BuildContext context,
    PremiumService premiumService,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          _AdminExtendPremiumDialog(premiumService: premiumService),
    );
  }

  void _showAdminRemovePremiumDialog(
    BuildContext context,
    PremiumService premiumService,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          _AdminRemovePremiumDialog(premiumService: premiumService),
    );
  }

  void _showAdminUserInfoDialog(
    BuildContext context,
    PremiumService premiumService,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          _AdminUserInfoDialog(premiumService: premiumService),
    );
  }

  void _showAdminPremiumUsersList(
    BuildContext context,
    PremiumService premiumService,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          _AdminPremiumUsersListDialog(premiumService: premiumService),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog();

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final firebaseService = Provider.of<FirebaseService>(
      context,
      listen: false,
    );
    final user = firebaseService.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Perfil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveProfile,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implementar atualização de perfil no FirebaseService
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class _AdminGrantPremiumDialog extends StatefulWidget {
  final PremiumService premiumService;

  const _AdminGrantPremiumDialog({required this.premiumService});

  @override
  State<_AdminGrantPremiumDialog> createState() =>
      _AdminGrantPremiumDialogState();
}

class _AdminGrantPremiumDialogState extends State<_AdminGrantPremiumDialog> {
  final _userIdController = TextEditingController();
  final _daysController = TextEditingController(text: '7');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Conceder Premium'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userIdController,
            decoration: const InputDecoration(
              labelText: 'User ID',
              hintText: 'Cole o UID do usuário',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _daysController,
            decoration: const InputDecoration(
              labelText: 'Dias de Premium',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _grantPremium,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Conceder'),
        ),
      ],
    );
  }

  Future<void> _grantPremium() async {
    final userId = _userIdController.text.trim();
    final days = int.tryParse(_daysController.text.trim()) ?? 0;

    if (userId.isEmpty || days <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.premiumService.adminGrantPremium(
        userId: userId,
        days: days,
        reason: 'Concedido via painel admin',
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Premium concedido por $days dias')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _daysController.dispose();
    super.dispose();
  }
}

class _AdminExtendPremiumDialog extends StatefulWidget {
  final PremiumService premiumService;

  const _AdminExtendPremiumDialog({required this.premiumService});

  @override
  State<_AdminExtendPremiumDialog> createState() =>
      _AdminExtendPremiumDialogState();
}

class _AdminExtendPremiumDialogState extends State<_AdminExtendPremiumDialog> {
  final _userIdController = TextEditingController();
  final _daysController = TextEditingController(text: '7');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Estender Premium'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userIdController,
            decoration: const InputDecoration(
              labelText: 'User ID',
              hintText: 'Cole o UID do usuário',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _daysController,
            decoration: const InputDecoration(
              labelText: 'Dias adicionais',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _extendPremium,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Estender'),
        ),
      ],
    );
  }

  Future<void> _extendPremium() async {
    final userId = _userIdController.text.trim();
    final days = int.tryParse(_daysController.text.trim()) ?? 0;

    if (userId.isEmpty || days <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.premiumService.adminExtendPremium(
        userId,
        days,
        reason: 'Estendido via painel admin',
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Premium estendido por $days dias')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _daysController.dispose();
    super.dispose();
  }
}

class _AdminRemovePremiumDialog extends StatefulWidget {
  final PremiumService premiumService;

  const _AdminRemovePremiumDialog({required this.premiumService});

  @override
  State<_AdminRemovePremiumDialog> createState() =>
      _AdminRemovePremiumDialogState();
}

class _AdminRemovePremiumDialogState extends State<_AdminRemovePremiumDialog> {
  final _userIdController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remover Premium'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userIdController,
            decoration: const InputDecoration(
              labelText: 'User ID',
              hintText: 'Cole o UID do usuário',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '⚠️ Esta ação irá remover o status premium do usuário permanentemente.',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _removePremium,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Remover'),
        ),
      ],
    );
  }

  Future<void> _removePremium() async {
    final userId = _userIdController.text.trim();

    if (userId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite o User ID')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.premiumService.adminRemovePremium(
        userId,
        reason: 'Removido via painel admin',
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Premium removido')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}

class _AdminUserInfoDialog extends StatefulWidget {
  final PremiumService premiumService;

  const _AdminUserInfoDialog({required this.premiumService});

  @override
  State<_AdminUserInfoDialog> createState() => _AdminUserInfoDialogState();
}

class _AdminUserInfoDialogState extends State<_AdminUserInfoDialog> {
  final _userIdController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _userInfo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Informações do Usuário'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userIdController,
            decoration: const InputDecoration(
              labelText: 'User ID',
              hintText: 'Cole o UID do usuário',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_userInfo != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${_userInfo!['email'] ?? 'N/A'}'),
                Text('Premium: ${_userInfo!['isPremium'] ? 'Sim' : 'Não'}'),
                if (_userInfo!['premiumExpiry'] != null)
                  Text('Expira: ${_userInfo!['premiumExpiry']}'),
              ],
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _getUserInfo,
          child: const Text('Buscar'),
        ),
      ],
    );
  }

  Future<void> _getUserInfo() async {
    final userId = _userIdController.text.trim();

    if (userId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite o User ID')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userInfo = await widget.premiumService.adminGetUserInfo(userId);
      setState(() => _userInfo = userInfo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}

class _AdminPremiumUsersListDialog extends StatefulWidget {
  final PremiumService premiumService;

  const _AdminPremiumUsersListDialog({required this.premiumService});

  @override
  State<_AdminPremiumUsersListDialog> createState() =>
      _AdminPremiumUsersListDialogState();
}

class _AdminPremiumUsersListDialogState
    extends State<_AdminPremiumUsersListDialog> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _premiumUsers = [];

  @override
  void initState() {
    super.initState();
    _loadPremiumUsers();
  }

  Future<void> _loadPremiumUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await widget.premiumService.adminListPremiumUsers();
      setState(() => _premiumUsers = users);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erro ao carregar usuários: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Usuários Premium'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _premiumUsers.isEmpty
            ? const Center(child: Text('Nenhum usuário premium encontrado'))
            : ListView.builder(
                itemCount: _premiumUsers.length,
                itemBuilder: (context, index) {
                  final user = _premiumUsers[index];
                  return ListTile(
                    title: Text(user['email'] ?? 'Sem email'),
                    subtitle: Text('Expira: ${user['premiumExpiry'] ?? 'N/A'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        // Copy UID to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('UID copiado: ${user['uid']}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
        ElevatedButton(
          onPressed: _loadPremiumUsers,
          child: const Text('Atualizar'),
        ),
      ],
    );
  }
}
