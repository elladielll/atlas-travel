import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/places/presentation/places_providers.dart';
import '../data/passport_repository.dart';

final passportRepositoryProvider = Provider<PassportRepository>((ref) {
  return PassportRepository(
    apiClient: ref.watch(apiClientProvider),
  );
});

final passportVisitsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(passportRepositoryProvider);
  return repository.getVisits();
});