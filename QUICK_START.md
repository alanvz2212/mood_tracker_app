# Quick Start Guide

## Prerequisites
- Flutter SDK installed
- Firebase project configured (see FIREBASE_SETUP.md)

## Run the App

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run on device/emulator**:
   ```bash
   flutter run
   ```

3. **For web (if configured)**:
   ```bash
   flutter run -d chrome
   ```

## First Time Usage

1. **Create Account**:
   - Open the app
   - Tap "Don't have an account? Sign up"
   - Enter email and password
   - Tap "Sign Up"

2. **Log Your First Mood**:
   - Select a mood (Happy, Sad, Angry, or Neutral)
   - Add optional notes
   - Tap "Save Mood"

3. **View History**:
   - Tap "History" in bottom navigation
   - See your mood entries from the past 7 days

4. **Check Insights**:
   - Tap "Insights" in bottom navigation
   - View statistics about your mood patterns

## App Structure

```
lib/
├── main.dart           # Main app entry point with all screens
├── (All code is in main.dart for simplicity)

Key Components:
├── MyApp              # Root app widget
├── AuthWrapper        # Handles authentication state
├── LoginScreen        # Email/password authentication
├── HomeScreen         # Main navigation with bottom tabs
├── MoodLogScreen      # Daily mood logging
├── MoodHistoryScreen  # 7-day mood history
└── MoodInsightsScreen # Mood analytics and insights
```

## Features Overview

### 🔐 Authentication
- Email/password signup and login
- Secure user data isolation
- Automatic session management

### 📝 Mood Logging
- 4 mood types with color coding
- Optional daily notes
- One entry per day validation

### 📊 History & Insights
- 7-day mood history
- Editable notes
- Mood frequency analysis
- Happy days percentage
- Longest mood streaks

## Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase errors?
- Check `google-services.json` is in `android/app/`
- Verify Firebase project configuration
- See FIREBASE_SETUP.md for detailed setup

### Build issues?
```bash
flutter doctor
```

## Testing

Run tests:
```bash
flutter test
```

## Building for Release

### Android APK:
```bash
flutter build apk --release
```

### iOS (requires Mac):
```bash
flutter build ios --release
```

## Next Steps

1. Complete Firebase setup (see FIREBASE_SETUP.md)
2. Test all features
3. Customize UI colors/themes if desired
4. Add additional features as needed

Happy mood tracking! 😊