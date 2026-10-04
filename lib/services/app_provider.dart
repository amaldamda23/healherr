// lib/services/app_provider.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'firebase_service.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void setError(String? err) {
    _error = err;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final uid = FirebaseService.uid;
    if (uid == null) return;
    setLoading(true);
    try {
      _user = await FirebaseService.getUserProfile(uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateWeight(double newWeight) async {
    if (_user == null) return;
    await FirebaseService.updateUserProfile(_user!.uid, {'weight': newWeight});
    _user = UserModel(
      uid: _user!.uid,
      name: _user!.name,
      email: _user!.email,
      age: _user!.age,
      weight: newWeight,
      height: _user!.height,
      condition: _user!.condition,
      createdAt: _user!.createdAt,
    );
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
