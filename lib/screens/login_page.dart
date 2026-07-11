import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/notification_service.dart'; // 💡 එකතු කළා
import 'main_dashboard.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Firebase Login Logic
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Firebase එකෙන් login වීම පරීක්ෂා කිරීම
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 💡 login සාර්ථක වුනාට පස්සේ FCM token එක මේ user ගේ Firestore doc එකට save කරනවා
        await NotificationService.instance.saveTokenToFirestore();

        // 💡 සාර්ථක නම් කෙලින්ම Bottom Navigation Bar එක තියෙන Main Dashboard එකට රැගෙන යාම
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainDashboard()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'වැරදීමක් සිදුවුණා. නැවත උත්සාහ කරන්න.';
        
        // 💡 Firebase Auth නවතම අප්ඩේට් එකට අනුව 'invalid-credential' කේතයද එකතු කළා
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
          errorMessage = 'ඇතුළත් කළ Email හෝ Password එක වැරදියි.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'ඇතුළත් කළ Email රටාව වැරදියි.';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'මෙම ගිණුම තාවකාලිකව අත්හිටුවා ඇත.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: const TextStyle(fontWeight: FontWeight.w500)), 
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating, // ලස්සනට පාවෙලා එන විදිහට හැදුවා
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo Icon
                const Icon(Icons.flash_on, size: 80, color: Colors.amber),
                const SizedBox(height: 10),
                
                // App Title
                Text(
                  'Flash Go',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                ),
                const Text(
                  'Fastest Campus Errand Network',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Campus Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Email එක ඇතුළත් කරන්න' : null,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Password එක ඇතුළත් කරන්න' : null,
                ),
                const SizedBox(height: 24),

                // Login Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                    : SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                const SizedBox(height: 16),
                
                // Go to Register Page Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "ගිණුමක් නැද්ද? Register වෙන්න මෙතනින්",
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}