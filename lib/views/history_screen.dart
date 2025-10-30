import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/history_viewmodel.dart';
import '../models/calculation_record.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(historyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('История расчетов')),
      body:
          items.isEmpty
              ? const Center(child: Text('Пока нет расчетов'))
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, i) => _HistoryTile(record: items[i]),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: items.length,
              ),
      floatingActionButton:
          items.isEmpty
              ? null
              : FloatingActionButton.extended(
                onPressed: () => ref.read(historyProvider.notifier).clear(),
                label: const Text('Очистить'),
                icon: const Icon(Icons.delete_outline),
              ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final CalculationRecord record;
  const _HistoryTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text('${record.result.current.toStringAsFixed(2)} → ${record.result.desired.toStringAsFixed(2)}'),
      subtitle: Text(_formatDate(record.createdAt)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder:
              (_) => SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Параметры', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        _row('Temp current', record.parameters.waterTemperatureCurrentF.toStringAsFixed(1)),
                        _row('pH current', record.parameters.pHCurrent.toStringAsFixed(2)),
                        _row('Alk current', record.parameters.totalAlkalinityCurrent.toStringAsFixed(0)),
                        _row('Ca current', record.parameters.calciumCurrent.toStringAsFixed(0)),
                        _row('CYA current', record.parameters.cyaCurrent.toStringAsFixed(0)),
                        _row('Salt current', record.parameters.saltCurrent.toStringAsFixed(0)),
                        _row('Borates current', record.parameters.boratesCurrent.toStringAsFixed(0)),
                        const SizedBox(height: 12),
                        _row('Temp desired', record.parameters.waterTemperatureDesiredF.toStringAsFixed(1)),
                        _row('pH desired', record.parameters.pHDesired.toStringAsFixed(2)),
                        _row('Alk desired', record.parameters.totalAlkalinityDesired.toStringAsFixed(0)),
                        _row('Ca desired', record.parameters.calciumDesired.toStringAsFixed(0)),
                        _row('CYA desired', record.parameters.cyaDesired.toStringAsFixed(0)),
                        _row('Salt desired', record.parameters.saltDesired.toStringAsFixed(0)),
                        _row('Borates desired', record.parameters.boratesDesired.toStringAsFixed(0)),
                        const SizedBox(height: 16),
                        Text('LSI', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        _row('Current', record.result.current.toStringAsFixed(2)),
                        _row('Desired', record.result.desired.toStringAsFixed(2)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(k), Text(v, style: const TextStyle(fontWeight: FontWeight.w600))],
      ),
    );
  }
}
