import 'package:flowkey_mobile/viewmodels/auth_viewmodel.dart';
import 'package:flowkey_mobile/viewmodels/keys_viewmodel.dart';
import 'package:flowkey_mobile/viewmodels/loans_viewmodel.dart';
import 'package:flowkey_mobile/viewmodels/manage_access_viewmodel.dart';
import 'package:flowkey_mobile/views/home_screen.dart';
import 'package:flowkey_mobile/views/login_screen.dart';
import 'package:flowkey_mobile/views/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => KeysViewModel()),
        ChangeNotifierProvider(create: (_) => LoansViewModel()),
        ChangeNotifierProvider(create: (_) => ManageAccessViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlowKey',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/role_selection': (context) => RoleSelectionScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Verificar se o usuário já está logado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Atraso mínimo para mostrar a splash screen
    await Future.delayed(Duration(seconds: 2));

    final isLoggedIn = await authViewModel.checkLoggedInUser();

    if (isLoggedIn) {
      if (authViewModel.selectedRole != null) {
        // Se já tem papel selecionado, vai direto para home
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Se não tem papel selecionado, vai para seleção de papel
        Navigator.of(context).pushReplacementNamed('/role_selection');
      }
    } else {
      // Se não está logado, vai para tela de login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[900]!,
              Colors.blue[700]!,
              Colors.blue[500]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animado
              FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.vpn_key,
                      size: 80,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Nome do app
              FadeTransition(
                opacity: _animation,
                child: Text(
                  "FlowKey",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Subtítulo
              FadeTransition(
                opacity: _animation,
                child: Text(
                  "Sistema de Controle de Chaves",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),

              SizedBox(height: 50),

              // Indicador de carregamento
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}