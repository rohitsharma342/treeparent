import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserController extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> updateUser(String name, String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (name.isEmpty || email.isEmpty) {
      _errorMessage = 'Please fill in all fields';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = _user?.copyWith(name: name, email: email);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}