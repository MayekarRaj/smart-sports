# Stripe Payment API Flow

## 📋 When to Call Each API

### 1. **SetupIntent API** (`POST /api/stripe/create-subscription` with empty body)

**When to call:**
- ✅ **BEFORE** user enters card details
- ✅ When user selects "Credit/Debit Card" payment method
- ✅ On the **Payment Method Page** (first screen)

**Purpose:**
- Get `clientSecret` for securely collecting card details
- Create Stripe Customer (if not exists)
- Prepare for card collection

**Current Implementation:**
- Called when user clicks "Continue" (optional)
- If it fails, we proceed without it (CardField can work without SetupIntent)

**Recommended Flow:**
```dart
// On Payment Method Page, when user selects Credit Card:
1. User selects "Credit/Debit Card"
2. Call SetupIntent API (optional, but recommended)
3. Show CardField to collect card details
4. User enters card details
5. User clicks "Continue" → Navigate to Confirmation Page
```

---

### 2. **Create Subscription API** (`POST /api/stripe/create-subscription` with payment_method)

**When to call:**
- ✅ **AFTER** user has entered card details
- ✅ **AFTER** PaymentMethod is created from card details
- ✅ On the **Payment Confirmation Page** (second screen)
- ✅ When user clicks "PAY NOW"

**Purpose:**
- Create subscription with the payment method
- Attach payment method to customer
- Set up recurring billing

**Current Implementation:**
- Called in `_processStripePayment()` on Payment Confirmation Page
- After creating PaymentMethod from CardField details

**Recommended Flow:**
```dart
// On Payment Confirmation Page, when user clicks "PAY NOW":
1. User reviews payment details
2. User clicks "PAY NOW"
3. Create PaymentMethod from CardField details
4. Call Create Subscription API with payment_method_id
5. Handle SCA if required (clientSecret returned)
6. Save payment information
7. Show success
```

---

## 🔄 Complete Payment Flow

### **Screen 1: Payment Method Page**

```
User selects "Credit/Debit Card"
    ↓
[OPTIONAL] Call SetupIntent API
    ↓
Show CardField (collects card details)
    ↓
User enters card details
    ↓
User clicks "Continue"
    ↓
Validate card details
    ↓
Navigate to Confirmation Page
```

### **Screen 2: Payment Confirmation Page**

```
User reviews payment details
    ↓
User clicks "PAY NOW"
    ↓
Create PaymentMethod from CardField
    ↓
Call Create Subscription API
    ↓
Handle SCA if required
    ↓
Save Payment Information
    ↓
Show Success Dialog
```

---

## ⚠️ Important Notes

### SetupIntent is Optional
- **CardField can work without SetupIntent** - it can collect card details directly
- SetupIntent is mainly useful for:
  - Saving payment methods for future use
  - Better security/SCA handling
  - Customer creation on backend

### Current Issue
- Backend requires `payment_method` field even for SetupIntent
- This suggests the API might need subscription details upfront
- **Solution**: Make SetupIntent optional, proceed without it if it fails

### Recommended Approach

**Option 1: Skip SetupIntent (Current)**
- Use CardField directly
- Create PaymentMethod when processing payment
- Simpler flow, works for immediate subscriptions

**Option 2: Use SetupIntent Properly**
- Call SetupIntent when user selects credit card
- Confirm SetupIntent after card entry
- Then create subscription
- Better for saving cards for future use

---

## 🎯 Current Implementation Status

### ✅ What's Working:
1. CardField displays without SetupIntent
2. PaymentMethod created from CardField
3. Create Subscription called with payment method
4. Payment information saved

### ⚠️ What Needs Fixing:
1. SetupIntent API call fails (backend expects payment_method)
2. SetupIntent not being used properly (if we get it)
3. SCA handling incomplete

---

## 💡 Recommendation

**For immediate subscription creation:**
- **Skip SetupIntent** (current approach is fine)
- Create PaymentMethod directly from CardField
- Call Create Subscription API with payment method
- This works for one-time or immediate subscriptions

**For saving cards for future use:**
- Call SetupIntent when user selects credit card
- Confirm SetupIntent after card entry
- Then create subscription
- This allows saving payment methods for recurring use

