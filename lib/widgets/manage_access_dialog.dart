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

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final manageAccessViewModel = Provider.of<ManageAccessViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear(); // 🔥 Limpa o campo de pesquisa
      manageAccessViewModel.clearSearchResults(); // 🔥 Limpa os resultados da pesquisa
      manageAccessViewModel.fetchAuthorizations(authViewModel, widget.keyModel.id);
    });
  }


  @override
  Widget build(BuildContext context) {
    final manageAccessViewModel = Provider.of<ManageAccessViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 500,
        height: 500, // Adjusted to accommodate search results
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Gerenciar Acessos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            SizedBox(height: 5),

            // Key name and description
            Text(
              "${widget.keyModel.label} - ${widget.keyModel.description}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 15),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Adicionar pessoa...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                manageAccessViewModel.searchUsers(authViewModel, value);
              },
            ),
            SizedBox(height: 10),

            // Search results
            manageAccessViewModel.isSearching
                ? Center(child: CircularProgressIndicator())
                : manageAccessViewModel.searchResults.isNotEmpty
                ? Container(
              height: 150, // Fixed height to avoid layout issues
              child: ListView(
                children: manageAccessViewModel.searchResults.map((user) {
                  return ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: Icon(Icons.add, color: Colors.green),
                      onPressed: () async {
                        // Logic to add authorization will be implemented later
                        // Example placeholder:
                        // await manageAccessViewModel.addAuthorization(
                        //   authViewModel,
                        //   user.id,
                        //   widget.keyModel.id,
                        // );
                      },
                    ),
                  );
                }).toList(),
              ),
            )
                : SizedBox.shrink(),

            SizedBox(height: 10),

            // List of authorized users
            Expanded(
              child: manageAccessViewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : manageAccessViewModel.authorizations.isEmpty
                  ? Center(
                child: Text(
                  "Nenhum usuário autorizado.",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView(
                children: manageAccessViewModel.authorizations.map((auth) {
                  return ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text(auth.user.name),
                    subtitle: Text(auth.user.email),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Remover Acesso"),
                            content: Text("Tem certeza que deseja remover o acesso de ${auth.user.name}?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop(); // Close the alert
                                  await manageAccessViewModel.removeAuthorization(
                                    authViewModel,
                                    auth.user.id,
                                    widget.keyModel.id,
                                  );
                                },
                                child: Text("Remover", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}