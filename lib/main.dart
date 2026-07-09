import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'theme_provider.dart';
import 'screens/login_page.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      
      
      // උඩින් import එක තියෙනවාද බලන්න: import 'login_page.dart';

      home: const LoginPage(),
    );
  }
}


class TempWelcomePage extends StatelessWidget {
  const TempWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delivery_dining, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Welcome to CampRunner!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Campus Micro-Delivery & Errand Network',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}