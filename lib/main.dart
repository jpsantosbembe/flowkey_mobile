import 'package:flowkey_mobile/viewmodels/auth_viewmodel.dart';
import 'package:flowkey_mobile/views/home_screen.dart';
import 'package:flowkey_mobile/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login' : (context) => LoginScreen(),
          '/home': (context) =>   HomeScreen(),
        },
      ),
    )
  );
}