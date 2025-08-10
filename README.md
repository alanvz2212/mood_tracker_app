<<<<<<< HEAD
# 📊 Mood Tracker App

A simple **Flutter** app to track daily moods with **Firebase Authentication** and **Cloud Firestore**.

---

## ✨ Features
- Email/Password login & signup (Firebase Auth)
- Log one mood per day (Happy, Sad, Angry, Neutral)
- Add optional daily notes
- View past 7 days of mood history
- See insights: most frequent mood, happy percentage, longest streak
- Real-time sync with Firestore

---

## 🗄 Firebase Setup
1. Create a Firebase project  
2. Enable **Email/Password Auth**  
3. Enable **Cloud Firestore**  
4. Download config files:  
   - `google-services.json` → `android/app/`  
   - `GoogleService-Info.plist` → `ios/Runner/`  
5. Firestore Rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/moods/{doc=**} {
         allow read, write: if request.auth.uid == userId;
       }
     }
   }
⚙️ Installation

git clone <repo-url>
cd mood_tracker
flutter pub get
flutter run

📂 Project Structure

lib/
├── main.dart
├── screens/        # App screens
├── services/       # Insights logic
└── utils/  
=======
# mood_tracker_app
>>>>>>> d79545c8a89b65a20c709cadb7c0e5b0b54bcbdc
