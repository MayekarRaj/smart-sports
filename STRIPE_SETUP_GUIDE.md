# Stripe Payment Setup Guide

## 📋 Overview

This guide explains how to set up Stripe payments in the Smart Sports app.

---

## 🔑 Step 1: Get Your Stripe Publishable Key

### Where to Get It:

1. **Sign up/Login to Stripe Dashboard**
   - Go to: https://dashboard.stripe.com/
   - Login with your Stripe account (or create one if you don't have it)

2. **Navigate to API Keys**
   - Click on **"Developers"** in the left sidebar
   - Click on **"API keys"**

3. **Copy Your Publishable Key**
   - You'll see two keys:
     - **Publishable key** (starts with `pk_test_` for test mode or `pk_live_` for live mode)
     - **Secret key** (starts with `sk_test_` or `sk_live_`) - **DO NOT use this in the app!**
   
   - Copy the **Publishable key** (the one starting with `pk_`)

### Test vs Live Keys:

- **Test Keys** (`pk_test_...`): Use for development and testing
  - Use test card numbers (e.g., `4242 4242 4242 4242`)
  - No real charges are made
  - Available immediately after account creation

- **Live Keys** (`pk_live_...`): Use for production
  - Processes real payments
  - Only available after activating your Stripe account
  - Requires account verification

---

## ⚙️ Step 2: Configure Stripe Key in the App

### Option 1: Direct Configuration (Recommended for Development)

1. Open `lib/core/config/api_config.dart`
2. Find the `stripePublishableKeys` map
3. Replace the placeholder values with your actual keys:

```dart
static const Map<String, String> stripePublishableKeys = {
  'development': 'pk_test_YOUR_DEVELOPMENT_KEY_HERE',
  'staging': 'pk_test_YOUR_STAGING_KEY_HERE',
  'production': 'pk_live_YOUR_PRODUCTION_KEY_HERE',
};
```

**Example:**
```dart
static const Map<String, String> stripePublishableKeys = {
  'development': 'pk_test_51AbCdEfGhIjKlMnOpQrStUvWxYz1234567890',
  'staging': 'pk_test_51AbCdEfGhIjKlMnOpQrStUvWxYz1234567890',
  'production': 'pk_live_51XyZaBcDeFgHiJkLmNoPqRsTuVwXyZ1234567890',
};
```

### Option 2: Environment Variables (Recommended for Production)

For better security, you can fetch the key from your backend API:

1. Add an API endpoint to return the Stripe publishable key
2. Fetch it during app initialization
3. Set it dynamically: `Stripe.publishableKey = fetchedKey;`

---

## 📱 Step 3: Platform-Specific Configuration

### Android Configuration

1. **Update `android/app/build.gradle.kts`**:
   - Ensure minimum SDK version is 21 or higher
   - Stripe SDK should handle this automatically

2. **No additional AndroidManifest.xml changes needed** - Stripe handles permissions automatically

### iOS Configuration

1. **Update `ios/Podfile`**:
   - Run `cd ios && pod install` after adding the package
   - This should already be done if you ran `flutter pub get`

2. **Update `ios/Runner/Info.plist`** (if needed):
   - Stripe should work without additional configuration
   - If you encounter issues, add:
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
     <key>NSAllowsArbitraryLoads</key>
     <false/>
   </dict>
   ```

---

## ✅ Step 4: Verify Setup

### Test the Integration:

1. **Run the app**: `flutter run`
2. **Navigate to payment page** (after selecting paid subscription)
3. **Select "Credit/Debit Card" payment method**
4. **Check console logs**:
   - Should see: `🚀 POST .../api/stripe/create-subscription`
   - Should NOT see: `⚠️ Stripe publishable key not configured`

### Test Card Numbers (Test Mode Only):

Use these test card numbers in Stripe test mode:

- **Success**: `4242 4242 4242 4242`
- **Requires Authentication**: `4000 0025 0000 3155`
- **Declined**: `4000 0000 0000 0002`

**Expiry**: Any future date (e.g., `12/25`)  
**CVC**: Any 3 digits (e.g., `123`)  
**ZIP**: Any 5 digits (e.g., `12345`)

---

## 🔒 Security Best Practices

### ✅ DO:
- ✅ Use **publishable keys** in the app (they're safe to expose)
- ✅ Use **test keys** during development
- ✅ Switch to **live keys** only in production
- ✅ Store keys in environment-specific config
- ✅ Never commit live keys to public repositories

### ❌ DON'T:
- ❌ Use **secret keys** in the app (they must stay on the server)
- ❌ Hardcode keys in source code for production
- ❌ Commit keys to version control (use `.env` files or secure storage)
- ❌ Share secret keys with anyone

---

## 🐛 Troubleshooting

### Issue: "Stripe publishable key not configured" warning

**Solution**: 
- Make sure you've added your key to `api_config.dart`
- Check that the key doesn't contain `...` placeholder
- Verify the key starts with `pk_test_` or `pk_live_`

### Issue: Payment fails with "Invalid API Key"

**Solution**:
- Verify you're using the correct key (test vs live)
- Check that the key is copied completely (no extra spaces)
- Ensure you're using publishable key, not secret key

### Issue: Card field doesn't appear

**Solution**:
- Check that `flutter_stripe` package is properly installed
- Run `flutter pub get` again
- Verify Stripe initialization in `main.dart`

### Issue: "Network error" when creating SetupIntent

**Solution**:
- Check that your backend API is running
- Verify the API endpoint `/api/stripe/create-subscription` is accessible
- Check authentication token is valid
- Review API logs for errors

---

## 📚 Additional Resources

- **Stripe Dashboard**: https://dashboard.stripe.com/
- **Stripe API Docs**: https://stripe.com/docs/api
- **Flutter Stripe SDK**: https://pub.dev/packages/flutter_stripe
- **Stripe Test Cards**: https://stripe.com/docs/testing

---

## 🔄 Next Steps After Setup

1. ✅ Add your Stripe publishable key to `api_config.dart`
2. ✅ Test payment flow with test card numbers
3. ✅ Verify Bank Transfer payment works
4. ✅ Test error handling (declined cards, network errors)
5. ✅ Set up webhook endpoints (if needed for subscription management)

---

## 📝 Configuration Checklist

- [ ] Created Stripe account
- [ ] Obtained publishable key from Stripe Dashboard
- [ ] Added key to `lib/core/config/api_config.dart`
- [ ] Verified key is set correctly (no `...` placeholder)
- [ ] Tested payment flow with test card
- [ ] Verified Android/iOS builds work
- [ ] Tested error scenarios
- [ ] Ready for production (switched to live key)

---

## 🆘 Need Help?

If you encounter issues:
1. Check the troubleshooting section above
2. Review Stripe Dashboard logs
3. Check app console logs for errors
4. Verify API endpoints are working
5. Test with Stripe's test card numbers

