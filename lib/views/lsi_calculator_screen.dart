import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import '../viewmodels/lsi_calculator_viewmodel.dart';
import '../providers/auth_providers.dart';
import '../widgets/input_field.dart';
import '../widgets/lsi_result_card.dart';

class LSICalculatorScreen extends ConsumerWidget {
  const LSICalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(lsiFormProvider);
    final resultState = ref.watch(lsiResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LSI Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen()));
            },
            icon: const Icon(Icons.history),
            tooltip: 'История',
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Выход'),
                        content: const Text('Вы уверены, что хотите выйти?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Отмена')),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                );

                if (confirmed == true && context.mounted) {
                  final authNotifier = ref.read(authNotifierProvider.notifier);
                  await authNotifier.logout();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                  }
                }
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(children: const [Icon(Icons.logout, size: 20), SizedBox(width: 8), Text('Выйти')]),
                  ),
                ],
            child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.account_circle)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader(context, 'Текущие параметры'),
            const SizedBox(height: 16),
            _buildCurrentParametersForm(context, ref, formState),

            const SizedBox(height: 32),

            _buildSectionHeader(context, 'Желаемые параметры'),
            const SizedBox(height: 16),
            _buildDesiredParametersForm(context, ref, formState),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed:
                  formState.isValid && !resultState.isLoading ? () => _calculateLSI(ref, formState.parameters) : null,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child:
                  resultState.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Рассчитать LSI'),
            ),

            const SizedBox(height: 16),

            if (resultState.isLoading) ...[
              OutlinedButton(
                onPressed: () => ref.read(lsiResultProvider.notifier).clearResults(),
                child: const Text('Отмена'),
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 24),

            if (resultState.error != null) ...[
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(child: Text(resultState.error!, style: TextStyle(color: Colors.red.shade700))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (resultState.result != null) ...[
              LSIResultCard(result: resultState.result!, colors: resultState.colors),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => ref.read(lsiResultProvider.notifier).clearResults(),
                child: const Text('Очистить результаты'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildCurrentParametersForm(BuildContext context, WidgetRef ref, formState) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InputField(
                label: 'Температура воды (°F)',
                value: formState.parameters.waterTemperatureCurrentF,
                onChanged:
                    (value) => ref.read(lsiFormProvider.notifier).updateParameter('waterTemperatureCurrentF', value),
                errorText: formState.fieldErrors['waterTemperatureCurrentF'],
                suffix: '°F',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                label: 'pH',
                value: formState.parameters.pHCurrent,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('pHCurrent', value),
                errorText: formState.fieldErrors['pHCurrent'],
                min: 6.0,
                max: 9.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InputField(
                label: 'Общая щелочность (ppm)',
                value: formState.parameters.totalAlkalinityCurrent,
                onChanged:
                    (value) => ref.read(lsiFormProvider.notifier).updateParameter('totalAlkalinityCurrent', value),
                errorText: formState.fieldErrors['totalAlkalinityCurrent'],
                suffix: 'ppm',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                label: 'Кальций (ppm)',
                value: formState.parameters.calciumCurrent,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('calciumCurrent', value),
                errorText: formState.fieldErrors['calciumCurrent'],
                suffix: 'ppm',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InputField(
                label: 'Циануровая кислота (ppm)',
                value: formState.parameters.cyaCurrent,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('cyaCurrent', value),
                errorText: formState.fieldErrors['cyaCurrent'],
                suffix: 'ppm',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                label: 'Соль (ppm)',
                value: formState.parameters.saltCurrent,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('saltCurrent', value),
                errorText: formState.fieldErrors['saltCurrent'],
                suffix: 'ppm',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        InputField(
          label: 'Бораты (ppm)',
          value: formState.parameters.boratesCurrent,
          onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('boratesCurrent', value),
          errorText: formState.fieldErrors['boratesCurrent'],
          suffix: 'ppm',
        ),
      ],
    );
  }

  Widget _buildDesiredParametersForm(BuildContext context, WidgetRef ref, formState) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InputField(
                label: 'Температура воды (°F)',
                value: formState.parameters.waterTemperatureDesiredF,
                onChanged:
                    (value) => ref.read(lsiFormProvider.notifier).updateParameter('waterTemperatureDesiredF', value),
                errorText: formState.fieldErrors['waterTemperatureDesiredF'],
                suffix: '°F',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                label: 'pH',
                value: formState.parameters.pHDesired,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('pHDesired', value),
                errorText: formState.fieldErrors['pHDesired'],
                min: 6.0,
                max: 9.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InputField(
                label: 'Общая щелочность (ppm)',
                value: formState.parameters.totalAlkalinityDesired,
                onChanged:
                    (value) => ref.read(lsiFormProvider.notifier).updateParameter('totalAlkalinityDesired', value),
                errorText: formState.fieldErrors['totalAlkalinityDesired'],
                suffix: 'ppm',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                label: 'Кальций (ppm)',
                value: formState.parameters.calciumDesired,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('calciumDesired', value),
                errorText: formState.fieldErrors['calciumDesired'],
                suffix: 'ppm',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InputField(
                label: 'Циануровая кислота (ppm)',
                value: formState.parameters.cyaDesired,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('cyaDesired', value),
                errorText: formState.fieldErrors['cyaDesired'],
                suffix: 'ppm',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InputField(
                label: 'Соль (ppm)',
                value: formState.parameters.saltDesired,
                onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('saltDesired', value),
                errorText: formState.fieldErrors['saltDesired'],
                suffix: 'ppm',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        InputField(
          label: 'Бораты (ppm)',
          value: formState.parameters.boratesDesired,
          onChanged: (value) => ref.read(lsiFormProvider.notifier).updateParameter('boratesDesired', value),
          errorText: formState.fieldErrors['boratesDesired'],
          suffix: 'ppm',
        ),
      ],
    );
  }

  void _calculateLSI(WidgetRef ref, parameters) {
    ref.read(lsiResultProvider.notifier).calculateLSI(parameters);
  }
}
