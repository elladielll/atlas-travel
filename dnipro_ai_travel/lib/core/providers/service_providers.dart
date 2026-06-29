import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/image/image_cache.dart';
import '../services/image/image_service.dart';
import '../services/image/providers/openverse_provider.dart';
import '../services/image/providers/provider_chain.dart';
import '../services/network/http_client.dart';

final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient();
});

final imageCacheProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService();
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService(
    cache: ref.watch(imageCacheProvider),
    provider: ProviderChain(
      providers: [
        OpenverseProvider(
          client: ref.watch(httpClientProvider),
        ),
      ],
    ),
  );
});