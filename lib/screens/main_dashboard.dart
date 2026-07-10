import 'package:flutter/material.dart';
import 'create_order_screen.dart';
import 'campus_pool_screen.dart';
import 'profile_screen.dart'; 
import 'active_orders_screen.dart'; // 💡 අලුතින් හදපු file එක import කරන්න

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  // Screens List එකට ActiveOrdersScreen එක එකතු කරා
  final List<Widget> _screens = [
    const CreateOrderScreen(),
    const CampusPoolScreen(),
    const ActiveOrdersScreen(), // 💡 මෙතනට එකතු කළා
    const ProfileScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_rounded),
            label: 'Request Errand',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_rounded),
            label: 'Campus Pool',
          ),
          // 💡 අලුත් Navigation Item එක
          BottomNavigationBarItem(
            icon: Icon(Icons.moped_rounded), // tracking වලට ගැලපෙන icon එකක්
            label: 'Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}