import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkModeLocal = false; 

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: currentUserId == null
          ? const Center(child: Text('කරුණාකර ප්‍රථමයෙන් ලොග් වන්න.'))
          : FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(currentUserId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.amber));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('යූසර්ගේ විස්තර සොයාගත නොහැකි විය.'));
                }

                final userData = snapshot.data!;
                final String name = userData['name'] ?? 'නමක් නොමැත';
                final String email = userData['email'] ?? 'ඊමේල් නොමැත';
                final String phone = userData['phone'] ?? 'ෆෝන් අංකයක් නොමැත';

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.amber.withOpacity(0.2),
                        child: const Icon(Icons.person_rounded, size: 60, color: Colors.amber),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'CampRunner Student Member',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 30),

                      
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.email_outlined, color: Colors.amber),
                              title: const Text('Campus Email', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              subtitle: Text(email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.phone_android_outlined, color: Colors.amber),
                              title: const Text('Contact Number', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              subtitle: Text(phone, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: SwitchListTile(
                          title: const Text('Dark Theme Mode', style: TextStyle(fontWeight: FontWeight.w500)),
                          secondary: const Icon(Icons.dark_mode_outlined, color: Colors.amber),
                          activeColor: Colors.amber,
                          value: _isDarkModeLocal,
                          onChanged: (bool value) {
                            setState(() {
                              _isDarkModeLocal = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 40),

                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            foregroundColor: Colors.redAccent,
                          ),
                          onPressed: () => _logout(context),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded),
                              SizedBox(width: 8),
                              Text('Logout from Account', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}