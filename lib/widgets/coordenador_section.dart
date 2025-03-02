import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/keys_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/loans_viewmodel.dart';
import '../widgets/manage_access_dialog.dart';

class CoordenadorSection extends StatefulWidget {
  @override
  _CoordenadorSectionState createState() => _CoordenadorSectionState();
}

class _CoordenadorSectionState extends State<CoordenadorSection> {
  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final keysViewModel = Provider.of<KeysViewModel>(context, listen: false);
    final loansViewModel = Provider.of<LoansViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      keysViewModel.fetchKeys(authViewModel, isCoordinator: true);
      loansViewModel.fetchActiveLoans(authViewModel, isCoordinator: true);
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
            // **Seção "Chaves Coordenadas"**
            Text(
              'Chaves Coordenadas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            keysViewModel.isLoading
                ? Center(child: CircularProgressIndicator())
                : keysViewModel.keys.isEmpty
                ? Center(child: Text("Nenhuma chave coordenada encontrada."))
                : Column(
              children: keysViewModel.keys.map((key) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.vpn_key, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                key.label,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        // **Descrição da chave**
                        Text(
                          key.description,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(height: 10),

                        // **Botão "Gerenciar Acessos" abaixo da descrição**
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ManageAccessDialog(keyModel: key), // 🔥 Passa a chave selecionada
                              );
                            },
                            child: Text("Gerenciar Acessos"),
                          ),

                        ),
                      ],
                    ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.assignment, color: Colors.green),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                loan.key.label,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Text(
                          "Emprestado para: ${loan.borrowedByName}",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          "Local: ${loan.key.description}",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          "Entregue por: ${loan.givenByName}",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          "Emprestado em: ${loan.borrowedAt}",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
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
