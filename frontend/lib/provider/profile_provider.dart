import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEditMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void exitEditMode() {
    if (_isEditing) {
      _isEditing = false;
      notifyListeners();
    }
  }
}