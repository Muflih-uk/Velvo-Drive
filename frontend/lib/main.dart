import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/controllers/data_controller.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/provider/auth_provider.dart';
import 'package:shop/provider/bottom_nav_provider.dart';
import 'package:shop/provider/data_provider.dart';
import 'package:shop/provider/profile_provider.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/screens/auth/views/login_screen.dart';
import 'package:shop/screens/onbording/views/onbording_screnn.dart';
import 'package:shop/theme/app_theme.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider(DataController())),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider())
      ],
      child: const MyApp(),
    ),);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VelvoDrive',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      home: const DecisionGate(),
    );
  }
}

class DecisionGate extends StatelessWidget {
  const DecisionGate({super.key});

  Future<bool> _hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSeenOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); 
        }
        if (snapshot.hasData && snapshot.data == true) {
          return const AuthWrapper();
        } else {
          // Otherwise, show the onboarding screen
          return const OnBordingScreen();
        }
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const SplashScreen();
    }

    if (authProvider.isAuthenticated) {
      return const EntryPoint();
    } else {
      return const LoginScreen();
    }
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
