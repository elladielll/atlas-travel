import '../config/app_config.dart';

class ApiRoutes {
  static String get baseUrl => AppConfig.apiBaseUrl;

  static const places = '/places';
  static const place = '/places/{id}';
  static const reviews = '/reviews';
  static const image = '/images';
  static const aiSummary = '/ai/summary';
  static const auth = '/auth';
}