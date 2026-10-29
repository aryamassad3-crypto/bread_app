import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'surplus_search_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool _bakingFinished = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // مؤقت تجريبي فقط: استبدله بوقت الخَبز الحقيقي لاحقاً.
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _bakingFinished = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text('الرئيسية'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/bread.png',
                width: 32,
                height: 32,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.bakery_dining),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'أهلاً بك زميلي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5D8),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _bakingFinished ? 'انتهى وقت الخَبز' : 'الخبز قيد التحضير',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_bakingFinished)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SurplusSearchScreen(),
                    ),
                  );
                },
                child: const Text('استكشف الفائض الآن'),
              )
            else
              const Center(
                child: Text(
                  'ستتاح خدمة البحث عن الفائض بعد انتهاء الوقت التجريبي.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
          ],
        ),
      ),
    );
  }
}