import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../models/vehicle_model.dart';

enum ImageSlot { main, second, third }

class VehicleController with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _mainImage;
  File? get mainImage => _mainImage;

  File? _secondImage;
  File? get secondImage => _secondImage;

  File? _thirdImage;
  File? get thirdImage => _thirdImage;

  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  final Dio _dio = Dio(); 

  Future<void> showImageSourceOptions(BuildContext context, ImageSlot slot) async {
    await showModalBottomSheet(
      context: context,
      builder: (builderContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  _pickAndCropImage(ImageSource.gallery, slot);
                  Navigator.of(builderContext).pop(); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () {
                  _pickAndCropImage(ImageSource.camera, slot);
                   Navigator.of(builderContext).pop(); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndCropImage(ImageSource source, ImageSlot slot) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final CroppedFile? croppedFile = await _cropper.cropImage(
        sourcePath: pickedFile.path,
        // ... (rest of the cropping logic is the same)
      );

      if (croppedFile != null) {
        // ... (rest of the logic to assign the file is the same)
        switch (slot) {
          case ImageSlot.main:
            _mainImage = File(croppedFile.path);
            break;
          case ImageSlot.second:
            _secondImage = File(croppedFile.path);
            break;
          case ImageSlot.third:
            _thirdImage = File(croppedFile.path);
            break;
        }
        notifyListeners();
      }
    }
  }

  Future<String> _uploadImageToFirebase(File image) async {
    try {
      final String fileName = 'vehicles/${DateTime.now().millisecondsSinceEpoch}.png';
      final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      final UploadTask uploadTask = storageRef.putFile(image);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Firebase Upload Error: $e');
      throw Exception('Failed to upload image.');
    }
  }
  

  Future<void> submitVehicleData({
    required Map<String, String> formData,
    required BuildContext context,
  }) async {
    _setLoading(true);

    if (_mainImage == null || _secondImage == null) {
      _showSnackBar(context, 'Main and Second photos are required.', isError: true);
      _setLoading(false);
      return;
    }

    try {
      // 1. Upload images (No change)
      final String mainPhotoUrl = await _uploadImageToFirebase(_mainImage!);
      final String secondPhotoUrl = await _uploadImageToFirebase(_secondImage!);
      String? thirdPhotoUrl;
      if (_thirdImage != null) {
        thirdPhotoUrl = await _uploadImageToFirebase(_thirdImage!);
      }

      // 2. Create the Vehicle model (No change)
      final vehicle = Vehicle(
        ownerId: 1,
        name: formData['name']!,
        description: formData['description']!,
        model: formData['model']!,
        pricePerDay: double.parse(formData['pricePerDay']!),
        mainPhoto: mainPhotoUrl,
        secondPhoto: secondPhotoUrl,
        thirdPhoto: thirdPhotoUrl,
        ownerPhoneNumber: formData['ownerPhoneNumber']!,
        createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc()),
      );

      // 3. Send data to your API using Dio (*** THIS IS THE UPDATED PART ***)
      const String apiUrl = 'https://velvo-drive.onrender.com/api/vehicles/add';
      const String authToken = 'YOUR_BEARER_TOKEN_HERE'; 

      final response = await _dio.post(
        apiUrl,
        data: vehicle.toJson(), // Dio handles JSON encoding for maps
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );
      
      // With Dio, a non-2xx status code will throw an exception,
      // so if we get here, the request was successful.
      _showSnackBar(context, 'Vehicle added successfully!');

    } on DioException catch (e) {
      // Handle Dio-specific errors (like network issues, 404, 500)
      String errorMessage = 'API Error: Failed to add vehicle.';
      if (e.response != null) {
        // The server responded with a status code that falls out of the range of 2xx
        errorMessage = 'API Error [${e.response?.statusCode}]: ${e.response?.data['message'] ?? e.response?.data}';
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        errorMessage = 'Network Error: Please check your connection.';
      }
       _showSnackBar(context, errorMessage, isError: true);
    } catch (e) {
      // Handle other errors (like image upload failure)
      _showSnackBar(context, 'An unexpected error occurred: $e', isError: true);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
        ),
      );
  }
}