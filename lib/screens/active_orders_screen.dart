import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_strings.dart';
import 'order_status_screen.dart';

class ActiveOrdersScreen extends StatelessWidget {
  const ActiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return Center(child: Text(context.tr('please_login_first')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('active_orders_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', whereIn: ['PENDING', 'ACCEPTED', 'PICKED_UP'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }

          final docs = snapshot.data?.docs ?? [];

          final myOrders = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['requesterId'] == currentUserId || data['runnerId'] == currentUserId;
          }).toList();

          if (myOrders.isEmpty) {
            return Center(
              child: Text(context.tr('no_active_orders')),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: myOrders.length,
            itemBuilder: (context, index) {
              final order = myOrders[index];
              bool isRunner = order['runnerId'] == currentUserId;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(order['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${context.tr('status_label')}: ${order['status']} (${isRunner ? context.tr('runner_label') : context.tr('customer_label')})'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.amber, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderStatusScreen(orderId: order.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}