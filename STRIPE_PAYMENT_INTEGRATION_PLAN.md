# Stripe Payment Integration Plan

## 📋 Current State Analysis

### ✅ Already Implemented
1. **Save Optional Paid Services API** - Fully integrated
   - Endpoint: `/api/save-optional-paid-services`
   - Repository method: `AuthRepository.saveOptionalPaidServices()`
   - Models: `SaveOptionalPaidServicesRequest` and `SaveOptionalPaidServicesResponse`
   - Used in all membership plan pages (member, club, corporate, coach, freelancer, merchandiser)

2. **Payment Method Page UI** - Basic structure exists
   - Location: `lib/auth/screens/payment_method_page.dart`
   - Supports: Credit/Debit Card and PayPal UI
   - Currently: Only mockup, no actual payment processing

3. **Network Infrastructure**
   - `NetworkClient` with JSON POST support
   - `ApiEndpoints` centralized endpoint management
   - `ApiModels` with json_serializable
   - Error handling with `ApiException`

### ❌ Missing Components
1. **Stripe SDK** - Not installed
2. **Multipart Form Data Support** - NetworkClient only supports JSON
3. **Stripe API Integration** - No endpoints or models
4. **Payment Processing Logic** - PaymentMethodPage only has UI

---

## 🎯 APIs to Integrate

### 1. Save Optional Paid Services ✅ (Already Done)
- **Endpoint**: `POST /api/save-optional-paid-services`
- **Status**: ✅ Implemented
- **Purpose**: Save selected optional services before payment

### 2. Create Stripe SetupIntent
- **Endpoint**: `POST /api/stripe/create-subscription`
- **Purpose**: Get SetupIntent client_secret for card collection
- **Request**: Empty body (or may need subscription details)
- **Response**: 
  ```json
  {
    "success": true,
    "clientSecret": "seti_xxx_secret_xxx",
    "customerId": "cus_xxx"
  }
  ```

### 3. Create Stripe Subscription
- **Endpoint**: `POST /api/stripe/create-subscription`
- **Purpose**: Create subscription with payment method
- **Request**:
  ```json
  {
    "stripe_payment_method_id": "pm_xxx",
    "payment_method": "pm_xxx"
  }
  ```
- **Response**: Subscription status and client_secret if SCA required

### 4. Save Payment Information
- **Endpoint**: `POST /api/signup-savePaymentInformation`
- **Purpose**: Save payment details after successful payment
- **Request Type**: `multipart/form-data`
- **Fields**:
  - `payment_method`: "Bank Transfer" | "Stripe" | "Paypal"
  - `reference_number`: Required only for Bank Transfer
  - `payment_receipt_image`: File (Required only for Bank Transfer)
  - `stripe_payment_method_id`: Required only for Stripe

---

## 🔧 Implementation Plan

### Phase 1: Setup & Dependencies
1. **Install Stripe Flutter SDK**
   - Package: `flutter_stripe` (latest version)
   - Add to `pubspec.yaml`
   - Configure Stripe publishable key

2. **Add Multipart Support to NetworkClient**
   - Add `postMultipart()` method
   - Support file uploads for payment receipts
   - Handle form-data encoding

### Phase 2: API Integration
3. **Add API Endpoints**
   - `getStripeCreateSubscriptionUrl()` - For SetupIntent
   - `getStripeCreateSubscriptionWithPaymentMethodUrl()` - For subscription creation
   - `getSavePaymentInformationUrl()` - For saving payment info

4. **Create Payment Models**
   - `StripeSetupIntentRequest`
   - `StripeSetupIntentResponse`
   - `StripeCreateSubscriptionRequest`
   - `StripeCreateSubscriptionResponse`
   - `SavePaymentInformationRequest` (with file support)

5. **Add Repository Methods**
   - `createStripeSetupIntent()`
   - `createStripeSubscription()`
   - `savePaymentInformation()` (with multipart support)

