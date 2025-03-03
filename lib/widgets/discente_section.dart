import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/keys_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/loans_viewmodel.dart';
import 'dart:developer' as developer;

class DiscenteSection extends StatefulWidget {
  @override
  _DiscenteSectionState createState() => _DiscenteSectionState();
}

class _DiscenteSectionState extends State<DiscenteSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final keysViewModel = Provider.of<KeysViewModel>(context, listen: false);
    final loansViewModel = Provider.of<LoansViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(authViewModel, keysViewModel, loansViewModel);
    });
  }

  Future<void> _loadData(
      AuthViewModel authViewModel,
      KeysViewModel keysViewModel,
      LoansViewModel loansViewModel
      ) async {
    try {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });

      await keysViewModel.fetchKeys(authViewModel);
      await loansViewModel.fetchActiveLoans(authViewModel);

    } catch (e, stackTrace) {
      developer.log(
        'DiscenteSection: Erro ao carregar dados',
        error: e,
        stackTrace: stackTrace,
      );

      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keysViewModel = Provider.of<KeysViewModel>(context);
    final loansViewModel = Provider.of<LoansViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    developer.log(
      'DiscenteSection build: ${loansViewModel.loans.length} empréstimos, isLoading: ${loansViewModel.isLoading}',
    );

    final userName = authViewModel.user?.name ?? "Discente";

    if (_hasError) {
      return _buildErrorState(_errorMessage);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.purple[500]!,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.purple[500]!,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  icon: Icon(Icons.vpn_key),
                  text: 'Meus Acessos',
                ),
                Tab(
                  icon: Icon(Icons.assignment),
                  text: 'Empréstimos Ativos',
                ),
              ],
            ),
          ),


          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Keys Tab
                _buildKeysTab(keysViewModel, authViewModel),

                // Loans Tab
                _buildLoansTab(loansViewModel, authViewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeysTab(KeysViewModel keysViewModel, AuthViewModel authViewModel) {
    return keysViewModel.isLoading
        ? Center(child: CircularProgressIndicator())
        : keysViewModel.keys.isEmpty
        ? _buildEmptyState('Você não possui acessos cadastrados.', Icons.vpn_key)
        : RefreshIndicator(
      onRefresh: () async {
        await keysViewModel.fetchKeys(authViewModel);
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: keysViewModel.keys.length,
        itemBuilder: (context, index) {
          final key = keysViewModel.keys[index];
          return _buildKeyCard(key);
        },
      ),
    );
  }

  Widget _buildKeyCard(key) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.purple[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[100]!,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.vpn_key, color: Colors.purple[800]!),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key.label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800]!,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      key.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoansTab(LoansViewModel loansViewModel, AuthViewModel authViewModel) {
    developer.log('Building loans tab. Loans count: ${loansViewModel.loans.length}');

    if (loansViewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (loansViewModel.loans.isEmpty) {
      return _buildEmptyState('Você não possui empréstimos ativos.', Icons.assignment);
    }


    try {
      return RefreshIndicator(
        onRefresh: () async {
          await loansViewModel.fetchActiveLoans(authViewModel);
        },
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: loansViewModel.loans.length,
          itemBuilder: (context, index) {
            try {
              final loan = loansViewModel.loans[index];
              return _buildLoanCard(loan);
            } catch (e) {
              developer.log('Erro ao construir card de empréstimo: $e');
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Erro ao exibir empréstimo #${index + 1}"),
                ),
              );
            }
          },
        ),
      );
    } catch (e) {
      developer.log('Erro ao construir lista de empréstimos: $e');
      return _buildErrorState('Erro ao exibir empréstimos: $e');
    }
  }

  Widget _buildLoanCard(loan) {

    if (loan == null) {
      developer.log("Erro: loan é nulo");
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Erro ao carregar dados do empréstimo"),
        ),
      );
    }

    final keyLabel = loan.key?.label ?? "Chave sem nome";
    final keyDescription = loan.key?.description ?? "Local não especificado";
    final givenByName = loan.givenByName ?? "Não especificado";

    final originalDate = loan.borrowedAt ?? "Data não disponível";
    String formattedDate = originalDate;

    try {
      final date = DateTime.parse(originalDate);
      formattedDate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      developer.log("Erro ao formatar data: $e");
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.purple[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.assignment, color: Colors.purple[800]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      keyLabel,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildLoanInfoRow(Icons.location_on, "Local", keyDescription),
                    Divider(height: 20),
                    _buildLoanInfoRow(Icons.person_outline, "Entregue por", givenByName),
                    Divider(height: 20),
                    _buildLoanInfoRow(Icons.access_time, "Data/Hora", formattedDate),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 70,
              color: Colors.red[400],
            ),
            SizedBox(height: 20),
            Text(
              "Ops! Algo deu errado",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                final keysViewModel = Provider.of<KeysViewModel>(context, listen: false);
                final loansViewModel = Provider.of<LoansViewModel>(context, listen: false);
                _loadData(authViewModel, keysViewModel, loansViewModel);
              },
              icon: Icon(Icons.refresh),
              label: Text("Tentar novamente"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}