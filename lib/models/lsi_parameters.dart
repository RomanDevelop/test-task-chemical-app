import 'package:json_annotation/json_annotation.dart';

part 'lsi_parameters.g.dart';

@JsonSerializable()
class LSIParameters {
  final double waterTemperatureCurrentF;
  final double pHCurrent;
  final double totalAlkalinityCurrent;
  final double calciumCurrent;
  final double cyaCurrent;
  final double saltCurrent;
  final double boratesCurrent;
  final double waterTemperatureDesiredF;
  final double pHDesired;
  final double totalAlkalinityDesired;
  final double calciumDesired;
  final double cyaDesired;
  final double saltDesired;
  final double boratesDesired;

  const LSIParameters({
    required this.waterTemperatureCurrentF,
    required this.pHCurrent,
    required this.totalAlkalinityCurrent,
    required this.calciumCurrent,
    required this.cyaCurrent,
    required this.saltCurrent,
    required this.boratesCurrent,
    required this.waterTemperatureDesiredF,
    required this.pHDesired,
    required this.totalAlkalinityDesired,
    required this.calciumDesired,
    required this.cyaDesired,
    required this.saltDesired,
    required this.boratesDesired,
  });

  factory LSIParameters.fromJson(Map<String, dynamic> json) => _$LSIParametersFromJson(json);

  Map<String, dynamic> toJson() => _$LSIParametersToJson(this);

  LSIParameters copyWith({
    double? waterTemperatureCurrentF,
    double? pHCurrent,
    double? totalAlkalinityCurrent,
    double? calciumCurrent,
    double? cyaCurrent,
    double? saltCurrent,
    double? boratesCurrent,
    double? waterTemperatureDesiredF,
    double? pHDesired,
    double? totalAlkalinityDesired,
    double? calciumDesired,
    double? cyaDesired,
    double? saltDesired,
    double? boratesDesired,
  }) {
    return LSIParameters(
      waterTemperatureCurrentF: waterTemperatureCurrentF ?? this.waterTemperatureCurrentF,
      pHCurrent: pHCurrent ?? this.pHCurrent,
      totalAlkalinityCurrent: totalAlkalinityCurrent ?? this.totalAlkalinityCurrent,
      calciumCurrent: calciumCurrent ?? this.calciumCurrent,
      cyaCurrent: cyaCurrent ?? this.cyaCurrent,
      saltCurrent: saltCurrent ?? this.saltCurrent,
      boratesCurrent: boratesCurrent ?? this.boratesCurrent,
      waterTemperatureDesiredF: waterTemperatureDesiredF ?? this.waterTemperatureDesiredF,
      pHDesired: pHDesired ?? this.pHDesired,
      totalAlkalinityDesired: totalAlkalinityDesired ?? this.totalAlkalinityDesired,
      calciumDesired: calciumDesired ?? this.calciumDesired,
      cyaDesired: cyaDesired ?? this.cyaDesired,
      saltDesired: saltDesired ?? this.saltDesired,
      boratesDesired: boratesDesired ?? this.boratesDesired,
    );
  }
}
