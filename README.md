# Mood Tracker App

A Flutter-based mood tracking application with Firebase authentication and Firestore database integration. Users can log their daily moods, view their mood history, and gain insights into their emotional patterns.

## Features

### 1. Authentication (Firebase Auth)
- **Email/Password Authentication**: Users can sign up and log in using their email and password
- **Secure User Data**: Each user's mood data is stored under their unique Firebase UID
- **Auto-login**: App remembers user authentication state across sessions
- **Logout Functionality**: Users can securely log out from the app

### 2. Daily Mood Logging (Firestore)
- **Mood Selection**: Users can select from four mood types:
  - Happy (Green)
  - Sad (Blue) 
  - Angry (Red)
  - Neutral (Grey)
- **Optional Notes**: Users can add text notes to describe their day
- **One Entry Per Day**: System validates and prevents multiple entries for the same day
- **Real-time Sync**: Data is immediately synced to Firestore

### 3. Mood History Screen
- **7-Day History**: Displays mood entries from the past 7 days
- **Color-Coded Display**: Each mood is represented with its corresponding color
- **Chronological Order**: Entries are sorted by date (most recent first)
- **Note Editing**: Users can edit notes for existing entries (mood cannot be changed)
- **Visual Indicators**: Circle avatars show mood type with first letter

### 4. Mood Insights Screen
- **Most Frequent Mood**: Calculates and displays the most common mood in the past 7 days
- **Happy Days Percentage**: Shows percentage of days marked as "Happy"
- **Longest Streak**: Identifies the longest consecutive streak of the same mood
- **Real-time Updates**: Insights update automatically as new mood data is added

## Firebase Structure

```
users (collection)
├── [UID] (document)
    └── moods (subcollection)
        ├── 2024-01-15 (document)
        │   ├── mood: "Happy"
        │   ├── note: "Had a great day at work!"
        │   └── timestamp: [ServerTimestamp]
        ├── 2024-01-16 (document)
        │   ├── mood: "Sad"
        │   ├── note: "Feeling down today"
        │   └── timestamp: [ServerTimestamp]
        └── ...
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Firebase project with Authentication and Firestore enabled
- Android Studio / VS Code with Flutter extensions

### Firebase Configuration

1. **Create a Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing one
   - Enable Authentication (Email/Password provider)
   - Enable Firestore Database

2. **Add Firebase Configuration Files**:
   - Download `google-services.json` and place it in `android/app/`
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`

3. **Firestore Security Rules**:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/moods/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd mood_tracker
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── screens/                     # UI screens
│   ├── auth_wrapper.dart       # Authentication state management
│   ├── login_screen.dart       # Login/signup screen
│   ├── home_screen.dart        # Main navigation screen
│   ├── mood_log_screen.dart    # Daily mood logging
│   ├── mood_history_screen.dart # 7-day mood history
│   └── mood_insights_screen.dart # Mood analytics
├── services/                    # Business logic
│   └── insights_service.dart   # Mood insights calculations
└── utils/                      # Shared utilities
    └── mood_colors.dart        # Mood color constants
```

## Architecture & Logic

### Authentication Flow
- `AuthWrapper` listens to Firebase Auth state changes
- Automatically redirects users between login and home screens
- Maintains authentication state across app restarts

### Data Management
- **Document ID Strategy**: Uses date format (YYYY-MM-DD) as document ID for easy querying
- **Real-time Updates**: Uses Firestore streams for live data updates
- **Offline Support**: Firestore provides automatic offline caching

### UI/UX Design
- **Bottom Navigation**: Three main screens accessible via bottom navigation
- **Material Design**: Follows Material Design principles for consistent UI
- **Color Coding**: Visual mood representation using consistent color scheme
- **Responsive Layout**: Adapts to different screen sizes

### Insights Calculation
- **Most Frequent Mood**: Uses frequency counting algorithm
- **Happy Percentage**: Calculates ratio of happy days to total days
- **Longest Streak**: Implements streak detection algorithm for consecutive same moods

## Trade-offs & Design Decisions

### 1. Document Structure
**Decision**: Use date (YYYY-MM-DD) as document ID
- **Pros**: Easy querying, prevents duplicates, human-readable
- **Cons**: Limited to one entry per day, timezone considerations

### 2. Mood Categories
**Decision**: Limited to 4 basic moods (Happy, Sad, Angry, Neutral)
- **Pros**: Simple UI, easy analytics, clear categorization
- **Cons**: May not capture nuanced emotions, limited granularity

### 3. History Timeframe
**Decision**: 7-day history window
- **Pros**: Relevant recent data, good performance, manageable UI
- **Cons**: Limited historical view, may miss longer-term patterns

### 4. Note Editing Restrictions
**Decision**: Allow note editing but not mood editing
- **Pros**: Maintains data integrity, prevents mood manipulation
- **Cons**: Less flexibility if user made genuine mistake

### 5. Real-time vs Cached Data
**Decision**: Use Firestore streams for real-time updates
- **Pros**: Always current data, automatic sync, offline support
- **Cons**: More network usage, potential performance impact

### 6. Authentication Method
**Decision**: Email/Password only
- **Pros**: Simple implementation, no external dependencies
- **Cons**: Less convenient than social login, password management burden

## Dependencies

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  firebase_core: ^2.24.2      # Firebase initialization
  firebase_auth: ^4.15.3      # Authentication
  cloud_firestore: ^4.13.6    # Database
  intl: ^0.19.0               # Date formatting
```

## Future Enhancements

1. **Extended Mood Range**: Add more mood categories and intensity levels
2. **Data Export**: Allow users to export their mood data
3. **Mood Trends**: Add charts and graphs for better visualization
4. **Reminders**: Push notifications to remind users to log their mood
5. **Social Features**: Share insights with friends or family
6. **Mood Triggers**: Track what influences mood changes
7. **Longer History**: Extend beyond 7 days with pagination
8. **Dark Mode**: Add theme switching capability

## Testing

The app includes basic widget tests. To run tests:

```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.