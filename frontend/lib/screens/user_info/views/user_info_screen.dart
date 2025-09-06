import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/provider/data_provider.dart';
import 'package:shop/provider/profile_provider.dart';
import "../../../controllers/vehicle_controller.dart";

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VehicleController(),
      child:const Scaffold(
        body: UserForm(),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _StateUserForm();
}

class _StateUserForm extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'username': _nameController.text.trim(),
        'aboutYou': _aboutController.text.trim(),
        'number': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      };
      
      context.read<VehicleController>().submitUserData(
        formData: formData,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch in the build method to listen for changes.
    final controller = context.watch<ProfileProvider>();
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          if (controller.isEditing)
            TextButton(
              onPressed: () {
                context.read<ProfileProvider>().toggleEditMode();
                _submitForm();
              },
              child: const Text("Save"),
            )
          else
            TextButton(
              // Use context.read in callbacks
              onPressed: () => context.read<ProfileProvider>().toggleEditMode(),
              child: const Text("Edit"),
            ),
        ],
      ),
      body: Consumer<VehicleController>(
        builder: (ctx, provider, child){
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(25.0),
                  children: [
                    _buildImagePicker(
                      image: dataProvider.user["photo"],
                      context: context,
                      slot: ImageSlot.profileImage,
                      label: 'Profile Photo',
                      enabled: controller.isEditing, // Use state from controller
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      context: context,
                      controller: _nameController,
                      label: !controller.isEditing ? dataProvider.user['username'] : 'name',
                      icon: 'Profile',
                      enabled: controller.isEditing, // Use state from controller
                    ),
                    _buildTextFormField(
                      context: context,
                      controller: _aboutController,
                      label: !controller.isEditing ? dataProvider.user['aboutYou'] : 'Something about you',
                      icon: 'Order',
                      enabled: controller.isEditing,
                    ),
                    _buildTextFormField(
                      context: context,
                      controller: _phoneController,
                      label: !controller.isEditing ? dataProvider.user['number'] : 'Phone Number',
                      icon: "Call",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      enabled: controller.isEditing,
                    ),
                    _buildTextFormField(
                      context: context,
                      controller: _emailController,
                      label: !controller.isEditing ? dataProvider.user['email'] : 'Email',
                      icon: "Message",
                      keyboardType: TextInputType.emailAddress,
                      enabled: controller.isEditing,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              // Loading overlay
              if (provider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text("Uploading, please wait...",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      )
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String icon,
    required bool enabled,
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
        readOnly: !enabled,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
            child: SvgPicture.asset(
              "assets/icons/$icon.svg",
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
                  BlendMode.srcIn),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey[200],
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
    String? image,
    required BuildContext context,
    required ImageSlot slot,
    required String label,
    required bool enabled,
    File? imageFile,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: enabled
              ? () => context.read<VehicleController>().showImageSourceOptions(context, slot)
              : null,
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
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                      child: SvgPicture.asset(
                        image ?? "assets/icons/Camera-add.svg",
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(enabled ? 0.8 : 0.3),
                            BlendMode.srcIn),
                      ),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}