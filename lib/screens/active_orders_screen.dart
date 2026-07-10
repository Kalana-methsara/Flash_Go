import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_status_screen.dart';

class ActiveOrdersScreen extends StatelessWidget {
  const ActiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return const Center(child: Text('කරුණාකර ප්‍රථමයෙන් ලොග් වන්න.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Active Orders', style: TextStyle(fontWeight: FontWeight.bold)),
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
            return const Center(
              child: Text('දැනට සක්‍රීය ඇණවුම් කිසිවක් නැත! 🏃‍♂️'),
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
                  subtitle: Text('Status: ${order['status']} (${isRunner ? "Runner" : "Customer"})'),
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