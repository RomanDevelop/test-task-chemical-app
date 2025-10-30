import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calculation_record.dart';
import '../models/lsi_parameters.dart';
import '../models/lsi_result.dart';
import '../data/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

class HistoryNotifier extends StateNotifier<List<CalculationRecord>> {
  final HistoryRepository _repo;
  HistoryNotifier(this._repo) : super(const []) {
    _init();
  }

  Future<void> _init() async {
    await _repo.init();
    final all = await _repo.loadAll();
    if (all.isEmpty) {
      // seed mock once for UX
      for (final r in _mockRecords()) {
        await _repo.insert(r);
      }
      state = await _repo.loadAll();
    } else {
      state = all;
    }
  }

  Future<void> addRecord(CalculationRecord record) async {
    await _repo.insert(record);
    state = [record, ...state];
  }

  Future<void> clear() async {
    await _repo.clear();
    state = const [];
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, List<CalculationRecord>>((ref) {
  final repo = ref.read(historyRepositoryProvider);
  return HistoryNotifier(repo);
});

List<CalculationRecord> _mockRecords() {
  final p1 = LSIParameters(
    waterTemperatureCurrentF: 80,
    pHCurrent: 7.6,
    totalAlkalinityCurrent: 80,
    calciumCurrent: 300,
    cyaCurrent: 35,
    saltCurrent: 400,
    boratesCurrent: 0,
    waterTemperatureDesiredF: 77,
    pHDesired: 7.8,
    totalAlkalinityDesired: 90,
    calciumDesired: 350,
    cyaDesired: 30,
    saltDesired: 800,
    boratesDesired: 0,
  );
  final r1 = LSIResult(current: 0.12, desired: 0.05);

  final p2 = LSIParameters(
    waterTemperatureCurrentF: 72,
    pHCurrent: 7.2,
    totalAlkalinityCurrent: 100,
    calciumCurrent: 250,
    cyaCurrent: 20,
    saltCurrent: 600,
    boratesCurrent: 20,
    waterTemperatureDesiredF: 78,
    pHDesired: 7.5,
    totalAlkalinityDesired: 90,
    calciumDesired: 300,
    cyaDesired: 30,
    saltDesired: 800,
    boratesDesired: 20,
  );
  final r2 = LSIResult(current: -0.18, desired: -0.05);

  return [
    CalculationRecord(
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      parameters: p1,
      result: r1,
    ),
    CalculationRecord(
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      parameters: p2,
      result: r2,
    ),
  ];
}
