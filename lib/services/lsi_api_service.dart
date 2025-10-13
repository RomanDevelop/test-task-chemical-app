import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/lsi_parameters.dart';
import '../models/lsi_result.dart';
import '../models/colors_response.dart';
import 'token_storage_service.dart';

class LSIApiService {
  static const String _baseUrl = ApiConstants.baseUrl;
  static late final Dio _dio;

  static void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _refreshToken();
            final token = await TokenStorageService.getToken();
            if (token != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static Future<void> _refreshToken() async {
    try {
      final originalToken = ApiConstants.apiToken;

      final response = await _dio.post(
        '/auth',
        data: originalToken, // Send token as body
      );

      if (response.statusCode == 200) {
        final authData = response.data;
        final newToken = authData['token'] ?? authData.toString();

        await TokenStorageService.saveToken(newToken);
      } else {
        await TokenStorageService.initializeDefaultToken();
      }
    } catch (e) {
      await TokenStorageService.initializeDefaultToken();
    }
  }

  static Future<LSIResult> calculateLSI(LSIParameters parameters) async {
    try {
      final response = await _dio.get(
        ApiConstants.calculateLSIEndpoint,
        queryParameters: {
          'waterTemperatureCurrentF': parameters.waterTemperatureCurrentF,
          'phCurrent': parameters.pHCurrent,
          'totalAlkalinityCurrent': parameters.totalAlkalinityCurrent,
          'calciumCurrent': parameters.calciumCurrent,
          'cyaCurrent': parameters.cyaCurrent,
          'saltCurrent': parameters.saltCurrent,
          'boratesCurrent': parameters.boratesCurrent,
          'waterTemperatureDesiredF': parameters.waterTemperatureDesiredF,
          'phDesired': parameters.pHDesired,
          'totalAlkalinityDesired': parameters.totalAlkalinityDesired,
          'calciumDesired': parameters.calciumDesired,
          'cyaDesired': parameters.cyaDesired,
          'saltDesired': parameters.saltDesired,
          'boratesDesired': parameters.boratesDesired,
        },
      );

      try {
        final result = LSIResult.fromJson(response.data);
        return result;
      } catch (e) {
        rethrow;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to calculate LSI: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<ColorsResponse> getColors({
    double? lsiCurrent,
    double? lsiDesired,
    double? phCurrent,
    double? phDesired,
    double? totalAlkalinityCurrent,
    double? totalAlkalinityDesired,
    double? calciumCurrent,
    double? calciumDesired,
    double? cyaCurrent,
    double? cyaDesired,
    double? boratesCurrent,
    double? boratesDesired,
    double? carbonateAlkalinityCurrent,
    double? carbonateAlkalinityDesired,
    double? phCeilingCurrent,
    double? phCeilingDesired,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (lsiCurrent != null) queryParams['lsiCurrent'] = lsiCurrent;
      if (lsiDesired != null) queryParams['lsiDesired'] = lsiDesired;
      if (phCurrent != null) queryParams['phCurrent'] = phCurrent;
      if (phDesired != null) queryParams['phDesired'] = phDesired;
      if (totalAlkalinityCurrent != null) queryParams['totalAlkalinityCurrent'] = totalAlkalinityCurrent;
      if (totalAlkalinityDesired != null) queryParams['totalAlkalinityDesired'] = totalAlkalinityDesired;
      if (calciumCurrent != null) queryParams['calciumCurrent'] = calciumCurrent;
      if (calciumDesired != null) queryParams['calciumDesired'] = calciumDesired;
      if (cyaCurrent != null) queryParams['cyaCurrent'] = cyaCurrent;
      if (cyaDesired != null) queryParams['cyaDesired'] = cyaDesired;
      if (boratesCurrent != null) queryParams['boratesCurrent'] = boratesCurrent;
      if (boratesDesired != null) queryParams['boratesDesired'] = boratesDesired;
      if (carbonateAlkalinityCurrent != null) {
        queryParams['carbonateAlkalinityCurrent'] = carbonateAlkalinityCurrent;
      }
      if (carbonateAlkalinityDesired != null) {
        queryParams['carbonateAlkalinityDesired'] = carbonateAlkalinityDesired;
      }
      if (phCeilingCurrent != null) queryParams['phCeilingCurrent'] = phCeilingCurrent;
      if (phCeilingDesired != null) queryParams['phCeilingDesired'] = phCeilingDesired;

      final response = await _dio.get(ApiConstants.colorsEndpoint, queryParameters: queryParams);

      return ColorsResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to get colors: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
