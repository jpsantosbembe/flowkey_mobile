import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/admin_section.dart';
import '../widgets/discente_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final role = authViewModel.selectedRole ?? "Sem Papel";

    Widget getRoleScreen() {
      switch (role.toLowerCase()) {
        case 'admin':
          return AdminSection();
        case 'guarda':
          return GuardaScreen();
        case 'discente':
          return DiscenteSection();
        case 'coordenador':
          return CoordenadorScreen();
        default:
          return Center(child: Text('Papel não reconhecido!'));
      }
    }

    return Scaffold(
      appBar: role.toLowerCase() == 'admin' ? null : AppBar(
        title: Text('Home - $role'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await authViewModel.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: getRoleScreen(),
    );
  }
}

class GuardaScreen extends StatelessWidget {
  const GuardaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tela de Guarda', style: TextStyle(fontSize: 22)));
  }
}

class DiscenteScreen extends StatelessWidget {
  const DiscenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tela de Discente', style: TextStyle(fontSize: 22)));
  }
}

class CoordenadorScreen extends StatelessWidget {
  const CoordenadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tela de Coordenador', style: TextStyle(fontSize: 22)));
  }
}
