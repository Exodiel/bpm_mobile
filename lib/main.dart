import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bpm_mobile/screens/screens.dart';
import 'package:bpm_mobile/services/services.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'checking': (_) => const CheckAuthScreen(),
        'home': (_) => const HomeScreen(),
        'product': (_) => const ProductScreen(),
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
      ),
    );
  }
}
