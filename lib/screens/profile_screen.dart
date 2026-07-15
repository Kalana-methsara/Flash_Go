import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../app_strings.dart';
import 'login_page.dart';
import '../theme_provider.dart';
import '../language_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logout(BuildContext context) async {
    await NotificationService.instance.clearToken();
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

    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('my_profile_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: currentUserId == null
          ? Center(child: Text(context.tr('please_login_first_profile')))
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
                  return Center(child: Text(context.tr('user_not_found')));
                }

                final userData = snapshot.data!;
                final String name = userData['name'] ?? context.tr('no_name');
                final String email = userData['email'] ?? context.tr('no_email');
                final String phone = userData['phone'] ?? context.tr('no_phone');

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.amber.withValues(alpha: 0.2),
                        child: const Icon(Icons.person_rounded, size: 60, color: Colors.amber),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        context.tr('member_tag'),
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 30),

                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.email_outlined, color: Colors.amber),
                              title: Text(context.tr('campus_email'),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              subtitle: Text(email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.phone_android_outlined, color: Colors.amber),
                              title: Text(context.tr('contact_number'),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                          title: Text(context.tr('dark_theme'), style: const TextStyle(fontWeight: FontWeight.w500)),
                          secondary: const Icon(Icons.dark_mode_outlined, color: Colors.amber),
                          activeThumbColor: Colors.amber,
                          value: themeProvider.isDarkMode,
                          onChanged: (bool value) {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 💡 Language switcher card - English (default) / Sinhala
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.language_rounded, color: Colors.amber),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(context.tr('language'),
                                    style: const TextStyle(fontWeight: FontWeight.w500)),
                              ),
                              SegmentedButton<AppLanguage>(
                                segments: const [
                                  ButtonSegment(value: AppLanguage.en, label: Text('EN')),
                                  ButtonSegment(value: AppLanguage.si, label: Text('සිං')),
                                ],
                                selected: {languageProvider.language},
                                onSelectionChanged: (selection) {
                                  languageProvider.setLanguage(selection.first);
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.amber;
                                    }
                                    return null;
                                  }),
                                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.black;
                                    }
                                    return null;
                                  }),
                                ),
                              ),
                            ],
                          ),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout_rounded),
                              const SizedBox(width: 8),
                              Text(context.tr('logout'), style: const TextStyle(fontWeight: FontWeight.bold)),
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