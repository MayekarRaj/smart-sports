# Stripe Test Card Numbers

Use these test card numbers to test your payment integration. These are Stripe's official test cards that work in test mode.

## ✅ Successful Payment Cards

### Visa (Most Common)
- **Card Number**: `4242 4242 4242 4242`
- **Expiry Date**: Any future date (e.g., `12/25`, `12/30`)
- **CVV**: Any 3 digits (e.g., `123`, `456`)
- **ZIP Code**: Any 5 digits (e.g., `12345`)

### Visa (Debit)
- **Card Number**: `4000 0566 5566 5556`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits

### Mastercard
- **Card Number**: `5555 5555 5555 4444`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits

### American Express
- **Card Number**: `3782 822463 10005`
- **Expiry Date**: Any future date
- **CVV**: Any 4 digits (e.g., `1234`)

### Discover
- **Card Number**: `6011 1111 1111 1117`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits

---

## ❌ Declined Cards (For Testing Errors)

### Card Declined (Generic)
- **Card Number**: `4000 0000 0000 0002`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits
- **Result**: Generic decline

### Insufficient Funds
- **Card Number**: `4000 0000 0000 9995`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits
- **Result**: Insufficient funds error

### Lost Card
- **Card Number**: `4000 0000 0000 9987`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits
- **Result**: Lost card error

### Stolen Card
- **Card Number**: `4000 0000 0000 9979`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits
- **Result**: Stolen card error

---

## 🔐 3D Secure (SCA) Testing

### Requires Authentication (3D Secure)
- **Card Number**: `4000 0025 0000 3155`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits
- **Result**: Will trigger 3D Secure authentication

### 3D Secure Authentication Failed
- **Card Number**: `4000 0000 0000 3055`
- **Expiry Date**: Any future date
- **CVV**: Any 3 digits
- **Result**: 3D Secure authentication will fail

---

## 📝 Quick Test Examples

### Example 1: Successful Visa Payment
```
Card Number: 4242 4242 4242 4242
Expiry Date: 12/25
CVV: 123
Name: John Doe
```

### Example 2: Successful Mastercard Payment
```
Card Number: 5555 5555 5555 4444
Expiry Date: 06/26
CVV: 456
Name: Jane Smith
```

### Example 3: 3D Secure Required
```
Card Number: 4000 0025 0000 3155
Expiry Date: 12/25
CVV: 789
Name: Test User
```

### Example 4: Card Declined
```
Card Number: 4000 0000 0000 0002
Expiry Date: 12/25
CVV: 123
Name: Test User
```

---

## ⚠️ Important Notes

1. **Test Mode Only**: These cards only work when your Stripe account is in **test mode** (using `pk_test_...` keys)

2. **Any Future Date**: For expiry date, use any date in the future:
   - `12/25` (December 2025)
   - `06/30` (June 2030)
   - `01/26` (January 2026)
   - etc.

3. **Any CVV**: Use any 3-4 digit number:
   - Visa/Mastercard: 3 digits (e.g., `123`, `456`, `789`)
   - American Express: 4 digits (e.g., `1234`, `5678`)

4. **Any Name**: Use any name on the card (e.g., "John Doe", "Test User")

5. **ZIP Code**: If required, use any 5-digit number (e.g., `12345`, `90210`)

---

## 🎯 Recommended Test Flow

1. **Test Successful Payment**:
   - Use: `4242 4242 4242 4242`
   - Should complete successfully

2. **Test 3D Secure**:
   - Use: `4000 0025 0000 3155`
   - Should trigger authentication

3. **Test Error Handling**:
   - Use: `4000 0000 0000 0002`
   - Should show decline error

---

## 📚 Official Stripe Documentation

For more test cards and scenarios, visit:
https://stripe.com/docs/testing

