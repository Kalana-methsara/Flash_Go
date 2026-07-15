import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_strings.dart';
import 'order_status_screen.dart';

class CampusPoolScreen extends StatelessWidget {
  const CampusPoolScreen({super.key});

  Future<void> _acceptOrder(BuildContext context, String orderId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) return;

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'runnerId': currentUserId,
        'status': 'ACCEPTED',
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('order_accepted_success')), backgroundColor: Colors.green),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderStatusScreen(orderId: orderId)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('campus_pool_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'PENDING')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }

          final docs = snapshot.data?.docs ?? [];

          final availableOrders = docs.where((doc) => doc['requesterId'] != currentUserId).toList();

          if (availableOrders.isEmpty) {
            return Center(
              child: Text(
                context.tr('no_requests'),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: availableOrders.length,
            itemBuilder: (context, index) {
              final order = availableOrders[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order['title'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'LKR ${order['tipAmount'].toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order['description'],
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('${context.tr('from_label')}: ${order['pickupLocation']['name']}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.navigation, color: Colors.green, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('${context.tr('to_label')}: ${order['dropLocation']['name']}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _acceptOrder(context, order.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(context.tr('accept_errand'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}