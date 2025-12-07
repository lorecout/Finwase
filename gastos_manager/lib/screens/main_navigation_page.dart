import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ad_service.dart';
import '../services/ad_revenue_optimizer.dart';
import '../services/theme_service.dart';
import 'dashboard_page_clean.dart';
import 'transactions_page.dart';
import 'reports_page.dart';
import 'recurring_transactions_page.dart';
import 'budgets_page.dart';
import 'settings_page.dart';

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
          floatingActionButton: (_selectedIndex == 1 || _selectedIndex == 5)
              ? null
              : GestureDetector(
                  onLongPress: () async {
                    await _triggerInterstitialTest();
                  },
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add-transaction');
                    },
                    backgroundColor: themeService.accentColor,
                    heroTag: "main_add_fab",
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Future<void> _triggerInterstitialTest() async {
    if (!mounted) return;
    if (!AdService.isInitialized) {
      await AdService.initialize();
    }
    final ad = await AdRevenueOptimizer().createOptimizedInterstitial(
      onAdLoaded: (ad) {},
      onAdFailedToLoad: (error) {},
    );
    ad?.show();
  }
}
