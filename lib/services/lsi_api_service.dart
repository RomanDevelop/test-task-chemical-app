import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/lsi_parameters.dart';
import '../models/lsi_result.dart';
import '../models/colors_response.dart';
import 'token_storage_service.dart';

class LSIApiService {
  static const String _baseUrl = ApiConstants.baseUrl;
  static late final Dio _dio;

  /// Initialize Dio with interceptors
  static void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add token interceptor
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
            // Token expired, try to refresh
            await _refreshToken();
            // Retry the request
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

  /// Refresh the API token by calling /auth endpoint
  static Future<void> _refreshToken() async {
    try {
      print('🔄 Refreshing API token...');

      // Get the original token
      final originalToken = ApiConstants.apiToken;

      // Call /auth endpoint to get new token
      final response = await _dio.post(
        '/auth',
        data: originalToken, // Send token as body
      );

      if (response.statusCode == 200) {
        final authData = response.data;
        final newToken = authData['token'] ?? authData.toString();
        print('✅ New token received: ${newToken.toString().substring(0, 20)}...');

        // Save new token
        await TokenStorageService.saveToken(newToken);
        print('✅ Token refreshed successfully');
      } else {
        print('❌ Failed to refresh token: ${response.statusCode}');
        // Fallback to original token
        await TokenStorageService.initializeDefaultToken();
      }
    } catch (e) {
      print('❌ Error refreshing token: $e');
      // Fallback to original token
      await TokenStorageService.initializeDefaultToken();
    }
  }

  /// Calculate LSI using the Orenda API
  static Future<LSIResult> calculateLSI(LSIParameters parameters) async {
    try {
      print('🚀 Starting LSI calculation...');
      print('📊 Parameters: ${parameters.toJson()}');

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

      print('✅ LSI calculation successful: ${response.data}');
      print('🔍 Response data type: ${response.data.runtimeType}');
      print('🔍 Response data content: ${response.data}');

      try {
        final result = LSIResult.fromJson(response.data);
        print('✅ LSIResult created successfully');
        return result;
      } catch (e) {
        print('❌ Error creating LSIResult: $e');
        rethrow;
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      print('❌ Status Code: ${e.response?.statusCode}');

      if (e.response != null) {
        throw Exception('Failed to calculate LSI: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('❌ General error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get colors for LSI values
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
