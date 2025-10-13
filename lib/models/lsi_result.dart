class LSIResult {
  final double current;
  final double desired;
  final double? phCeilingCurrent;
  final double? phCeilingDesired;

  const LSIResult({required this.current, required this.desired, this.phCeilingCurrent, this.phCeilingDesired});

  factory LSIResult.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing LSIResult from JSON: $json');
    try {
      final result = LSIResult(
        current: _parseDouble(json['lsiCurrent']),
        desired: _parseDouble(json['lsiDesired']),
        phCeilingCurrent: json['phCeilingCurrent'] != null ? _parseDouble(json['phCeilingCurrent']) : null,
        phCeilingDesired: json['phCeilingDesired'] != null ? _parseDouble(json['phCeilingDesired']) : null,
      );
      print('✅ LSIResult parsed successfully: current=${result.current}, desired=${result.desired}');
      return result;
    } catch (e) {
      print('❌ Error parsing LSIResult: $e');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    throw Exception('Cannot parse $value as double');
  }

  Map<String, dynamic> toJson() {
    return {
      'lsiCurrent': current,
      'lsiDesired': desired,
      'phCeilingCurrent': phCeilingCurrent,
      'phCeilingDesired': phCeilingDesired,
    };
  }
}
