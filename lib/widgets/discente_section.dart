import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/keys_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class DiscenteSection extends StatefulWidget {
  @override
  _DiscenteSectionState createState() => _DiscenteSectionState();
}

class _DiscenteSectionState extends State<DiscenteSection> {
  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final keysViewModel = Provider.of<KeysViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      keysViewModel.fetchKeys(authViewModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keysViewModel = Provider.of<KeysViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meus Acessos', // ✅ Título da seção
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: keysViewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : keysViewModel.keys.isEmpty
                  ? Center(child: Text("Nenhuma chave encontrada."))
                  : ListView.builder(
                itemCount: keysViewModel.keys.length,
                itemBuilder: (context, index) {
                  final key = keysViewModel.keys[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.vpn_key, color: Colors.blue),
                      title: Text(
                        key.label,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(key.description),
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
}
