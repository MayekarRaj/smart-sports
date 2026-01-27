import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../repositories/site_settings_repository.dart';
import '../models/api_models.dart';

final paymentSettingsServiceProvider =
    AsyncNotifierProvider<PaymentSettingsService, SiteSettingData?>(
      PaymentSettingsService.new,
    );

class PaymentSettingsService extends AsyncNotifier<SiteSettingData?> {
  final SiteSettingsRepository _repository = SiteSettingsRepository();

  @override
  Future<SiteSettingData?> build() async {
    return _fetchSettings();
  }

  Future<SiteSettingData?> _fetchSettings() async {
    final response = await _repository.fetchSiteSettings();
    final settings = response.data;

    // Initialize Stripe
    if (settings.stripeApiKey != null && settings.stripeApiKey!.isNotEmpty) {
      Stripe.publishableKey = settings.stripeApiKey!;
      Stripe.merchantIdentifier = 'merchant.com.courtreserve.sekai_ichi';
      await Stripe.instance.applySettings();
    }

    return settings;
  }

  // Getters for Payment Keys (accessed via ref.read(provider.notifier))
  SiteSettingData? get _data => state.value;

  String? get stripePublishableKey => _data?.stripeApiKey;
  String? get stripeSecretKey => _data?.stripeSecretKey;
  bool get isStripeEnabled => _data?.stripeIsEnabled == 1;

  String? get paypalClientId => _data?.paypalClientId;
  String? get paypalSecretKey => _data?.paypalSecretKey;
  bool get isPaypalEnabled => _data?.paypalIsEnabled == 1;
  String? get paypalUrl => _data?.paypalUrl;

  bool get isBankTransferEnabled => _data?.bankTransferIsEnabled == 1;
  SiteSettingData? get settings => _data;
}
