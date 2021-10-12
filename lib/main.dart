import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bpm_mobile/screens/notifications_screen.dart';
import 'package:bpm_mobile/screens/update_order_screen.dart';
import 'package:bpm_mobile/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bpm_mobile/screens/screens.dart';
import 'package:bpm_mobile/services/services.dart';
 
void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/flutter_devs',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        locked: true,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/res_custom_notification',
      ),
    ],
  );
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => NotificationsService()),
        ChangeNotifierProvider(create: (_) => DashboardService()),
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
        'update_order': (_) => const UpdateOrderScreen(),
        'notifications': (_) => const NotificationScreen(),
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
