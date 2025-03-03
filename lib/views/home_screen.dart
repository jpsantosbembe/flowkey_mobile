import 'package:flowkey_mobile/views/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/admin_section.dart';
import '../widgets/discente_section.dart';
import '../widgets/coordenador_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final role = authViewModel.selectedRole ?? "Sem Papel";
    final user = authViewModel.user;

    Widget getRoleScreen() {
      switch (role.toLowerCase()) {
        case 'admin':
          return AdminSection();
        case 'guarda':
          return GuardaScreen();
        case 'discente':
          return DiscenteSection();
        case 'coordenador':
          return CoordenadorSection();
        default:
          return Center(child: Text('Papel não reconhecido!'));
      }
    }

    return Scaffold(
      appBar: role.toLowerCase() == 'admin' ? null : AppBar(
        backgroundColor: getRoleColor(role),
        elevation: 0,
        title: Row(
          children: [
            Icon(
              getRoleIcon(role),
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              getRoleTitle(role),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Perfil do usuário
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.3),
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ProfileDialog(user: user),
              );
            },
          ),
          // Botão de logout
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
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

  // Função para obter a cor baseada no papel do usuário
  Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'coordenador':
        return Colors.blue[800]!;
      case 'discente':
        return Colors.indigo[800]!;
      case 'guarda':
        return Colors.green[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  // Função para obter o ícone baseado no papel do usuário
  IconData getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'coordenador':
        return Icons.supervised_user_circle;
      case 'discente':
        return Icons.school;
      case 'guarda':
        return Icons.security;
      default:
        return Icons.person;
    }
  }

  // Função para obter o título baseado no papel do usuário
  String getRoleTitle(String role) {
    switch (role.toLowerCase()) {
      case 'coordenador':
        return 'Portal do Coordenador';
      case 'discente':
        return 'Portal do Discente';
      case 'guarda':
        return 'Portal do Guarda';
      default:
        return 'Portal FlowKey';
    }
  }
}

class GuardaScreen extends StatelessWidget {
  const GuardaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Tela de Guarda', style: TextStyle(fontSize: 22)));
  }
}