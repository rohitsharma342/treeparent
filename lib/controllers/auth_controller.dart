import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/local_storage_service.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    final isLoggedIn = await LocalStorageService.isLoggedIn();
    
    if (isLoggedIn) {
      _currentUser = UserModel(
        id: '1',
        name: 'Tree Lover',
        email: 'user@treeparent.com',
      );
      _isLoggedIn = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter email and password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: '1',
      name: 'Tree Lover',
      email: email,
    );
    _isLoggedIn = true;
    await LocalStorageService.setLoggedIn(true);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in all fields';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: '1',
      name: name,
      email: email,
    );
    _isLoggedIn = true;
    await LocalStorageService.setLoggedIn(true);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    await LocalStorageService.setLoggedIn(false);

    _currentUser = null;
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String email) async {
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

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = _currentUser?.copyWith(name: name, email: email);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}