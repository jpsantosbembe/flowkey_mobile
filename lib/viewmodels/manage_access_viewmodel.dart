import 'dart:async';

import 'package:flutter/material.dart';
import '../models/authorization_model.dart';
import '../services/api_service.dart';
import 'auth_viewmodel.dart';

class ManageAccessViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<AuthorizationModel> _authorizations = [];
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  Timer? _debounce;

  List<AuthorizationModel> get authorizations => _authorizations;
  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;

  Future<void> fetchAuthorizations(AuthViewModel authViewModel, int keyId) async {
    if (authViewModel.user == null) return;

    _isLoading = true;
    notifyListeners();

    _authorizations = await _apiService.fetchLaboratoryAccess(
      authViewModel.user!.id,
      keyId,
      await authViewModel.getToken() ?? "",
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeAuthorization(AuthViewModel authViewModel, int userId, int keyId) async {
    if (authViewModel.user == null) return;

    bool success = await _apiService.revokeAccess(
      userId,
      keyId,
      await authViewModel.getToken() ?? "",
    );

    if (success) {
      // 🔥 Remove o usuário da lista localmente
      _authorizations.removeWhere((auth) => auth.userId == userId);
      notifyListeners();
    } else {
      // 🔥 Se der erro, exibe um alerta na tela
      print("Erro: Não foi possível remover o usuário.");
    }
  }

  void searchUsers(AuthViewModel authViewModel, String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () async {
      if (authViewModel.user == null || query.isEmpty) {
        _searchResults = [];
        notifyListeners();
        return;
      }

      _isSearching = true;
      notifyListeners();

      _searchResults = await _apiService.searchUsers(query, await authViewModel.getToken() ?? "");

      _isSearching = false;
      notifyListeners();
    });
  }

  void clearSearchResults() {
    _searchResults = [];
    _isSearching = false;
    _debounce?.cancel();
    notifyListeners();
  }


}
