import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/auth-gate');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_outline,
              size: 90,
              color: Colors.white,
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(),

            const SizedBox(height: 24),

            const Text(
              'TimeNest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms),

            const SizedBox(height: 12),

            const Text(
              'Helping Parents Help Parents',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}