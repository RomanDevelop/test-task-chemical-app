import 'package:flutter_test/flutter_test.dart';
import 'package:test_task/models/lsi_parameters.dart';
import 'package:test_task/viewmodels/lsi_calculator_viewmodel.dart';

void main() {
  group('LSIFormNotifier pH validation', () {
    late LSIFormNotifier notifier;

    setUp(() {
      notifier = LSIFormNotifier();
    });

    test('pH пустой (0.0) — ошибка валидности', () {
      notifier.updateParameter('pHCurrent', 0);
      expect(notifier.state.fieldErrors['pHCurrent'], isNotNull);
      expect(notifier.state.isValid, isFalse);
    });

    test('pH ниже минимального (5.5) — ошибка "между 6 и 9"', () {
      notifier.updateParameter('pHCurrent', 5.5);
      expect(notifier.state.fieldErrors['pHCurrent'], contains('между 6.0 и 9.0'));
      expect(notifier.state.isValid, isFalse);
    });

    test('pH выше максимального (9.5) — ошибка "между 6 и 9"', () {
      notifier.updateParameter('pHCurrent', 9.5);
      expect(notifier.state.fieldErrors['pHCurrent'], contains('между 6.0 и 9.0'));
      expect(notifier.state.isValid, isFalse);
    });

    test('pH валидное (7.4) — нет ошибок', () {
      notifier.updateParameter('pHCurrent', 7.4);
      expect(notifier.state.fieldErrors['pHCurrent'], isNull);
    });
  });

  group('LSIFormNotifier temperature validation', () {
    late LSIFormNotifier notifier;

    setUp(() {
      notifier = LSIFormNotifier();
    });

    test('Температура воды пустая (0.0) — ошибка валидности', () {
      notifier.updateParameter('waterTemperatureCurrentF', 0);
      expect(notifier.state.fieldErrors['waterTemperatureCurrentF'], isNotNull);
      expect(notifier.state.isValid, isFalse);
    });

    test('Температура воды ниже минимума (10.0°F) — ошибка диапазона', () {
      notifier.updateParameter('waterTemperatureCurrentF', 10.0);
      expect(notifier.state.fieldErrors['waterTemperatureCurrentF'], contains('между 32°F и 120°F'));
      expect(notifier.state.isValid, isFalse);
    });

    test('Температура воды выше максимума (130.0°F) — ошибка диапазона', () {
      notifier.updateParameter('waterTemperatureCurrentF', 130.0);
      expect(notifier.state.fieldErrors['waterTemperatureCurrentF'], contains('между 32°F и 120°F'));
      expect(notifier.state.isValid, isFalse);
    });

    test('Температура воды валидная (77.0°F) — нет ошибок', () {
      notifier.updateParameter('waterTemperatureCurrentF', 77.0);
      expect(notifier.state.fieldErrors['waterTemperatureCurrentF'], isNull);
    });
  });

  group('LSIFormNotifier negative values validation', () {
    late LSIFormNotifier notifier;
    setUp(() {
      notifier = LSIFormNotifier();
    });

    final negativeFields = [
      'totalAlkalinityCurrent',
      'calciumCurrent',
      'cyaCurrent',
      'saltCurrent',
      'boratesCurrent',
      'totalAlkalinityDesired',
      'calciumDesired',
      'cyaDesired',
      'saltDesired',
      'boratesDesired',
    ];

    for (var field in negativeFields) {
      test('$field = -5.0 выдаёт ошибку про отрицательное значение', () {
        notifier.updateParameter(field, -5.0);
        expect(notifier.state.fieldErrors[field], isNotNull);
        expect(notifier.state.fieldErrors[field]!.toLowerCase(), contains('не может быть отрицатель'));
        expect(notifier.state.isValid, isFalse);
      });
    }
  });
}
