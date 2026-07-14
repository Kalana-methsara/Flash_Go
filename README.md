# ⚡ Flash Go

**Fastest Campus Errand Network** — a Flutter app that lets students on campus request and fulfil errands for each other in real time (grabbing food, photocopying, dropping off items, and more).

---

## 📱 Overview

Flash Go is a peer-to-peer errand marketplace built for campus communities. A student posts an errand ("order"), and a nearby student ("Runner") accepts it, picks up the item from the pickup location, delivers it to the drop location, and can chat live with the requester throughout the process.

---

## ✨ Features

- 🔐 **Authentication** — Email/Password login and registration via Firebase Auth
- 📝 **Create Order** — Post an errand with a title, description, pickup/drop location (picked from a map), and tip amount
- 🔥 **Campus Pool** — Browse currently pending errands in a real-time stream and accept one
- 🚴 **Active Orders / Tracking** — Track orders you're involved in, either as a requester or a runner
- 🗺️ **Map Integration** — A Google Maps-based location picker for pickup/drop points, plus an Order Map screen showing the route
- 💬 **Live Chat** — Real-time chat between the requester and runner for each order (Cloud Firestore streams)
- 🔔 **Push Notifications** — Notifications for order status changes (accepted/picked up/delivered) and chat messages, via Firebase Cloud Messaging + Cloud Functions
- 🌗 **Dark Mode** — App-wide light/dark theme toggle (Provider state management)
- 👤 **Profile Management** — View user details, logout

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Backend | Firebase (Auth, Cloud Firestore, Cloud Messaging, Cloud Functions) |
| State Management | Provider |
| Maps | `google_maps_flutter`, `geolocator` |
| Notifications | `firebase_messaging`, `flutter_local_notifications` |
| Server Functions | Node.js (Firebase Cloud Functions, 2nd Gen) |

---

## 📂 Project Structure

```
lib/
├── main.dart                     # App entry point, Firebase init, theme setup
├── firebase_options.dart         # FlutterFire CLI generated config
├── theme_provider.dart           # Dark/Light mode state (Provider)
├── services/
│   └── notification_service.dart # FCM token handling, local notifications
└── screens/
    ├── login_page.dart
    ├── register_page.dart
    ├── main_dashboard.dart        # Bottom nav shell (4 tabs)
    ├── create_order_screen.dart   # Post a new errand
    ├── campus_pool_screen.dart    # Browse & accept pending errands
    ├── active_orders_screen.dart  # My orders (as requester or runner)
    ├── order_status_screen.dart   # Order tracking + stepper
    ├── order_map_screen.dart      # Pickup/drop map with route
    ├── location_picker_screen.dart# Map-based location picker
    ├── chat_screen.dart           # Real-time order chat
    └── profile_screen.dart        # User profile & settings

functions/
├── index.js                      # Cloud Functions (push notification triggers)
└── package.json
```

---

## 🔥 Firestore Data Structure

```
users/{uid}
  - name, email, phone
  - rating, isAvailableAsRunner
  - fcmToken, tokenUpdatedAt

orders/{orderId}
  - requesterId, runnerId
  - title, description
  - pickupLocation: { name, latitude, longitude }
  - dropLocation:   { name, latitude, longitude }
  - tipAmount, status (PENDING → ACCEPTED → PICKED_UP → DELIVERED)
  - createdAt

orders/{orderId}/chats/{messageId}
  - senderId, text, timestamp
```

---

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK (stable channel)
- Xcode (for iOS builds) / Android Studio (for Android builds)
- A Firebase project with Auth, Firestore, and Cloud Messaging enabled
- A Google Cloud API key with **Maps SDK for Android** and **Maps SDK for iOS** enabled

### 2. Clone & install
```bash
git clone <your-repo-url>
cd flash_go
flutter pub get
```

### 3. Firebase setup
```bash
flutterfire configure
```
This will auto-generate `firebase_options.dart`. Make sure Authentication (Email/Password) and Firestore are enabled in the Firebase Console.

### 4. Google Maps API key
- **Android** — inside the `<application>` tag in `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY"/>
  ```
- **iOS** — in `ios/Runner/AppDelegate.swift`:
  ```swift
  import GoogleMaps
  GMSServices.provideAPIKey("YOUR_API_KEY")
  ```

### 5. iOS permissions
Make sure `ios/Runner/Info.plist` contains the location and push notification keys (`NSLocationWhenInUseUsageDescription`, `UIBackgroundModes`).

### 6. Cloud Functions (push notifications)
```bash
firebase init functions   # use the existing functions/ folder
cd functions && npm install
firebase deploy --only functions
```
⚠️ Cloud Functions require your Firebase project to be on the **Blaze (pay-as-you-go)** plan.

### 7. Run
```bash
flutter run
```
> 📌 Test push notifications on a physical device — the iOS Simulator cannot receive a real APNs token.

---

## 🗺️ Roadmap / Known Limitations

- [ ] The route line is currently a straight line — could integrate the Google Directions API to show an actual road route
- [ ] No in-app rating/review system yet
- [ ] No payment gateway integration (errands are currently cash-on-delivery)
- [ ] No order cancellation flow

---

## 📄 License

This project is for educational purposes as part of a campus community application.