### Phase 3: UI Integration
6. **Update PaymentMethodPage**
   - Integrate Stripe `CardField` widget
   - Add payment method selection logic
   - Implement payment flow:
     a. Get SetupIntent
     b. Show CardField
     c. Confirm SetupIntent
     d. Create Subscription
     e. Handle SCA if needed
     f. Save Payment Information

7. **Add Bank Transfer Support**
   - Add reference number input
   - Add receipt image picker
   - Upload receipt with payment info

8. **Add PayPal Support**
   - Handle PayPal payment flow (if needed)

### Phase 4: Error Handling & Edge Cases
9. **Handle Payment Errors**
   - Network errors
   - Card errors
   - SCA (Strong Customer Authentication) flow
   - Payment failures

10. **Testing**
    - Test Stripe payment flow
    - Test Bank Transfer with receipt upload
    - Test error scenarios
    - Verify payment info is saved correctly

---

## 📦 Required Packages

```yaml
dependencies:
  flutter_stripe: ^11.0.0  # Stripe Flutter SDK
  # http: ^1.1.0  # Already installed
  # image_picker: ^1.0.4  # Already installed
```

---

## 🔄 Payment Flow Diagram

```
User selects paid subscription
    ↓
Save Optional Paid Services (✅ Already done)
    ↓
Navigate to PaymentMethodPage
    ↓
User selects payment method:
    ├─ Credit/Debit Card (Stripe)
    │   ├─ Get SetupIntent from API
    │   ├─ Show Stripe CardField
    │   ├─ Confirm SetupIntent
    │   ├─ Create Subscription with payment_method_id
    │   ├─ Handle SCA if required
    │   └─ Save Payment Information
    │
    ├─ Bank Transfer
    │   ├─ Enter reference number
    │   ├─ Upload payment receipt image
    │   └─ Save Payment Information (form-data)
    │
    └─ PayPal
        └─ Handle PayPal flow (if needed)
```

---

## 🎨 UI Changes Required

### PaymentMethodPage Updates
1. **Stripe CardField Integration**
   - Replace manual card input with Stripe CardField
   - Add loading states during payment processing
   - Show SCA modal if required

2. **Bank Transfer Section**
   - Add reference number TextField
   - Add image picker for receipt
   - Show selected image preview

3. **Payment Status**
   - Show real-time payment status
   - Handle success/error states
   - Navigate to dashboard on success

---

## 🔐 Security Considerations

1. **Stripe Keys**
   - Store publishable key in app config
   - Never expose secret key in client
   - Use environment variables for different environments

2. **Payment Data**
   - Never store card details locally
   - Use Stripe's secure card collection
   - Handle PCI compliance through Stripe

3. **Receipt Images**
   - Validate file size and type
   - Compress images before upload
   - Secure file upload endpoint

---

## 📝 Notes

1. **SetupIntent Flow**: The API returns a SetupIntent client_secret which is used to collect card details securely. After confirming the SetupIntent, we get a payment_method_id that can be used to create subscriptions.

2. **SCA (Strong Customer Authentication)**: Some payments may require additional authentication. Stripe handles this automatically, but we need to handle the `handleCardAction` flow if the API returns a client_secret for the invoice's PaymentIntent.

3. **Bank Transfer**: Requires manual receipt upload. The receipt image must be uploaded as multipart/form-data along with the reference number.

4. **Payment Method Confusion**: The API uses `payment_method` field which can be confusing with Stripe's `payment_method_id`. Based on the image, it seems `payment_method` is the type ("Bank Transfer", "Stripe", "Paypal") and `stripe_payment_method_id` is the actual Stripe payment method ID.

---

## ✅ Success Criteria

- [ ] User can select paid subscription services
- [ ] User can pay via Stripe (Credit/Debit Card)
- [ ] User can pay via Bank Transfer with receipt upload
- [ ] Payment information is saved correctly
- [ ] SCA flow works if required
- [ ] Error handling is comprehensive
- [ ] User is redirected to dashboard after successful payment

