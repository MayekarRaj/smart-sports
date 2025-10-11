# iOS Build and Distribution Fix Guide

## Problem
Error: "There's been an error parsing your app's provisioning profile. Ensure you are uploading a validly signed IPA and try again."

## Solution Steps

### 1. Apple Developer Account Setup
1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Ensure your account is active and paid
3. Register your app's Bundle ID if not already done

### 2. Certificate and Provisioning Profile
1. Navigate to "Certificates, Identifiers & Profiles"
2. Create/update your App ID with the correct Bundle ID
3. Create/update your Provisioning Profile for Distribution
4. Download the latest provisioning profile
5. Install it in Xcode

### 3. Xcode Project Configuration
1. Open your project in Xcode
2. Select your project in the navigator
3. Go to "Signing & Capabilities" tab
4. Ensure "Automatically manage signing" is checked OR
5. Manually select the correct provisioning profile and certificate

### 4. Build Configuration
1. Set the build configuration to "Release"
2. Set the deployment target to match your provisioning profile
3. Ensure the Bundle Identifier matches your Apple Developer account

### 5. Build and Archive
1. In Xcode, go to Product → Archive
2. Wait for the build to complete
3. In the Organizer, select your archive
4. Click "Distribute App"
5. Choose "Ad Hoc" or "Enterprise" distribution
6. Select your provisioning profile
7. Export the IPA file

### 6. Verify the IPA
1. Check that the IPA is properly signed
2. Verify the provisioning profile is embedded
3. Test the IPA on a device before uploading

### 7. Upload to Distribution Platform
1. Use the newly created IPA file
2. Ensure it's properly signed with the correct provisioning profile
3. Upload to your distribution platform

## Common Issues and Solutions

### Issue: "Provisioning profile doesn't match"
**Solution:** Ensure the Bundle ID in your Xcode project exactly matches the one in your provisioning profile.

### Issue: "Certificate not found"
**Solution:** Download and install the correct certificate from Apple Developer Portal.

### Issue: "Provisioning profile expired"
**Solution:** Create a new provisioning profile in Apple Developer Portal.

### Issue: "Device not included in provisioning profile"
**Solution:** Add the device UDID to your provisioning profile or use a wildcard provisioning profile.

## Verification Commands (if using macOS)
```bash
# Check if IPA is properly signed
codesign -dv --verbose=4 YourApp.ipa

# Verify provisioning profile
security cms -D -i embedded.mobileprovision
```

## Alternative: Use Xcode Cloud or CI/CD
If you continue having issues, consider using:
- Xcode Cloud for automated builds
- GitHub Actions with macOS runners
- Other CI/CD services that support iOS builds