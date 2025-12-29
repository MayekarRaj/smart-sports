# iOS Signing & IPA Build Setup Guide

## Understanding the iOS Build Process

To build an IPA file, you need:
1. **Apple Developer Account** - You have this (team: JVBN8WTNY9)
2. **App ID** - A registered bundle identifier in Apple Developer Portal
3. **Provisioning Profile** - Links your App ID to your development/distribution certificate
4. **Signing Certificate** - Proves you're authorized to sign the app

## Current Configuration

- **Bundle Identifier**: `com.courtreserve.sekai_ichi`
- **Team ID**: `JVBN8WTNY9`
- **Signing Style**: Automatic

## The Problem

The error occurs because:
- Xcode is trying to automatically create a provisioning profile
- But the bundle identifier `com.courtreserve.sekai_ichi` is **not registered as an App ID** in your team's Apple Developer account
- Without an App ID, Xcode cannot create a provisioning profile

## Solution: Register the App ID

### Step 1: Access Apple Developer Portal

1. Go to [developer.apple.com/account](https://developer.apple.com/account/)
2. Sign in with your Apple ID that's part of team `JVBN8WTNY9`
3. Make sure you have the right permissions (see Step 2)

### Step 2: Check Your Team Permissions

You need one of these roles to create App IDs:
- **Account Holder** (full access)
- **Admin** (can create App IDs)
- **App Manager** (can create App IDs)

If you don't have these permissions:
- Ask your team admin to create the App ID for you, OR
- Ask them to grant you Admin/App Manager role

### Step 3: Create the App ID

1. In Apple Developer Portal, go to **Certificates, Identifiers & Profiles**
2. Click on **Identifiers** in the left sidebar
3. Click the **+** button (top left) to create a new identifier
4. Select **App IDs** and click **Continue**
5. Select **App** and click **Continue**
6. Fill in:
   - **Description**: `Smart Sports` (or any name you prefer)
   - **Bundle ID**: Select **Explicit** and enter: `com.courtreserve.sekai_ichi`
7. Under **Capabilities**, select any features you need (Push Notifications, In-App Purchase, etc.)
   - For basic apps, you can leave everything unchecked
8. Click **Continue** and then **Register**

### Step 4: Verify in Xcode

1. Open your project in Xcode
2. Go to **Signing & Capabilities** tab
3. Make sure:
   - ✅ "Automatically manage signing" is checked
   - ✅ Your team is selected: **Raj Mayekar (Personal Team)** or the team name
   - ✅ Bundle Identifier shows: `com.courtreserve.sekai_ichi`
4. Xcode should now automatically:
   - Find the App ID
   - Create a provisioning profile
   - Show green checkmarks ✅

### Step 5: Build the IPA

Once signing is successful:

1. In Xcode, select **Product → Archive**
   - Make sure you select **Any iOS Device** (not a simulator) from the device dropdown
2. Wait for the archive to complete
3. In the **Organizer** window that opens:
   - Select your archive
   - Click **Distribute App**
4. Choose distribution method:
   - **App Store Connect** - For App Store submission
   - **Ad Hoc** - For testing on specific devices
   - **Enterprise** - For enterprise distribution
   - **Development** - For development builds
5. Follow the prompts to export your IPA

## Alternative: Use Flutter Build Command

You can also build the IPA using Flutter CLI:

```bash
# For development build
flutter build ipa --release

# For App Store build
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

## Troubleshooting

### Error: "No profiles for 'com.courtreserve.sekai_ichi' were found"
- **Solution**: The App ID doesn't exist. Follow Step 3 above.

### Error: "An attribute in the provided entity has invalid value"
- **Solution**: This happens when Xcode tries to create a profile name with spaces. After creating the App ID, clean and rebuild:
  ```bash
  flutter clean
  rm -rf ~/Library/Developer/Xcode/DerivedData
  ```
  Then reopen Xcode and try again.

### Error: "You don't have permission to create App IDs"
- **Solution**: Ask your team admin to:
  1. Create the App ID for you, OR
  2. Grant you Admin or App Manager role

### Error: "Team not found" or "Invalid team"
- **Solution**: 
  1. Make sure you're signed in with the correct Apple ID
  2. Verify you're part of team `JVBN8WTNY9`
  3. In Xcode: **Xcode → Settings → Accounts**, add/verify your Apple ID

## Quick Checklist

- [ ] I have access to Apple Developer Portal
- [ ] I can see team `JVBN8WTNY9` in the portal
- [ ] I have Admin/App Manager permissions (or someone can create App ID for me)
- [ ] App ID `com.courtreserve.sekai_ichi` is registered in the portal
- [ ] Xcode shows green checkmarks in Signing & Capabilities
- [ ] I can successfully archive the app
- [ ] IPA file is generated

## Need Help?

If you're still stuck:
1. Check what role you have in the team (Account Holder, Admin, App Manager, Developer, or Member)
2. If you're Developer or Member, you'll need someone with higher permissions to create the App ID
3. Share the specific error message you're seeing for more targeted help

