import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/lsi_api_service.dart';
import '../services/token_storage_service.dart';

/// Provider for LSI API Service
final lsiApiServiceProvider = Provider<LSIApiService>((ref) {
  return LSIApiService();
});

/// Provider for token storage service
final tokenStorageProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});
