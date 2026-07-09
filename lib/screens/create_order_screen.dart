import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _pickupController.dispose();
    _dropController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      // TODO: Firebase Backend එකට ඩේටා යවන කොටස මීළඟට මෙතනට එනවා.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order එක Pool එකට එකතු වෙනවා... 🚀'),
          backgroundColor: Colors.amber,
        ),
      );
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
                child: ElevatedButton(
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