import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lsi_parameters.dart';
import '../models/lsi_result.dart';
import '../models/colors_response.dart';
import '../services/lsi_api_service.dart';
import '../models/calculation_record.dart';
import 'history_viewmodel.dart';

class LSIFormState {
  final LSIParameters parameters;
  final Map<String, String?> fieldErrors;
  final bool isValid;

  const LSIFormState({required this.parameters, required this.fieldErrors, required this.isValid});

  LSIFormState copyWith({LSIParameters? parameters, Map<String, String?>? fieldErrors, bool? isValid}) {
    return LSIFormState(
      parameters: parameters ?? this.parameters,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isValid: isValid ?? this.isValid,
    );
  }
}

class LSIResultState {
  final LSIResult? result;
  final ColorsResponse? colors;
  final bool isLoading;
  final String? error;

  const LSIResultState({this.result, this.colors, this.isLoading = false, this.error});

  LSIResultState copyWith({LSIResult? result, ColorsResponse? colors, bool? isLoading, String? error}) {
    return LSIResultState(
      result: result ?? this.result,
      colors: colors ?? this.colors,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final lsiFormProvider = StateNotifierProvider<LSIFormNotifier, LSIFormState>((ref) {
  return LSIFormNotifier();
});

final lsiResultProvider = StateNotifierProvider<LSIResultNotifier, LSIResultState>((ref) {
  return LSIResultNotifier(ref);
});

class LSIFormNotifier extends StateNotifier<LSIFormState> {
  LSIFormNotifier() : super(_initialState);

  static const LSIFormState _initialState = LSIFormState(
    parameters: LSIParameters(
      waterTemperatureCurrentF: 0,
      pHCurrent: 0,
      totalAlkalinityCurrent: 0,
      calciumCurrent: 0,
      cyaCurrent: 0,
      saltCurrent: 0,
      boratesCurrent: 0,
      waterTemperatureDesiredF: 0,
      pHDesired: 0,
      totalAlkalinityDesired: 0,
      calciumDesired: 0,
      cyaDesired: 0,
      saltDesired: 0,
      boratesDesired: 0,
    ),
    fieldErrors: {},
    isValid: false,
  );

  void updateParameter(String field, double value) {
    final newParameters = _updateParameter(state.parameters, field, value);
    final newErrors = _validateParameters(newParameters);
    final isValid = newErrors.isEmpty;

    state = state.copyWith(parameters: newParameters, fieldErrors: newErrors, isValid: isValid);
  }

  LSIParameters _updateParameter(LSIParameters parameters, String field, double value) {
    switch (field) {
      case 'waterTemperatureCurrentF':
        return parameters.copyWith(waterTemperatureCurrentF: value);
      case 'pHCurrent':
        return parameters.copyWith(pHCurrent: value);
      case 'totalAlkalinityCurrent':
        return parameters.copyWith(totalAlkalinityCurrent: value);
      case 'calciumCurrent':
        return parameters.copyWith(calciumCurrent: value);
      case 'cyaCurrent':
        return parameters.copyWith(cyaCurrent: value);
      case 'saltCurrent':
        return parameters.copyWith(saltCurrent: value);
      case 'boratesCurrent':
        return parameters.copyWith(boratesCurrent: value);
      case 'waterTemperatureDesiredF':
        return parameters.copyWith(waterTemperatureDesiredF: value);
      case 'pHDesired':
        return parameters.copyWith(pHDesired: value);
      case 'totalAlkalinityDesired':
        return parameters.copyWith(totalAlkalinityDesired: value);
      case 'calciumDesired':
        return parameters.copyWith(calciumDesired: value);
      case 'cyaDesired':
        return parameters.copyWith(cyaDesired: value);
      case 'saltDesired':
        return parameters.copyWith(saltDesired: value);
      case 'boratesDesired':
        return parameters.copyWith(boratesDesired: value);
      default:
        return parameters;
    }
  }

  Map<String, String?> _validateParameters(LSIParameters parameters) {
    final errors = <String, String?>{};

    if (parameters.pHCurrent <= 0) {
      errors['pHCurrent'] = 'pH не может быть пустым';
    } else if (parameters.pHCurrent < 6.0 || parameters.pHCurrent > 9.0) {
      errors['pHCurrent'] = 'pH должен быть между 6.0 и 9.0';
    }
    if (parameters.pHDesired <= 0) {
      errors['pHDesired'] = 'pH не может быть пустым';
    } else if (parameters.pHDesired < 6.0 || parameters.pHDesired > 9.0) {
      errors['pHDesired'] = 'pH должен быть между 6.0 и 9.0';
    }

    if (parameters.waterTemperatureCurrentF <= 0) {
      errors['waterTemperatureCurrentF'] = 'Температура не может быть пустой';
    } else if (parameters.waterTemperatureCurrentF < 32 || parameters.waterTemperatureCurrentF > 120) {
      errors['waterTemperatureCurrentF'] = 'Температура должна быть между 32°F и 120°F';
    }
    if (parameters.waterTemperatureDesiredF <= 0) {
      errors['waterTemperatureDesiredF'] = 'Температура не может быть пустой';
    } else if (parameters.waterTemperatureDesiredF < 32 || parameters.waterTemperatureDesiredF > 120) {
      errors['waterTemperatureDesiredF'] = 'Температура должна быть между 32°F и 120°F';
    }

    if (parameters.totalAlkalinityCurrent < 0) {
      errors['totalAlkalinityCurrent'] = 'Общая щелочность не может быть отрицательной';
    }
    if (parameters.totalAlkalinityDesired < 0) {
      errors['totalAlkalinityDesired'] = 'Общая щелочность не может быть отрицательной';
    }
    if (parameters.calciumCurrent < 0) {
      errors['calciumCurrent'] = 'Кальций не может быть отрицательным';
    }
    if (parameters.calciumDesired < 0) {
      errors['calciumDesired'] = 'Кальций не может быть отрицательным';
    }
    if (parameters.cyaCurrent < 0) {
      errors['cyaCurrent'] = 'Циануровая кислота не может быть отрицательной';
    }
    if (parameters.cyaDesired < 0) {
      errors['cyaDesired'] = 'Циануровая кислота не может быть отрицательной';
    }
    if (parameters.saltCurrent < 0) {
      errors['saltCurrent'] = 'Соль не может быть отрицательной';
    }
    if (parameters.saltDesired < 0) {
      errors['saltDesired'] = 'Соль не может быть отрицательной';
    }
    if (parameters.boratesCurrent < 0) {
      errors['boratesCurrent'] = 'Бораты не могут быть отрицательными';
    }
    if (parameters.boratesDesired < 0) {
      errors['boratesDesired'] = 'Бораты не могут быть отрицательными';
    }

    return errors;
  }
}

class LSIResultNotifier extends StateNotifier<LSIResultState> {
  final Ref _ref;
  LSIResultNotifier(this._ref) : super(const LSIResultState());

  Future<void> calculateLSI(LSIParameters parameters) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await LSIApiService.calculateLSI(parameters).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout: API не отвечает в течение 15 секунд');
        },
      );

      ColorsResponse? colors;
      try {
        colors = await LSIApiService.getColors(
          lsiCurrent: result.current,
          lsiDesired: result.desired,
          phCurrent: parameters.pHCurrent,
          phDesired: parameters.pHDesired,
          totalAlkalinityCurrent: parameters.totalAlkalinityCurrent,
          totalAlkalinityDesired: parameters.totalAlkalinityDesired,
          calciumCurrent: parameters.calciumCurrent,
          calciumDesired: parameters.calciumDesired,
          cyaCurrent: parameters.cyaCurrent,
          cyaDesired: parameters.cyaDesired,
          boratesCurrent: parameters.boratesCurrent,
          boratesDesired: parameters.boratesDesired,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Colors API timeout: не удалось получить цвета');
          },
        );
      } catch (e) {
        colors = null; // Continue without colors
      }

      state = state.copyWith(result: result, colors: colors, isLoading: false, error: null);
      _ref
          .read(historyProvider.notifier)
          .addRecord(CalculationRecord(createdAt: DateTime.now(), parameters: parameters, result: result));
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Ошибка при расчете LSI: ${e.toString()}');
    }
  }

  void clearResults() {
    state = const LSIResultState();
  }
}
