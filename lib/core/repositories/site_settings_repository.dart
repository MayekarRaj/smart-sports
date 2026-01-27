import '../constants/api_endpoints.dart';
import '../models/api_models.dart';
import '../exceptions/api_exception.dart';
import 'base_repository.dart';

class SiteSettingsRepository extends BaseRepository {
  /// Fetch site settings
  /// By default, fetches with all keys revealed (paypalEdit=1, stripeEdit=1)
  /// as configured in ApiEndpoints.getSiteSettingsUrl default parameters.
  Future<SiteSettingResponse> fetchSiteSettings() async {
    final response = await networkClient.get<Map<String, dynamic>>(
      ApiEndpoints.getSiteSettingsUrl(),
      requiresAuth: true,
      fromJson: null, // Get full response to parse manually
    );

    if (response.success && response.hasData) {
      final fullResponse = response.dataOrThrow;
      return SiteSettingResponse.fromJson(fullResponse);
    }

    throw ApiException(
      message: response.message,
      statusCode: response.statusCode ?? 0,
    );
  }
}
