import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart'; // 💡 අලුතින් සාදපු Chat Screen එක Import කළා

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
        title: const Text('Order Tracking'),
        actions: [
          // 💡 AppBar එකට Real-time Chat එකට යන්න සුපිරි Action Button එකක් එකතු කළා
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
          String customerId = order['customerId'] ?? '';
          String runnerId = order['runnerId'] ?? '';

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
                Text('Status: $status', style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                Expanded(
                  child: Stepper(
                    currentStep: currentStep,
                    physics: const ClampingScrollPhysics(),
                    controlsBuilder: (context, details) => const SizedBox(),
                    steps: [
                      Step(
                        title: const Text('Order Placed'),
                        subtitle: const Text('ඇණවුම සාර්ථකව පෝස්ට් කර ඇත.'),
                        isActive: currentStep >= 0,
                        state: currentStep > 0 ? StepState.complete : StepState.editing,
                        content: const SizedBox(),
                      ),
                      Step(
                        title: const Text('Accepted'),
                        subtitle: const Text('Runner කෙනෙක් ඇණවුම බාරගෙන ඇත.'),
                        isActive: currentStep >= 1,
                        state: currentStep > 1 ? StepState.complete : (currentStep == 1 ? StepState.editing : StepState.indexed),
                        content: const SizedBox(),
                      ),
                      Step(
                        title: const Text('Picked Up'),
                        subtitle: const Text('Runner භාණ්ඩය රැගෙන එමින් පවතී.'),
                        isActive: currentStep >= 2,
                        state: currentStep > 2 ? StepState.complete : (currentStep == 2 ? StepState.editing : StepState.indexed),
                        content: const SizedBox(),
                      ),
                      Step(
                        title: const Text('Delivered'),
                        subtitle: const Text('ඇණවුම ඔබට ලැබී ඇත. ස්තූතියි! 🎉'),
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
                        status == 'ACCEPTED' ? 'I Picked Up the Item 🛍️' : 'Mark as Delivered ✅',
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