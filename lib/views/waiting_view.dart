import 'dart:async';
import 'package:flutter/material.dart';
import 'login_view.dart';

class WaitingView extends StatefulWidget {
  const WaitingView({Key? key}) : super(key: key);

  @override
  State<WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  @override
  void initState() {
    super.initState();
    // ⏱️ العداد الذكي: محاكاة موافقة المعتمد بعد 3 ثوانٍ ونقله تلقائياً لصفحة الدخول
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25),
      appBar: AppBar(
        backgroundColor: const Color(0xFFBC6C25),
        elevation: 0,
        automaticallyImplyLeading: false, // إلغاء سهم الرجوع لأن الانتقال مؤقت وآلي
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/waiting.png',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.hourglass_empty_rounded,
                  size: 120,
                  color: Color(0xFFDDA15E),
                );
              },
            ),
            const SizedBox(height: 35),
            const Text(
              "حسابك بانتظار تفعيل المعتمد...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "جاري فحص المستندات والموافقة الحيوية التلقائية",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
