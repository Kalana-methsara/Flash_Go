import 'package:flutter/material.dart';
import '../app_strings.dart';
import 'create_order_screen.dart';
import 'campus_pool_screen.dart';
import 'profile_screen.dart';
import 'active_orders_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CreateOrderScreen(),
    const CampusPoolScreen(),
    const ActiveOrdersScreen(),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: context.tr('nav_request'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_fire_department_rounded),
            label: context.tr('nav_pool'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.moped_rounded),
            label: context.tr('nav_tracking'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            label: context.tr('nav_profile'),
          ),
        ],
      ),
    );
  }
}