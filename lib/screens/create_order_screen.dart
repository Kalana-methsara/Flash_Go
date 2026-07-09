import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 💡 Backend එකට අවශ්‍යයි
import 'package:firebase_auth/firebase_auth.dart';       // 💡 Backend එකට අවශ්‍යයි
import 'order_status_screen.dart';                       // 💡 Navigation එකට අවශ්‍යයි

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to get data from text fields
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final _tipController = TextEditingController();

  bool _isLoading = false; // 💡 Loading state එක පෙන්වීමට

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _pickupController.dispose();
    _dropController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  // 🚀 Backend + Navigation එකතු කළ සම්පූර්ණ Method එක
  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Loading එක පටන් ගන්නවා
      });

      try {
        // 1. දැනට ලොග් වෙලා ඉන්න ශිෂ්‍යයාගේ User ID (UID) එක ගැනීම
        String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

        if (currentUserUid == null) {
          throw Exception("කරුණාකර ප්‍රථමයෙන් ලොග් වන්න.");
        }

        // 2. Firestore එකේ අලුත් Document reference එකක් හැදීම (ID එක auto-generate වෙන්න)
        DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc();

        // 3. ඩේටා ටික Map එකකට දමා Firestore එකට සේව් කිරීම
        await orderRef.set({
          'orderId': orderRef.id,
          'requesterId': currentUserUid,
          'runnerId': null, // තවම මේ order එක කවුරුත් බාරගෙන නැති නිසා null
          'title': _titleController.text.trim(),
          'description': _descController.text.trim(),
          'pickupLocation': {
            'name': _pickupController.text.trim(),
            'latitude': 0.0,  
            'longitude': 0.0,
          },
          'dropLocation': {
            'name': _dropController.text.trim(),
            'latitude': 0.0,
            'longitude': 0.0,
          },
          'tipAmount': double.parse(_tipController.text.trim()),
          'status': 'PENDING', // මුලින්ම order එකක් දාද්දී තත්ත්වය PENDING වේ
          'createdAt': FieldValue.serverTimestamp(), // Server වෙලාව
        });

        // සාර්ථකව සේව් වුණාම Form එක clear කිරීම
        _titleController.clear();
        _descController.clear();
        _pickupController.clear();
        _dropController.clear();
        _tipController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order එක Campus Pool එකට සාර්ථකව එකතු වුණා! 🚀'),
              backgroundColor: Colors.green,
            ),
          );

          // 💡 සාර්ථක වුණාට පස්සේ කෙලින්ම Tracking Screen එකට රැගෙන යාම
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderStatusScreen(orderId: orderRef.id),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Loading එක නතර කරනවා
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Request (Errand)', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                color: Colors.amber.withOpacity(0.15),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.flash_on, color: Colors.amber, size: 30),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ඔයාට කරගන්න ඕන errand එක ඇතුළත් කරන්න. කැම්පස් එකේ ළඟ ඉන්න යාළුවෙක් ඒක කරලා දේවි!',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'මොකක්ද වෙන්න ඕනේ? (Title)',
                  hintText: 'e.g., කැන්ටින් එකෙන් චිකන් රයිස් එකක්',
                  prefixIcon: const Icon(Icons.assignment),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => value!.isEmpty ? 'කරුණාකර මේ කොටස පුරවන්න' : null,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'විස්තරය (Description)',
                  hintText: 'කෑම එක අරන් IT Lab 2 එකට ගෙනත් දෙන්න. සල්ලි cash දෙන්නම්.',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => value!.isEmpty ? 'විස්තරයක් ඇතුළත් කරන්න' : null,
              ),
              const SizedBox(height: 16),

              // Pickup Location Field
              TextFormField(
                controller: _pickupController,
                decoration: InputDecoration(
                  labelText: 'බඩු ගන්න ඕන තැන (Pickup Location)',
                  hintText: 'e.g., Main Canteen / Science Photocopy Shop',
                  prefixIcon: const Icon(Icons.location_on, color: Colors.redAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => value!.isEmpty ? 'Pickup ස්ථානයක් දමන්න' : null,
              ),
              const SizedBox(height: 16),

              // Drop Location Field
              TextFormField(
                controller: _dropController,
                decoration: InputDecoration(
                  labelText: 'ගෙනත් දෙන්න ඕන තැන (Drop Location)',
                  hintText: 'e.g., Hostel Block B - Room 302 / Library',
                  prefixIcon: const Icon(Icons.navigation, color: Colors.green),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => value!.isEmpty ? 'Drop ස්ථානයක් දමන්න' : null,
              ),
              const SizedBox(height: 16),

              // Tip Field
              TextFormField(
                controller: _tipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Runner ට දෙන ගාස්තුව (Tip Amount - LKR)',
                  hintText: 'e.g., 150',
                  prefixIcon: const Icon(Icons.monetization_on, color: Colors.amber),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'ගාස්තුවක් ඇතුළත් කරන්න';
                  if (double.tryParse(value) == null) return 'වලංගු මුදලක් ඇතුළත් කරන්න';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                    : ElevatedButton(
                        onPressed: _submitOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, fontWeight: FontWeight.bold),
                            SizedBox(width: 8),
                            Text(
                              'Post to Campus Pool',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}