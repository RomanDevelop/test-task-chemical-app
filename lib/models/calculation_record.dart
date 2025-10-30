import 'lsi_parameters.dart';
import 'lsi_result.dart';

class CalculationRecord {
  final DateTime createdAt;
  final LSIParameters parameters;
  final LSIResult result;

  const CalculationRecord({required this.createdAt, required this.parameters, required this.result});
}
