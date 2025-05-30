import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showText = false;
  bool enableTap = false;

  @override
  void initState() {
    super.initState();

    // Tampilkan teks setelah 1 detik
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showText = true;
        });
      }
    });

    // Aktifkan tap setelah 2 detik
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          enableTap = true;
        });
      }
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enableTap ? _navigateToLogin : null,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 140,
              ),
              const SizedBox(height: 30),
              AnimatedOpacity(
                opacity: showText ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: const [
                    Text(
                      'Hello, welcome to AquaZen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Smart Water, Healthy Fish',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Tap anywhere to continue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}