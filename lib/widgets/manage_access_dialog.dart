import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/key_model.dart';
import '../viewmodels/manage_access_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class ManageAccessDialog extends StatefulWidget {
  final KeyModel keyModel;

  ManageAccessDialog({required this.keyModel});

  @override
  _ManageAccessDialogState createState() => _ManageAccessDialogState();
}

class _ManageAccessDialogState extends State<ManageAccessDialog> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final manageAccessViewModel = Provider.of<ManageAccessViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();
      manageAccessViewModel.clearSearchResults();
      manageAccessViewModel.fetchAuthorizations(authViewModel, widget.keyModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final manageAccessViewModel = Provider.of<ManageAccessViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: Container(
        width: 500,
        height: 500,
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gerenciar Acessos",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.keyModel.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),

            // Search container
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isSearchExpanded ? 210 : 80,
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Pesquisar usuário...",
                            prefixIcon: Icon(Icons.search, color: Colors.blue[600]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          onChanged: (value) {
                            if (value.length > 2) {
                              setState(() => _isSearchExpanded = true);
                              manageAccessViewModel.searchUsers(authViewModel, value);
                            } else if (value.isEmpty) {
                              setState(() => _isSearchExpanded = false);
                              manageAccessViewModel.clearSearchResults();
                            }
                          },
                        ),
                      ),
                      if (_isSearchExpanded && _searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _isSearchExpanded = false);
                            manageAccessViewModel.clearSearchResults();
                          },
                        ),
                    ],
                  ),

                  // Search results
                  if (_isSearchExpanded)
                    Expanded(
                      child: manageAccessViewModel.isSearching
                          ? Center(child: CircularProgressIndicator())
                          : manageAccessViewModel.searchResults.isEmpty && _searchController.text.length > 2
                          ? Center(
                        child: Text(
                          "Nenhum usuário encontrado",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: manageAccessViewModel.searchResults.length,
                        itemBuilder: (context, index) {
                          final user = manageAccessViewModel.searchResults[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                child: Icon(Icons.person, color: Colors.blue[800]),
                              ),
                              title: Text(
                                user.name,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                user.email,
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.add_circle, color: Colors.green[600]),
                                onPressed: () {
                                  // Logic to add authorization will be implemented later
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Função para adicionar acesso ainda não implementada"),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Title for authorized users list
            Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                "Usuários Autorizados",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),

            // List of authorized users
            Expanded(
              child: manageAccessViewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : manageAccessViewModel.authorizations.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Nenhum usuário autorizado",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                itemCount: manageAccessViewModel.authorizations.length,
                itemBuilder: (context, index) {
                  final auth = manageAccessViewModel.authorizations[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          auth.user.name.isNotEmpty ? auth.user.name[0].toUpperCase() : "?",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        auth.user.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(auth.user.email),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                        onPressed: () {
                          _showDeleteConfirmation(context, auth, manageAccessViewModel, authViewModel);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, auth, ManageAccessViewModel manageAccessViewModel, AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[400], size: 28),
            SizedBox(width: 8),
            Text("Remover Acesso"),
          ],
        ),
        content: Text(
          "Tem certeza que deseja remover o acesso de ${auth.user.name}?\n\nEsta ação não pode ser desfeita.",
          style: TextStyle(color: Colors.grey[800]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await manageAccessViewModel.removeAuthorization(
                authViewModel,
                auth.userId,
                widget.keyModel.id,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Remover", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}