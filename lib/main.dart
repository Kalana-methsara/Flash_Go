import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'theme_provider.dart';
import 'services/notification_service.dart'; // 💡 අලුතින් එකතු කළ import එක
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 💡 Background handler එක Firebase.initializeApp() එකට පස්සේම, 
  // runApp() එකට කලින් register කරන්න ඕන (Flutter engine එකට separate isolate එකෙන් call වෙන්නේ)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // 💡 Notification service එක initialize කිරීම - permission/permission issues වලින් app crash නොවෙන්න
  try {
    await NotificationService.instance.initialize();
  } catch (e) {
    debugPrint('⚠️ Notification initialization failed: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const CampRunnerApp(),
    ),
  );
}

class CampRunnerApp extends StatelessWidget {
  const CampRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'CampRunner',
      debugShowCheckedModeBanner: false,
      
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber, 
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,
        ),
      ),
      
      home: const LoginPage(),
    );
  }
}