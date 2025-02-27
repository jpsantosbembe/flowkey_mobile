import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthViewModel>(context, listen: false).loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
      body: Center(
        child: user == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo, ${user.name}!', style: TextStyle(fontSize: 22)),
            Text('Email: ${user.email}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
