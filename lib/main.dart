import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'auth/screens/auth_shell.dart';
import 'auth/screens/forgot_password_page.dart';
import 'auth/screens/reset_password_page.dart';
import 'auth/screens/change_password_page.dart';
import 'bookings/screens/bookings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Sports',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthShell(),
      routes: {
        '/forgot': (_) => const ForgotPasswordPage(),
        '/reset': (_) => const ResetPasswordPage(),
        '/change': (_) => const ChangePasswordPage(),
        '/bookings': (_) => const BookingsPage(),
      },
    );
  }
}
