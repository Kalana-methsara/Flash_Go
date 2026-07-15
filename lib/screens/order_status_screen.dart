import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_strings.dart';
import 'chat_screen.dart';
import 'order_map_screen.dart';

class OrderStatusScreen extends StatelessWidget {
  final String orderId;
  const OrderStatusScreen({super.key, required this.orderId});

  Future<void> _updateStatus(BuildContext context, String currentStatus) async {
    String nextStatus = currentStatus;
    if (currentStatus == 'ACCEPTED') nextStatus = 'PICKED_UP';
    if (currentStatus == 'PICKED_UP') nextStatus = 'DELIVERED';

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': nextStatus,
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('order_tracking_title')),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox();
              }
              var order = snapshot.data!.data() as Map<String, dynamic>;
              var pickup = order['pickupLocation'] as Map<String, dynamic>?;
              var drop = order['dropLocation'] as Map<String, dynamic>?;

              if (pickup == null || drop == null) return const SizedBox();

              return IconButton(
                icon: const Icon(Icons.map_rounded, color: Colors.amber, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderMapScreen(
                        pickupName: pickup['name'] ?? context.tr('pickup_word'),
                        pickupLat: (pickup['latitude'] ?? 0.0).toDouble(),
                        pickupLng: (pickup['longitude'] ?? 0.0).toDouble(),
                        dropName: drop['name'] ?? context.tr('drop_word'),
                        dropLat: (drop['latitude'] ?? 0.0).toDouble(),
                        dropLng: (drop['longitude'] ?? 0.0).toDouble(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_rounded, color: Colors.amber, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(orderId: orderId),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }

          var order = snapshot.data!.data() as Map<String, dynamic>;
          String status = order['status'] ?? 'PENDING';
          String title = order['title'] ?? 'Errand';
          String runnerId = order['runnerId'] ?? '';
          var pickup = order['pickupLocation'] as Map<String, dynamic>?;
          var drop = order['dropLocation'] as Map<String, dynamic>?;

          bool isRunner = currentUserId == runnerId;

          int currentStep = 0;
          if (status == 'ACCEPTED') currentStep = 1;
          if (status == 'PICKED_UP') currentStep = 2;
          if (status == 'DELIVERED') currentStep = 3;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${context.tr('status_label')}: $status',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                if (pickup != null && drop != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderMapScreen(
                            pickupName: pickup['name'] ?? context.tr('pickup_word'),
                            pickupLat: (pickup['latitude'] ?? 0.0).toDouble(),
                            pickupLng: (pickup['longitude'] ?? 0.0).toDouble(),
                            dropName: drop['name'] ?? context.tr('drop_word'),
                            dropLat: (drop['latitude'] ?? 0.0).toDouble(),
                            dropLng: (drop['longitude'] ?? 0.0).toDouble(),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text('${context.tr('from_label')}: ${pickup['name']}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.navigation, color: Colors.green, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text('${context.tr('to_label')}: ${drop['name']}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                ),
                                const Icon(Icons.map_rounded, color: Colors.amber, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                Expanded(
                  child: Stepper(
                    currentStep: currentStep,
                    physics: const ClampingScrollPhysics(),
                    controlsBuilder: (context, details) => const SizedBox(),
                    steps: [
                      Step(
                        title: Text(context.tr('step_placed_title')),
                        subtitle: Text(context.tr('step_placed_sub')),
                        isActive: currentStep >= 0,
                        state: currentStep > 0 ? StepState.complete : StepState.editing,
                        content: const SizedBox(),
                      ),
                      Step(
                        title: Text(context.tr('step_accepted_title')),
                        subtitle: Text(context.tr('step_accepted_sub')),
                        isActive: currentStep >= 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : (currentStep == 1 ? StepState.editing : StepState.indexed),
                        content: const SizedBox(),
                      ),
                      Step(
                        title: Text(context.tr('step_pickedup_title')),
                        subtitle: Text(context.tr('step_pickedup_sub')),
                        isActive: currentStep >= 2,
                        state: currentStep > 2
                            ? StepState.complete
                            : (currentStep == 2 ? StepState.editing : StepState.indexed),
                        content: const SizedBox(),
                      ),
                      Step(
                        title: Text(context.tr('step_delivered_title')),
                        subtitle: Text(context.tr('step_delivered_sub')),
                        isActive: currentStep >= 3,
                        state: currentStep == 3 ? StepState.complete : StepState.indexed,
                        content: const SizedBox(),
                      ),
                    ],
                  ),
                ),

                if (isRunner && status != 'DELIVERED')
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => _updateStatus(context, status),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        status == 'ACCEPTED' ? context.tr('picked_up_button') : context.tr('delivered_button'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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