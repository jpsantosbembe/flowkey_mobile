import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/keys_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/loans_viewmodel.dart';

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
    final loansViewModel = Provider.of<LoansViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      keysViewModel.fetchKeys(authViewModel);
      loansViewModel.fetchActiveLoans(authViewModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keysViewModel = Provider.of<KeysViewModel>(context);
    final loansViewModel = Provider.of<LoansViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // **Seção "Meus Acessos"**
            Text(
              'Meus Acessos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            keysViewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : keysViewModel.keys.isEmpty
                ? Center(child: Text("Nenhuma chave encontrada."))
                : Column(
              children: keysViewModel.keys.map((key) {
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
              }).toList(),
            ),

            SizedBox(height: 20),

            // **Seção "Empréstimos Ativos"**
            Text(
              'Empréstimos Ativos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            loansViewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : loansViewModel.loans.isEmpty
                ? Center(child: Text("Nenhum empréstimo ativo encontrado."))
                : Column(
              children: loansViewModel.loans.map((loan) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.assignment, color: Colors.green),
                    title: Text(
                      loan.key.label,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Local: ${loan.key.description}"),
                        Text("Entregue por: ${loan.givenByName}"),
                        Text("Emprestado em: ${loan.borrowedAt}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
