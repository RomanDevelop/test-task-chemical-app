import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/lsi_api_service.dart';
import '../services/token_storage_service.dart';

final lsiApiServiceProvider = Provider<LSIApiService>((ref) {
  return LSIApiService();
});

final tokenStorageProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});
