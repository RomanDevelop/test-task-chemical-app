// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lsi_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LSIParameters _$LSIParametersFromJson(
  Map<String, dynamic> json,
) => LSIParameters(
  waterTemperatureCurrentF:
      (json['waterTemperatureCurrentF'] as num).toDouble(),
  pHCurrent: (json['pHCurrent'] as num).toDouble(),
  totalAlkalinityCurrent: (json['totalAlkalinityCurrent'] as num).toDouble(),
  calciumCurrent: (json['calciumCurrent'] as num).toDouble(),
  cyaCurrent: (json['cyaCurrent'] as num).toDouble(),
  saltCurrent: (json['saltCurrent'] as num).toDouble(),
  boratesCurrent: (json['boratesCurrent'] as num).toDouble(),
  waterTemperatureDesiredF:
      (json['waterTemperatureDesiredF'] as num).toDouble(),
  pHDesired: (json['pHDesired'] as num).toDouble(),
  totalAlkalinityDesired: (json['totalAlkalinityDesired'] as num).toDouble(),
  calciumDesired: (json['calciumDesired'] as num).toDouble(),
  cyaDesired: (json['cyaDesired'] as num).toDouble(),
  saltDesired: (json['saltDesired'] as num).toDouble(),
  boratesDesired: (json['boratesDesired'] as num).toDouble(),
);

Map<String, dynamic> _$LSIParametersToJson(LSIParameters instance) =>
    <String, dynamic>{
      'waterTemperatureCurrentF': instance.waterTemperatureCurrentF,
      'pHCurrent': instance.pHCurrent,
      'totalAlkalinityCurrent': instance.totalAlkalinityCurrent,
      'calciumCurrent': instance.calciumCurrent,
      'cyaCurrent': instance.cyaCurrent,
      'saltCurrent': instance.saltCurrent,
      'boratesCurrent': instance.boratesCurrent,
      'waterTemperatureDesiredF': instance.waterTemperatureDesiredF,
      'pHDesired': instance.pHDesired,
      'totalAlkalinityDesired': instance.totalAlkalinityDesired,
      'calciumDesired': instance.calciumDesired,
      'cyaDesired': instance.cyaDesired,
      'saltDesired': instance.saltDesired,
      'boratesDesired': instance.boratesDesired,
    };
