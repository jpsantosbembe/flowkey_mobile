import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../services/api_service.dart';
import 'auth_viewmodel.dart';

class LoansViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<LoanModel> _loans = [];
  bool _isLoading = false;

  List<LoanModel> get loans => _loans;
  bool get isLoading => _isLoading;

  Future<void> fetchActiveLoans(AuthViewModel authViewModel, {bool isCoordinator = false}) async {
    if (authViewModel.user == null) return;

    _isLoading = true;
    notifyListeners();

    _loans = await _apiService.fetchActiveLoans(
      authViewModel.user!.id,
      await authViewModel.getToken() ?? "",
      isCoordinator: isCoordinator,
    );

    _isLoading = false;
    notifyListeners();
  }

}
