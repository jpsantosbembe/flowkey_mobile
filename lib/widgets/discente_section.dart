import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/keys_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/loans_viewmodel.dart';

class DiscenteSection extends StatefulWidget {
  @override
  _DiscenteSectionState createState() => _DiscenteSectionState();
}

class _DiscenteSectionState extends State<DiscenteSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final keysViewModel = Provider.of<KeysViewModel>(context, listen: false);
    final loansViewModel = Provider.of<LoansViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      keysViewModel.fetchKeys(authViewModel);
      loansViewModel.fetchActiveLoans(authViewModel);
    });
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
    final userName = authViewModel.user?.name ?? "Discente";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header section with welcome message
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo(a), $userName',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Acesso de Discente',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigo[600],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Tab bar for navigation
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
              labelColor: Colors.indigo[800],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.indigo[800],
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

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Keys Tab
                _buildKeysTab(keysViewModel),

                // Loans Tab
                _buildLoansTab(loansViewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeysTab(KeysViewModel keysViewModel) {
    return keysViewModel.isLoading
        ? Center(child: CircularProgressIndicator())
        : keysViewModel.keys.isEmpty
        ? _buildEmptyState('Você não possui acessos cadastrados.', Icons.vpn_key)
        : RefreshIndicator(
      onRefresh: () async {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
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
            colors: [Colors.white, Colors.indigo[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.vpn_key, color: Colors.indigo[800]),
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
                        color: Colors.indigo[800],
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

  Widget _buildLoansTab(LoansViewModel loansViewModel) {
    return loansViewModel.isLoading
        ? Center(child: CircularProgressIndicator())
        : loansViewModel.loans.isEmpty
        ? _buildEmptyState('Você não possui empréstimos ativos.', Icons.assignment)
        : RefreshIndicator(
      onRefresh: () async {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        await loansViewModel.fetchActiveLoans(authViewModel);
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: loansViewModel.loans.length,
        itemBuilder: (context, index) {
          final loan = loansViewModel.loans[index];
          return _buildLoanCard(loan);
        },
      ),
    );
  }

  Widget _buildLoanCard(loan) {
    // Format the borrowedAt date
    final originalDate = loan.borrowedAt;
    String formattedDate = originalDate;

    try {
      final date = DateTime.parse(originalDate);
      formattedDate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      // Keep original format if parsing fails
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
                      loan.key.label,
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
                    _buildLoanInfoRow(Icons.location_on, "Local", loan.key.description),
                    Divider(height: 20),
                    _buildLoanInfoRow(Icons.person_outline, "Entregue por", loan.givenByName),
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
}