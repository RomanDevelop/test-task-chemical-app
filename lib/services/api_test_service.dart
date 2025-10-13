import 'package:dio/dio.dart';

class APITestService {
  static Future<void> testAPI() async {
    final dio = Dio();

    try {
      print('🧪 Testing API connection...');

      // Test basic connectivity
      final response = await dio.get('https://orendatechapi.com/colors');
      print('✅ Colors API works: ${response.statusCode}');

      // Test LSI API with sample data
      final lsiResponse = await dio.get(
        'https://orendatechapi.com/calculateLSI',
        queryParameters: {
          'waterTemperatureCurrentF': 80,
          'phCurrent': 7.6,
          'totalAlkalinityCurrent': 80,
          'calciumCurrent': 300,
          'cyaCurrent': 35,
          'saltCurrent': 400,
          'boratesCurrent': 0,
          'waterTemperatureDesiredF': 77,
          'phDesired': 8.2,
          'totalAlkalinityDesired': 90,
          'calciumDesired': 370,
          'cyaDesired': 0,
          'saltDesired': 900,
          'boratesDesired': 0,
        },
      );

      print('✅ LSI API works: ${response.statusCode}');
      print('📊 Response: ${lsiResponse.data}');
    } catch (e) {
      print('❌ API Test failed: $e');
    }
  }
}
