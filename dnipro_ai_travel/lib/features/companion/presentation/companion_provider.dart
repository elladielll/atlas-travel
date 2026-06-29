import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/providers/image_providers.dart';
import '../data/companion_repository.dart';
import '../domain/companion_dashboard.dart';

final companionRepositoryProvider = Provider<CompanionRepository>((ref) {
  return CompanionRepository(
    apiClient: ApiClient(
      httpClient: ref.watch(httpClientProvider),
    ),
  );
});

final companionProvider = FutureProvider<CompanionDashboard>((ref) async {
  final repository = ref.watch(companionRepositoryProvider);
  return repository.getDashboard();
});