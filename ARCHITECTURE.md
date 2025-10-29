# Архитектура проекта LSI Calculator

## 📋 Обзор проекта

Это Flutter приложение для расчета индекса насыщения Ланжелье (LSI) воды в бассейнах. Приложение использует MVVM архитектуру с Riverpod для управления состоянием и интегрируется с Orenda Web API.

---

## 🏗️ Архитектура (MVVM)

Проект следует паттерну **Model-View-ViewModel (MVVM)**:

```
┌─────────────────────────────────────────────────────────┐
│                    VIEW (UI Layer)                      │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LSICalculatorScreen                             │   │
│  │  - Отображает форму ввода параметров             │   │
│  │  - Показывает результаты расчета                 │   │
│  │  - Использует ConsumerWidget для подписки        │   │
│  └──────────────────────────────────────────────────┘   │
│                          │                               │
│                          │ ref.watch() / ref.read()      │
│                          ▼                               │
┌─────────────────────────────────────────────────────────┐
│                   VIEWMODEL (State)                     │
│  ┌──────────────────────────────────────────────────┐   │
│  │  LSIFormNotifier / LSIResultNotifier             │   │
│  │  - Управляет формой и валидацией                 │   │
│  │  - Обрабатывает бизнес-логику                    │   │
│  │  - Обновляет состояние через StateNotifier       │   │
│  └──────────────────────────────────────────────────┘   │
│                          │                               │
│                          │ вызывает методы              │
│                          ▼                               │
┌─────────────────────────────────────────────────────────┐
│                    MODEL & SERVICES                     │
│  ┌──────────────────────────┐  ┌──────────────────────┐ │
│  │  Models (Data Classes)   │  │  Services (API)      │ │
│  │  - LSIParameters         │  │  - LSIApiService     │ │
│  │  - LSIResult             │  │  - TokenStorageService│ │
│  │  - ColorsResponse        │  └──────────────────────┘ │
│  └──────────────────────────┘                            │
└─────────────────────────────────────────────────────────┘
```

### Ключевые принципы:

- **View**: Только отображение UI, не содержит бизнес-логики
- **ViewModel**: Управляет состоянием и валидацией, вызывает сервисы
- **Model**: Чистые data-классы без логики
- **Services**: Отвечают за взаимодействие с API и хранилищем

---

## 📁 Структура проекта

```
lib/
├── constants/
│   └── api_constants.dart          # Константы API (URL, endpoints, токен)
│
├── models/
│   ├── lsi_parameters.dart          # Модель входных параметров расчета
│   ├── lsi_result.dart             # Модель результата расчета
│   └── colors_response.dart        # Модель ответа API для цветовых индикаторов
│
├── services/
│   ├── lsi_api_service.dart         # Сервис для работы с Orenda API
│   └── token_storage_service.dart   # Сервис для безопасного хранения токенов
│
├── viewmodels/
│   └── lsi_calculator_viewmodel.dart # ViewModels: управление формой и результатами
│
├── views/
│   └── lsi_calculator_screen.dart    # Главный экран приложения
│
├── widgets/
│   ├── input_field.dart             # Переиспользуемый виджет для ввода чисел
│   └── lsi_result_card.dart         # Виджет для отображения результатов
│
└── main.dart                        # Точка входа в приложение
```

---

## 🔍 Детальный разбор компонентов

### 1. **Constants** (`api_constants.dart`)

```dart
class ApiConstants {
  static const String baseUrl = 'https://orendatechapi.com';
  static const String calculateLSIEndpoint = '/calculateLSI';
  static const String colorsEndpoint = '/colors';
  static const String apiToken = '...'; // Длинный токен для аутентификации
}
```

**Назначение**: Централизованное хранение всех констант API. Если API изменится, править нужно только здесь.

