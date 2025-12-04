import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'core/theme/app_theme.dart';
import 'domain/idle/idle_engine.dart';
import 'domain/models/staff_member.dart';
import 'domain/models/station.dart';
import 'data/isar_db.dart';
import 'data/game_repository.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final db = await IsarDb.open();
  return db.isar;
});

final gameRepositoryProvider = FutureProvider<GameRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final repo = GameRepository(isar);
  await repo.seedIfNeeded();
  return repo;
});

final currencyProvider = StateProvider<double>((ref) => 0);
final stationsProvider = StateProvider<List<StationEntity>>((ref) => []);

final idleEngineProvider = Provider<IdleEngine?>((ref) {
  final repoAsync = ref.watch(gameRepositoryProvider);
  if (repoAsync.isLoading || repoAsync.hasError) return null;
  final repo = repoAsync.value!;
  final stations = ref.read(stationsProvider);
  if (stations.isEmpty) return null; // aguarda carregar
  final notifier = ref.read(currencyProvider.notifier);
  final staff = [
    StaffMember(id: 'chef_inicial', role: StaffRole.chef, productionBuff: 0.10),
  ];
  final engine = IdleEngine(
    stations: stations,
    staff: staff,
    onCurrencyGenerated: (value) async {
      notifier.state += value;
      if (notifier.state % 50 == 0) {
        await repo.saveCurrency(notifier.state);
      }
    },
  );
  engine.start();
  return engine;
});

Future<void> _bootstrapInitialData(WidgetRef ref) async {
  final repo = await ref.read(gameRepositoryProvider.future);
  final stations = await repo.getStations();
  final meta = await repo.getMeta();
  ref.read(stationsProvider.notifier).state = stations;
  ref.read(currencyProvider.notifier).state = meta.currency;
}

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const IdleHomeScreen(),
    );
  }
}

class IdleHomeScreen extends ConsumerStatefulWidget {
  const IdleHomeScreen({super.key});

  @override
  ConsumerState<IdleHomeScreen> createState() => _IdleHomeScreenState();
}

class _IdleHomeScreenState extends ConsumerState<IdleHomeScreen> {
  bool _bootstrapped = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_bootstrapped) {
      _bootstrapped = true;
      _init();
    }
  }

  Future<void> _init() async {
    await _bootstrapInitialData(ref);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final repoAsync = ref.watch(gameRepositoryProvider);
    final stations = ref.watch(stationsProvider);
    final currency = ref.watch(currencyProvider);
    if (repoAsync.isLoading || stations.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurante Fofo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Moedas: ${currency.toStringAsFixed(0)}', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: stations.length,
                itemBuilder: (context, i) {
                  final s = stations[i];
                  return _StationCard(id: s.key, rate: s.productionPerSec());
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(currencyProvider.notifier).state += 5;
              },
              child: const Text('Bônus Manual +5'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  final String id;
  final double rate;
  const _StationCard({required this.id, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text('Taxa: ${rate.toStringAsFixed(2)}/s'),
              ],
            ),
            const Icon(Icons.local_dining, color: Colors.pinkAccent),
          ],
        ),
      ),
    );
  }
}
