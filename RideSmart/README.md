# RideSmart

RideSmart is an Android MVP demonstrating crash detection, eco tracking, community hazard reporting, and Firebase authentication. The project is implemented in Java using MVVM, Hilt, Room, WorkManager, and the Navigation component.

## Getting started
1. Install Android Studio Giraffe or newer with the Android SDK 34 platform.
2. Copy your Firebase configuration into `app/google-services.json` and ensure the Firebase project has Auth, Firestore, and Realtime Database enabled.
3. Open the `RideSmart` folder in Android Studio and let Gradle sync.
4. Provide the required runtime permissions (location, sensors, SMS) when prompted.

## Modules
- **Crash Detection Service** – foreground service listening to accelerometer/gyroscope sensors and sending emergency SMS if not cancelled within 30 seconds.
- **Eco Tracker** – uses fused location updates to monitor ride distance, speed, and compute an eco score stored in Room.
- **Community Hazard Map** – Google Maps integration for reporting hazards, persisting to Firebase Realtime Database, and caching with Room.
- **Authentication** – Firebase email/password login with Firestore profile onboarding.
- **Offline Sync** – Room-backed caches and WorkManager driven uploads when connectivity returns.

## Notes
- Replace the placeholder emergency phone number in `CrashDetectionService` with the contact stored in Firestore for production usage.
- The lightweight `gradlew` script expects a system `gradle` command. Install Gradle 8.2.1+ or update the script if you prefer the standard wrapper.
