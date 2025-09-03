import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import "../../../controllers/vehicle_controller.dart";

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VehicleController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Vehicle 🚗'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: const AddVehicleForm(),
      ),
    );
  }
}

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'model': _modelController.text,
        'pricePerDay': _priceController.text,
        'ownerPhoneNumber': _phoneController.text,
      };
      
      context.read<VehicleController>().submitVehicleData(
        formData: formData,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleController>(
      builder: (context, controller, child) {
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSectionHeader('Vehicle Details'),
                  _buildTextFormField(
                    controller: _nameController,
                    label: 'Vehicle Name (e.g., Honda Activa 6G)',
                    icon: Icons.car_crash,
                  ),
                  _buildTextFormField(
                    controller: _modelController,
                    label: 'Model (e.g., Activa 6G - 2023)',
                    icon: Icons.calendar_today,
                  ),
                  _buildTextFormField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  _buildTextFormField(
                    controller: _priceController,
                    label: 'Price per Day (₹)',
                    icon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _buildTextFormField(
                    controller: _phoneController,
                    label: 'Owner Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('Vehicle Photos'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildImagePicker(
                        context: context,
                        slot: ImageSlot.main,
                        label: 'Main Photo*',
                        imageFile: controller.mainImage,
                      ),
                      _buildImagePicker(
                        context: context,
                        slot: ImageSlot.second,
                        label: 'Second Photo*',
                        imageFile: controller.secondImage,
                      ),
                      _buildImagePicker(
                        context: context,
                        slot: ImageSlot.third,
                        label: 'Third Photo',
                        imageFile: controller.thirdImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: controller.isLoading ? null : _submitForm,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Add Vehicle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            // Loading overlay
            if (controller.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white,),
                      SizedBox(height: 16),
                      Text("Uploading, please wait...", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // --- Helper Widgets for Cleaner Build Method ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value for $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildImagePicker({
    required BuildContext context,
    required ImageSlot slot,
    required String label,
    File? imageFile,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.read<VehicleController>().showImageSourceOptions(context, slot),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
              image: imageFile != null
                  ? DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover)
                  : null,
            ),
            child: imageFile == null
                ? const Center(child: Icon(Icons.add_a_photo, color: Colors.grey))
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}