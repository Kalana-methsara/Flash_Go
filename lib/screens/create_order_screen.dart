import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_strings.dart';
import 'order_status_screen.dart';
import 'location_picker_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _tipController = TextEditingController();

  PickedLocation? _pickupLocation;
  PickedLocation? _dropLocation;

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  Future<void> _pickPickupLocation() async {
    final result = await Navigator.push<PickedLocation>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(title: context.tr('pick_pickup_title')),
      ),
    );
    if (result != null) {
      setState(() => _pickupLocation = result);
    }
  }

  Future<void> _pickDropLocation() async {
    final result = await Navigator.push<PickedLocation>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(title: context.tr('pick_drop_title')),
      ),
    );
    if (result != null) {
      setState(() => _dropLocation = result);
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickupLocation == null || _dropLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('select_locations_error')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserUid == null) {
        throw Exception(context.tr('please_login_first'));
      }

      DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc();

      await orderRef.set({
        'orderId': orderRef.id,
        'requesterId': currentUserUid,
        'runnerId': null,
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'pickupLocation': {
          'name': _pickupLocation!.name,
          'latitude': _pickupLocation!.latitude,
          'longitude': _pickupLocation!.longitude,
        },
        'dropLocation': {
          'name': _dropLocation!.name,
          'latitude': _dropLocation!.latitude,
          'longitude': _dropLocation!.longitude,
        },
        'tipAmount': double.parse(_tipController.text.trim()),
        'status': 'PENDING',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _descController.clear();
      _tipController.clear();
      setState(() {
        _pickupLocation = null;
        _dropLocation = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('order_posted_success')),
            backgroundColor: Colors.green,
          ),
        );

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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildLocationSelector({
    required String label,
    required IconData icon,
    required Color iconColor,
    required PickedLocation? picked,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: iconColor),
          suffixIcon: const Icon(Icons.map_rounded, color: Colors.amber),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          picked?.name ?? context.tr('pick_on_map'),
          style: TextStyle(
            color: picked == null ? Colors.grey : Colors.black87,
            fontWeight: picked == null ? FontWeight.normal : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('new_request_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.amber.withValues(alpha: 0.15),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.flash_on, color: Colors.amber, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.tr('create_order_banner'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.tr('title_label'),
                  hintText: context.tr('title_hint'),
                  prefixIcon: const Icon(Icons.assignment),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => value!.isEmpty ? context.tr('enter_title') : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.tr('desc_label'),
                  hintText: context.tr('desc_hint'),
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) => value!.isEmpty ? context.tr('enter_desc') : null,
              ),
              const SizedBox(height: 16),

              _buildLocationSelector(
                label: context.tr('pickup_label'),
                icon: Icons.location_on,
                iconColor: Colors.redAccent,
                picked: _pickupLocation,
                onTap: _pickPickupLocation,
              ),
              const SizedBox(height: 16),

              _buildLocationSelector(
                label: context.tr('drop_label'),
                icon: Icons.navigation,
                iconColor: Colors.green,
                picked: _dropLocation,
                onTap: _pickDropLocation,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _tipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr('tip_label'),
                  hintText: context.tr('tip_hint'),
                  prefixIcon: const Icon(Icons.monetization_on, color: Colors.amber),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return context.tr('enter_tip');
                  if (double.tryParse(value) == null) return context.tr('valid_amount');
                  return null;
                },
              ),
              const SizedBox(height: 30),

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send_rounded, fontWeight: FontWeight.bold),
                            const SizedBox(width: 8),
                            Text(
                              context.tr('post_to_pool'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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