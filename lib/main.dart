import 'package:flowkey_mobile/viewmodels/auth_viewmodel.dart';
import 'package:flowkey_mobile/viewmodels/keys_viewmodel.dart';
import 'package:flowkey_mobile/views/home_screen.dart';
import 'package:flowkey_mobile/views/login_screen.dart';
import 'package:flowkey_mobile/views/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => KeysViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/role_selection': (context) => RoleSelectionScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    ),
  );
}
