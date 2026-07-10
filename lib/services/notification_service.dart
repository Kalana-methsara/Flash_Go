import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 💡 මේක top-level function එකක් විදිහට තියෙන්න ඕන (class එකෙන් පිටත) - 
// app එක background/terminated state එකේ ඉන්නකොට message එකක් ආවම Flutter engine එක 
// මේ function එකම call කරන්නේ, ඒක නිසා @pragma annotation එකත් අනිවාර්යයි
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background/terminated state එකේදී FCM notification payload එකක් තිබ්බොත් 
  // OS එකම notification එක පෙන්නනවා - මෙතන අමතරව logic එකක් ඕන නම් (e.g. local DB update) මෙතන දාන්න
  debugPrint('📩 Background message received: ${message.messageId}');
}

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'camprunner_high_importance_channel', // channel id
    'CampRunner Notifications', // channel name (user visible - settings වල පේනවා)
    description: 'Order updates සහ chat messages සඳහා notifications',
    importance: Importance.high,
  );

  /// main() එකෙන් Firebase.initializeApp() එකට පස්සේ එකම වතාවක් call කරන්න
  Future<void> initialize() async {
    // 1️⃣ Permission ඉල්ලීම (iOS + Android 13+ දෙකටම අනිවාර්යයි)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

    // 2️⃣ Local notifications plugin setup (foreground state එකේදී banner එක පෙන්නන්න)
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _localNotifications.initialize(initSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 3️⃣ Background handler register කිරීම (main.dart එකේත් set කරන්න ඕන - පහළ බලන්න)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4️⃣ App එක foreground එකේ open ඉන්නකොට message එකක් ආවොත් - 
    // FCM notification payload එක automatic display වෙන්නේ නෑ, ඒක නිසා 
    // local notification එකක් විදිහට manual දාන්න ඕන
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // 5️⃣ User notification එක tap කරලා app එක open කළොත් (background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('👆 Notification tapped, data: ${message.data}');
      // TODO: message.data['orderId'] තියෙනවා නම් OrderStatusScreen එකට navigate කරන්න
      // Navigator key එකක් global විදිහට main.dart එකේ define කරලා මෙතන පාවිච්චි කරන්න පුළුවන්
    });

    // 6️⃣ Token save කිරීම + refresh වුනොත් update කිරීම
    await saveTokenToFirestore();
    _messaging.onTokenRefresh.listen(_updateTokenInFirestore);
  }

  /// 💡 Public method - app start වෙද්දී user login වෙලා නැති නම් token save වෙන්නේ නෑ,
  /// ඒක නිසා login/register සාර්ථක වුනාට පස්සේ මේක ආයෙත් call කරන්න (login_page.dart, register_page.dart බලන්න)
  Future<void> saveTokenToFirestore() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // user login වෙලා නැත්නම් token save කරන්න බෑ

    try {
      final String? token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token unavailable yet; skipping token save.');
        return;
      }

      await _updateTokenInFirestore(token);
    } catch (e) {
      debugPrint('⚠️ Failed to fetch/save FCM token: $e');
    }
  }

  Future<void> _updateTokenInFirestore(String token) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fcmToken': token,
      'tokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // 💡 merge:true - existing fields මකෙන්නේ නෑ
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  /// Logout වෙනකොට token එක clear කරන්න (optional, ඒත් recommended - 
  /// device එක වෙන කෙනෙක් පාවිච්චි කළොත් notification වැරදි කෙනාට යන එක නවත්තනවා)
  Future<void> clearToken() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('⚠️ Failed to delete FCM token: $e');
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmToken': FieldValue.delete(),
      });
    } catch (e) {
      debugPrint('⚠️ Failed to clear stored FCM token: $e');
    }
  }
}