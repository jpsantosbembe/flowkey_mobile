import 'package:flutter/material.dart';
import '../models/key_model.dart';
import '../services/api_service.dart';
import 'auth_viewmodel.dart';

class KeysViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<KeyModel> _keys = [];
  bool _isLoading = false;

  List<KeyModel> get keys => _keys;
  bool get isLoading => _isLoading;

  Future<void> fetchKeys(AuthViewModel authViewModel) async {
    if (authViewModel.user == null) return;

    _isLoading = true;
    notifyListeners();

    _keys = await _apiService.fetchUserKeys(
      authViewModel.user!.id,
      await authViewModel.getToken() ?? "",
    );

    _isLoading = false;
    notifyListeners();
  }
}