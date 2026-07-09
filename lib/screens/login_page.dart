import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_order_screen.dart'; 
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

  
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'වැරදීමක් සිදුවුණා. නැවත උත්සාහ කරන්න.';
        if (e.code == 'user-not-found') {
          errorMessage = 'මේ Email එකෙන් ගිණුමක් සොයාගත නොහැක.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'ඇතුළත් කළ මුරපදය (Password) වැරදියි.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'ඇතුළත් කළ Email රටාව වැරදියි.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.redAccent),
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
                
                const Icon(Icons.flash_on, size: 80, color: Colors.amber),
                const SizedBox(height: 10),
                
                
                Text(
                  'CampRunner',
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

                
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                    : SizedBox(
                        height: 55,
                        child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      ),
                      const SizedBox(height: 16),
TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  },
  child: const Text(
    "ගිණුමක් නැද්ද? Register වෙන්න මෙතනින්",
    style: TextStyle(color: Colors.amber),
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