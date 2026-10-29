
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      context.go('/register');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/bread.png',
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDA15E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bakery_dining,
                    size: 80,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'خبزك واصل لسكنك',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
