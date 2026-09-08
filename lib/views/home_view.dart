import 'dart:async';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Timer _countdownTimer;
  Duration _remainingTime = const Duration(hours: 2, minutes: 15, seconds: 36);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds == 0) {
        setState(() {
          _countdownTimer.cancel();
        });
      } else {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25),
      appBar: AppBar(
        backgroundColor: const Color(0xFFBC6C25),
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80,
        title: const Text(
          "الرئيسية",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
        // 🍪 تم وضع صورة الكوكيز مباشرة بمكان الأيقونة تماماً كطلبكِ وبصورة صافية
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'lib/assets/images/bread.png',
            fit: BoxFit.contain,
          ),
        ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "أهلاً بك زميلي",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 6),
              const Text(
                'طلبك لليوم: "لم يتم الحجز بعد"',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              const Text(
                'مخصصاتك اليومية: "1 ربطة فقط"',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 35),

              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("جاري إرسال طلب حجز الخبز لمعتمد وحدتك السكنية...", textAlign: TextAlign.right),
                          backgroundColor: Color(0xFFBC6C25),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text(
                      "اطلب خبزك الآن",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  _formatDuration(_remainingTime),
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFBC6C25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 14),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "هل تواجه أي مشكلة؟",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "يمكنك إرسال شكوى حول المشكلة",
                          style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDA15E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.warning_amber_rounded, size: 28, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              const Text(
                "آخر الطلبات:",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),

              _buildHistoryCard("تم استلام ربطة", "استلمت مخصصاتك في الساعة 05:20 مساءً", "اليوم"),
              const SizedBox(height: 10),

              _buildHistoryCard("تم استلام ربطة", "استلمت مخصصاتك في الساعة 07:15 مساءً", "4 يناير 2026"),
              const SizedBox(height: 10),

              _buildHistoryCard("تم استلام ربطة", "استلمت مخصصاتك في الساعة 10:00 مساءً", "3 يناير 2026"),
              
              const SizedBox(height: 15),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFBC6C25),
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 26), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined, size: 26), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded, size: 24), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 28), label: ""),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String title, String subtitle, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Row(
        children: [
          Text(
            date,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
