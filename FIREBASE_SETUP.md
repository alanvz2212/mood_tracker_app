# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `mood-tracker` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Authentication

1. In Firebase Console, go to "Authentication" → "Sign-in method"
2. Click on "Email/Password"
3. Enable "Email/Password" provider
4. Click "Save"

## Step 3: Enable Firestore Database

1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (we'll add security rules later)
4. Select a location closest to your users
5. Click "Done"

## Step 4: Add Android App

1. Click "Project Overview" → "Add app" → Android icon
2. Enter package name: `com.example.mood_tracker`
3. Enter app nickname: `Mood Tracker`
4. Click "Register app"
5. Download `google-services.json`
6. Place the file in `android/app/` directory

## Step 5: Add iOS App (Optional)

1. Click "Add app" → iOS icon
2. Enter bundle ID: `com.example.moodTracker`
3. Enter app nickname: `Mood Tracker`
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Place the file in `ios/Runner/` directory

## Step 6: Configure Firestore Security Rules

1. Go to "Firestore Database" → "Rules"
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write only their own mood data
    match /users/{userId}/moods/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. Click "Publish"

## Step 7: Test the Setup

1. Run the app: `flutter run`
2. Create a new account with email/password
3. Log a mood entry
4. Check Firestore Console to see the data structure

## Firestore Data Structure

After logging moods, you should see this structure in Firestore:

```
users/
  └── [user-uid]/
      └── moods/
          ├── 2024-01-15/
          │   ├── mood: "Happy"
          │   ├── note: "Great day!"
          │   └── timestamp: [timestamp]
          └── 2024-01-16/
              ├── mood: "Sad"
              ├── note: "Tough day"
              └── timestamp: [timestamp]
```

## Troubleshooting

### Common Issues:

1. **"No Firebase App '[DEFAULT]' has been created"**
   - Ensure `google-services.json` is in `android/app/`
   - Run `flutter clean` and `flutter pub get`

2. **Authentication not working**
   - Check if Email/Password provider is enabled
   - Verify app package name matches Firebase configuration

3. **Firestore permission denied**
   - Ensure security rules are properly configured
   - Check if user is authenticated before accessing Firestore

4. **Build errors on Android**
   - Ensure `google-services.json` is in the correct location
   - Check if Google Services plugin is applied in `android/app/build.gradle`

### Useful Commands:

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check Firebase configuration
flutter packages pub run firebase_core:configure
```

## Security Best Practices

1. **Never commit Firebase config files to public repositories**
2. **Use environment-specific projects** (dev, staging, prod)
3. **Regularly review Firestore security rules**
4. **Enable App Check** for production apps
5. **Monitor usage** in Firebase Console

## Next Steps

After setup is complete:
1. Test all app features (login, mood logging, history, insights)
2. Add more comprehensive security rules if needed
3. Set up Firebase Analytics for usage tracking
4. Configure Firebase Performance Monitoring
5. Set up Cloud Functions for advanced features