import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import 'dashboard_page_clean.dart';
import 'transactions_page.dart';
import 'reports_page.dart';
import 'recurring_transactions_page.dart';
import 'budgets_page.dart';
import 'settings_page.dart';
import '../main.dart';
import '../widgets/premium_wrapper.dart';

class MainNavigationPage extends StatefulWidget {
  final int? initialIndex;

  const MainNavigationPage({super.key, this.initialIndex});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const DashboardPageClean(),
    const TransactionsPage(),
    const ReportsPage(),
    const RecurringTransactionsPage(),
    const BudgetsPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // PremiumWrapper: sempre liberar recursos premium para usuários com anúncios
    return PremiumWrapper(
      builder: (context, isPremium, showAds) {
        // Forçar isPremium true se showAds for true (libera premium com anúncios)
        final bool effectivePremium = isPremium || showAds;
        return Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return Scaffold(
              body: IndexedStack(index: _selectedIndex, children: _pages),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: themeService.accentColor,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long),
                    label: 'Transações',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: 'Relatórios',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    label: 'Recorrentes',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_wallet),
                    label: 'Orçamentos',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Configurações',
                  ),
                ],
              ),
              // FAB: liberar sempre para premium OU para quem está com anúncios
              floatingActionButton: (_selectedIndex == 1 || _selectedIndex == 5)
                  ? null
                  : (effectivePremium
                      ? FloatingActionButton(
                          onPressed: () {
                            appNavigatorKey.currentState?.pushNamed(
                              '/add-transaction',
                            );
                          },
                          backgroundColor: themeService.accentColor,
                          heroTag: "main_add_fab",
                          child: const Icon(Icons.add, color: Colors.white),
                        )
                      : null),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            );
          },
        );
      },
    );
  }
}
