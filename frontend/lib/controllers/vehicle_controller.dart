import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/services/api_service.dart';

import '../models/vehicle_model.dart';

enum ImageSlot { main, second, third, profileImage }

class VehicleController with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _mainImage;
  File? get mainImage => _mainImage;

  File? _secondImage;
  File? get secondImage => _secondImage;

  File? _thirdImage;
  File? get thirdImage => _thirdImage;

  File? _profileImage;
  File? get profileImage => _profileImage;

  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
  final ApiService _apiService = ApiService();
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
                onTap: () async { 
                  await _pickAndCropImage(ImageSource.gallery, slot); 
                  if (builderContext.mounted) { 
                    Navigator.of(builderContext).pop();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () async { 
                  await _pickAndCropImage(ImageSource.camera, slot); 
                  if (builderContext.mounted) { 
                    Navigator.of(builderContext).pop();
                  }
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
      );

      if (croppedFile != null) {
        switch (slot) {
          case ImageSlot.profileImage:
            _profileImage = File(croppedFile.path);
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

  Future<String> _uploadImageToCloudinary(File image) async {
    const String cloudName = "dsukah8ss"; 
    const String uploadPreset = "ml_default"; 

    String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: fileName),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        return responseData['secure_url'];
      } else {
        throw Exception('Failed to upload image. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('Cloudinary Upload Error: ${e.response?.data}');
      throw Exception('Failed to upload image.');
    } catch (e) {
      debugPrint('Cloudinary Upload Error: $e');
      throw Exception('An unknown error occurred during upload.');
    }
  }
  

  Future<void> submitVehicleData({
    required Map<String, String> formData,
    required BuildContext context,
  }) async {
    _setLoading(true);

    if (_mainImage == null || _secondImage == null) {
      _showSnackBar(context, 'Main and Second photos are required.',"Failed", isError: true);
      _setLoading(false);
      return;
    }

    try {
      final String mainPhotoUrl = await _uploadImageToCloudinary(_mainImage!);
      final String secondPhotoUrl = await _uploadImageToCloudinary(_secondImage!);
      String? thirdPhotoUrl;
      if (_thirdImage != null) {
        thirdPhotoUrl = await _uploadImageToCloudinary(_thirdImage!);
      }

      final vehicle = Vehicle(
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


      await _apiService.dio.post(
        'vehicles/add',
        data: vehicle.toJson()
      );
      
      _showSnackBar(context, 'Vehicle added successfully!','Success');

    } on DioException catch (e) {
      String errorMessage = 'API Error: Failed to add vehicle.';
      if (e.response != null) {
        errorMessage = 'API Error [${e.response?.statusCode}]: ${e.response?.data['message'] ?? e.response?.data}';
      } else {
        errorMessage = 'Network Error: Please check your connection.';
      }
       _showSnackBar(context, errorMessage,'Failed', isError: true);
    } catch (e) {
      _showSnackBar(context, 'An unexpected error occurred: $e',"Failed", isError: true);
    } finally {
      _setLoading(false);
    }
  }

  void submitUserData({
    required Map<String, String> formData,
    required BuildContext context,
  }) async{
    try {
      final String profilePhotoUrl = await _uploadImageToCloudinary(_profileImage!);
      await _apiService.dio.put(
        'users/me',
        data: {
          "photo": profilePhotoUrl,
          "username": formData['username'],
          "aboutYou": formData['aboutYou'],
          "number": formData["number"],
          "email": formData["email"]
        }
      );
      _showSnackBar(context, 'Profile Updated', 'Success');

    } on DioException catch (e) {
      String errorMessage = 'API Error: Failed to add vehicle.';
      if (e.response != null) {
        errorMessage = 'API Error [${e.response?.statusCode}]: ${e.response?.data['message'] ?? e.response?.data}';
      } else {
        errorMessage = 'Network Error: Please check your connection.';
      }
       _showSnackBar(context, errorMessage, "Fail" ,isError: true);
    } catch (e) {
      _showSnackBar(context, 'An unexpected error occurred: $e',"Fail", isError: true);
    } finally {
      _setLoading(false);
    }

  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _showSnackBar(BuildContext context, String message,String title, {bool isError = false}) {
     showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, entryPointScreenRoute);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}