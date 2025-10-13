class ColorsResponse {
  final String? lsiCurrentColor;
  final String? lsiDesiredColor;
  final String? phCurrentColor;
  final String? phDesiredColor;
  final String? totalAlkalinityCurrentColor;
  final String? totalAlkalinityDesiredColor;
  final String? calciumCurrentColor;
  final String? calciumDesiredColor;
  final String? cyaCurrentColor;
  final String? cyaDesiredColor;
  final String? borateCurrentColor;
  final String? borateDesiredColor;
  final String? carbonateAlkalinityCurrentColor;
  final String? carbonateAlkalinityDesiredColor;
  final String? phCeilingCurrentColor;
  final String? phCeilingDesiredColor;

  const ColorsResponse({
    this.lsiCurrentColor,
    this.lsiDesiredColor,
    this.phCurrentColor,
    this.phDesiredColor,
    this.totalAlkalinityCurrentColor,
    this.totalAlkalinityDesiredColor,
    this.calciumCurrentColor,
    this.calciumDesiredColor,
    this.cyaCurrentColor,
    this.cyaDesiredColor,
    this.borateCurrentColor,
    this.borateDesiredColor,
    this.carbonateAlkalinityCurrentColor,
    this.carbonateAlkalinityDesiredColor,
    this.phCeilingCurrentColor,
    this.phCeilingDesiredColor,
  });

  factory ColorsResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing ColorsResponse from JSON: $json');
    try {
      final result = ColorsResponse(
        lsiCurrentColor: json['lsiCurrentColor'] as String?,
        lsiDesiredColor: json['lsiDesiredColor'] as String?,
        phCurrentColor: json['phCurrentColor'] as String?,
        phDesiredColor: json['phDesiredColor'] as String?,
        totalAlkalinityCurrentColor: json['totalAlkalinityCurrentColor'] as String?,
        totalAlkalinityDesiredColor: json['totalAlkalinityDesiredColor'] as String?,
        calciumCurrentColor: json['calciumCurrentColor'] as String?,
        calciumDesiredColor: json['calciumDesiredColor'] as String?,
        cyaCurrentColor: json['cyaCurrentColor'] as String?,
        cyaDesiredColor: json['cyaDesiredColor'] as String?,
        borateCurrentColor: json['borateCurrentColor'] as String?,
        borateDesiredColor: json['borateDesiredColor'] as String?,
        carbonateAlkalinityCurrentColor: json['carbonateAlkalinityCurrentColor'] as String?,
        carbonateAlkalinityDesiredColor: json['carbonateAlkalinityDesiredColor'] as String?,
        phCeilingCurrentColor: json['phCeilingCurrentColor'] as String?,
        phCeilingDesiredColor: json['phCeilingDesiredColor'] as String?,
      );
      print('✅ ColorsResponse parsed successfully');
      return result;
    } catch (e) {
      print('❌ Error parsing ColorsResponse: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lsiCurrentColor': lsiCurrentColor,
      'lsiDesiredColor': lsiDesiredColor,
      'phCurrentColor': phCurrentColor,
      'phDesiredColor': phDesiredColor,
      'totalAlkalinityCurrentColor': totalAlkalinityCurrentColor,
      'totalAlkalinityDesiredColor': totalAlkalinityDesiredColor,
      'calciumCurrentColor': calciumCurrentColor,
      'calciumDesiredColor': calciumDesiredColor,
      'cyaCurrentColor': cyaCurrentColor,
      'cyaDesiredColor': cyaDesiredColor,
      'borateCurrentColor': borateCurrentColor,
      'borateDesiredColor': borateDesiredColor,
      'carbonateAlkalinityCurrentColor': carbonateAlkalinityCurrentColor,
      'carbonateAlkalinityDesiredColor': carbonateAlkalinityDesiredColor,
      'phCeilingCurrentColor': phCeilingCurrentColor,
      'phCeilingDesiredColor': phCeilingDesiredColor,
    };
  }
}