**Почему так**: DRY (Don't Repeat Yourself) - один источник правды для URL и токенов.

---

### 2. **Models** (Модели данных)

#### `LSIParameters`

Содержит все 14 параметров для расчета:

- Текущие параметры (7): температура, pH, щелочность, кальций, CYA, соль, бораты
- Желаемые параметры (7): те же самые

**Особенности**:

- Использует `@JsonSerializable` для автоматической сериализации
- Метод `copyWith()` для immutable обновлений
- Все поля `final` - неизменяемость обеспечивает безопасность

#### `LSIResult`

Результат расчета из API:

```dart
class LSIResult {
  final double current;        // Текущий LSI
  final double desired;        // Желаемый LSI
  final double? phCeilingCurrent;   // Опционально
  final double? phCeilingDesired;  // Опционально
}
```

**Важный момент**: Использует кастомный `_parseDouble()` для обработки случаев, когда API возвращает строки вместо чисел (защита от нестабильности API).

#### `ColorsResponse`

Содержит HEX-коды цветов для визуальной индикации каждого параметра.

---

### 3. **Services** (Сервисы)

#### `TokenStorageService`

**Назначение**: Безопасное хранение API токенов с использованием `flutter_secure_storage`.

**Ключевые особенности**:

- На iOS использует Keychain (системное безопасное хранилище)
- На Android использует EncryptedSharedPreferences
- Сохраняет время истечения токена (24 часа)
- Метод `initializeDefaultToken()` сохраняет дефолтный токен при первом запуске

**Почему важно**: Токены не должны храниться в открытом виде. Secure Storage шифрует данные.

#### `LSIApiService`

**Назначение**: Вся логика работы с API через Dio.

**Архитектурные решения**:

1. **Dio Interceptors** - автоматическая аутентификация:

```dart
_dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await TokenStorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  },
  onError: (error, handler) async {
    if (error.response?.statusCode == 401) {
      await _refreshToken(); // Автоматическое обновление токена
      // Повтор запроса
    }
  },
));
```

**Почему так**: Interceptor автоматически добавляет токен ко всем запросам и обрабатывает 401 ошибки без дублирования кода.

2. **Двухэтапная аутентификация**:

   - POST `/auth` с исходным токеном → получаем новый токен
   - Используем новый токен как Bearer token для всех запросов

3. **Метод `calculateLSI()`**:

   - Отправляет GET запрос с query параметрами
   - Обрабатывает ошибки DioException vs обычные Exception
   - Возвращает типизированный `LSIResult`

4. **Метод `getColors()`**:
   - Условное добавление query параметров (только если не null)
   - Возвращает цвета для визуальной индикации

---

### 4. **ViewModels** (`lsi_calculator_viewmodel.dart`)

#### Два StateNotifier'а:

**1. `LSIFormNotifier`** - управление формой:

```dart
class LSIFormState {
  final LSIParameters parameters;      // Текущие значения полей
  final Map<String, String?> fieldErrors; // Ошибки валидации
  final bool isValid;                  // Можно ли отправить форму
}
```

**Логика валидации**:

- `pH` должен быть между 6.0 и 9.0
- Температура между 32°F и 120°F
- Все параметры не могут быть отрицательными
- Валидация происходит при каждом изменении поля

**2. `LSIResultNotifier`** - управление результатами:

```dart
class LSIResultState {
  final LSIResult? result;
  final ColorsResponse? colors;
  final bool isLoading;
  final String? error;
}
```

**Последовательность при расчете**:

1. Устанавливаем `isLoading = true`
2. Вызываем `LSIApiService.calculateLSI()` (таймаут 15 сек)
3. Если успешно → вызываем `LSIApiService.getColors()` (таймаут 10 сек)
4. Если цвета не загрузились → продолжаем без цветов (не критично)
5. Сохраняем результат или ошибку в state

**Важно**: Использование `.timeout()` предотвращает зависание UI.

---

### 5. **Views** (`lsi_calculator_screen.dart`)

**Архитектура**:

- `ConsumerWidget` - подписывается на Riverpod providers
- Не хранит состояние локально, все через `ref.watch()`

**Структура экрана**:

1. **Секция "Текущие параметры"** - 7 полей ввода
2. **Секция "Желаемые параметры"** - 7 полей ввода
3. **Кнопка "Рассчитать LSI"** - активна только если `formState.isValid`
4. **Индикатор загрузки** - показывается во время запроса
5. **Карточка результатов** - отображает LSI значения с цветами
6. **Сообщение об ошибке** - красная карточка при ошибках

**Реактивность**:

```dart
final formState = ref.watch(lsiFormProvider);   // Автоматически перестраивается при изменении формы
final resultState = ref.watch(lsiResultProvider); // Автоматически обновляется при получении результатов
```

---

### 6. **Widgets** (Переиспользуемые компоненты)

#### `InputField`

**Назначение**: Универсальное поле для числового ввода.

**Параметры**:

- `label` - подпись поля
- `value` - текущее значение (controlled component)
- `onChanged` - коллбэк при изменении
- `errorText` - текст ошибки валидации
- `suffix` - единицы измерения (например, "°F", "ppm")
- `min`/`max` - ограничения для валидации

**Почему отдельный виджет**: DRY - все 14 полей используют один компонент.

#### `LSIResultCard`

**Назначение**: Красивое отображение результатов с цветовой индикацией.

**Особенности**:

- Конвертирует HEX строки в `Color` объекты
- Использует цвета для фона и текста значений
- Graceful degradation: если цвета не загрузились, показывает без них

---

## 🔄 Поток данных (Data Flow)

```
1. Пользователь вводит значение в InputField
   │
   ▼
2. InputField вызывает onChanged(double value)
   │
   ▼
3. LSICalculatorScreen вызывает ref.read(lsiFormProvider.notifier).updateParameter()
   │
   ▼
4. LSIFormNotifier обновляет LSIParameters и валидирует
   │
   ▼
5. LSIFormState обновляется → UI автоматически перестраивается (ref.watch)
   │
   ▼
6. Пользователь нажимает "Рассчитать LSI"
   │
   ▼
7. LSICalculatorScreen вызывает ref.read(lsiResultProvider.notifier).calculateLSI()
   │
   ▼
8. LSIResultNotifier вызывает LSIApiService.calculateLSI()
   │
   ▼
9. LSIApiService делает запрос к API (с автоматической аутентификацией через interceptor)
   │
   ▼
10. Полученный LSIResult сохраняется в LSIResultState
    │
    ▼
11. UI автоматически обновляется и показывает результаты
```

---

## 🛠️ Технологический стек

| Компонент              | Технология                          | Зачем                               |
| ---------------------- | ----------------------------------- | ----------------------------------- |
| **State Management**   | Riverpod 2.5.1                      | Управление состоянием, реактивность |
| **HTTP Client**        | Dio 5.4.0                           | HTTP запросы с interceptors         |
| **Secure Storage**     | flutter_secure_storage 9.2.2        | Безопасное хранение токенов         |
| **JSON Serialization** | json_annotation + json_serializable | Автоматическая сериализация моделей |
| **Form Validation**    | form_validator 2.1.1                | Валидация полей формы               |
| **UI Framework**       | Flutter (Material 3)                | Современный Material Design         |

---

## 🔐 Безопасность

1. **Токены хранятся в Secure Storage** - зашифрованы на уровне ОС
2. **Автоматический refresh токена** при 401 ошибке
3. **Таймауты на запросы** - предотвращают зависание
4. **Обработка ошибок** - пользователь всегда видит понятное сообщение

---

## 🎯 Ключевые архитектурные решения

### Почему MVVM?

- **Разделение ответственности**: UI отделен от бизнес-логики
- **Тестируемость**: ViewModel можно тестировать без UI
- **Переиспользуемость**: ViewModels можно использовать в разных Views

### Почему Riverpod вместо Provider/Bloc?

- Более современный и типобезопасный
- Автоматическое управление жизненным циклом
- Лучшая поддержка async операций
- Compile-time безопасность (ошибки видны на этапе компиляции)

### Почему Dio вместо http?

- Interceptors для глобальной логики (аутентификация, логирование)
- Лучшая обработка ошибок
- Поддержка отмены запросов
- Более гибкая конфигурация

### Почему Static Services вместо Providers?

- Простота: не нужна DI контейнер для простых случаев
- Меньше boilerplate кода
- Достаточно для singleton сервисов

---

## 📝 Важные детали реализации

### 1. Обработка типов данных от API

API может возвращать числа как `num` или `String`. Метод `_parseDouble()` обрабатывает оба случая:

```dart
static double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.parse(value);
  throw Exception('Cannot parse $value as double');
}
```

### 2. Graceful degradation для цветов

Если запрос цветов не удался, приложение продолжает работать без цветов - это не критичная функция.

### 3. Валидация на уровне ViewModel

Валидация происходит не в UI, а в ViewModel - это правильный подход для MVVM.

### 4. Immutable State

Все state классы используют `copyWith()` для обновлений - это предотвращает случайные мутации.

---

## 🚀 Точка входа (`main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Важно для async операций

  await TokenStorageService.initializeDefaultToken(); // Сохраняем токен при старте
  LSIApiService.initialize(); // Инициализируем Dio с interceptors

  runApp(const ProviderScope(child: MyApp())); // ProviderScope необходим для Riverpod
}
```

**Почему async в main**: Инициализация должна завершиться до запуска приложения.

---

## 📚 Для дальнейшего изучения

1. **Riverpod документация**: https://riverpod.dev
2. **Dio документация**: https://pub.dev/packages/dio
3. **MVVM в Flutter**: https://docs.flutter.dev/development/data-and-backend/state-mgmt/options
4. **Flutter Secure Storage**: https://pub.dev/packages/flutter_secure_storage

---

## ❓ Частые вопросы от мидлов

**Q: Почему два отдельных StateNotifier для формы и результатов?**
A: Single Responsibility Principle - форма и результаты имеют разные жизненные циклы и ответственности.

**Q: Зачем нужен `copyWith()` если можно использовать обычные сеттеры?**
A: Immutability предотвращает баги с мутациями. Также это упрощает отладку - легче отследить, где состояние изменилось.

**Q: Почему Interceptors, а не ручная добавка токена в каждом запросе?**
A: DRY - токен добавляется автоматически, не нужно помнить об этом в каждом методе. Также легко добавить логирование, retry логику и т.д.

**Q: Почему валидация в ViewModel, а не в UI?**
A: Логика валидации - это бизнес-логика, она не должна быть в UI. Плюс можно переиспользовать в других местах.

---

## 🎓 Заключение

Проект демонстрирует:

- ✅ Правильное использование MVVM архитектуры
- ✅ Современные практики Flutter разработки
- ✅ Безопасное хранение чувствительных данных
- ✅ Обработку ошибок и edge cases
- ✅ Типобезопасность и null-safety
- ✅ Чистый и поддерживаемый код

Это production-ready архитектура, которую можно масштабировать и расширять.
