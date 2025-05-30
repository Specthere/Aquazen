import 'package:aquazenfix/model/ph_model.dart';
import 'package:aquazenfix/service/mqtt_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../view/splash_screen.dart';
import '../view/login_screen.dart';
import '../view/main_screen.dart';

import '../service/auth_service.dart';
import '../controller/volume_air_controller.dart';
import '../controller/ph_controller.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => VolumeAirController()),
        ChangeNotifierProvider(
          create: (_) => PhController(PhModel(), MqttService()),
        ),
        // Tambahkan controller lainnya kalau ada
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          final authService = Provider.of<AuthService>(context, listen: false);
          if (authService.isLoggedIn) {
            return const MainScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
