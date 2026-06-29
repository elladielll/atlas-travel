import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/v1';
  }

  static String get mapTilerApiKey {
    return dotenv.env['MAPTILER_API_KEY'] ?? '';
  }

  static String get mapTileUrl {
    return 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$mapTilerApiKey';
  }
}