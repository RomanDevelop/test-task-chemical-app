// Тестовые данные для проверки приложения
class TestData {
  static const Map<String, double> validCurrentParameters = {
    'waterTemperatureCurrentF': 80.0,
    'pHCurrent': 7.6,
    'totalAlkalinityCurrent': 80.0,
    'calciumCurrent': 300.0,
    'cyaCurrent': 35.0,
    'saltCurrent': 400.0,
    'boratesCurrent': 0.0,
  };

  static const Map<String, double> validDesiredParameters = {
    'waterTemperatureDesiredF': 77.0,
    'pHDesired': 8.2,
    'totalAlkalinityDesired': 90.0,
    'calciumDesired': 370.0,
    'cyaDesired': 0.0,
    'saltDesired': 900.0,
    'boratesDesired': 0.0,
  };

  static const Map<String, double> invalidParameters = {
    'waterTemperatureCurrentF': 150.0, // Слишком высокая температура
    'pHCurrent': 5.0, // Слишком низкий pH
    'totalAlkalinityCurrent': -10.0, // Отрицательное значение
    'calciumCurrent': 0.0, // Пустое значение
    'cyaCurrent': 0.0,
    'saltCurrent': 0.0,
    'boratesCurrent': 0.0,
  };
}
