
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/student_vm.dart';
import 'order_success_view.dart';
import 'delivery_success_view.dart';
import 'complaint_view.dart';
import 'notifications_view.dart';
import 'settings_view.dart';
import 'profile_view.dart';
import 'surplus_search_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Timer? _countdownTimer;

  Duration _remainingTime = const Duration(seconds: 5);

  int _currentIndex = 0;
  bool _isBooking = false;

  static const List<String> _pageTitles = [
    'الرئيسية',
    'الشكاوى',
    'الإعدادات',
    'الملف الشخصي',
    'الإشعارات',
  ];

  bool get _isBookingClosed => _remainingTime.inSeconds <= 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_remainingTime.inSeconds <= 1) {
          timer.cancel();

          setState(() {
            _remainingTime = Duration.zero;
          });

          return;
        }

        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${twoDigits(duration.inHours)}:'
        '${twoDigits(duration.inMinutes.remainder(60))}:'
        '${twoDigits(duration.inSeconds.remainder(60))}';
  }

  void _openSurplusPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const SurplusSearchScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _bookBread() async {
    if (_isBooking || _isBookingClosed) return;

    final studentVM = context.read<StudentViewModel>();

    if (studentVM.isReserved) return;

    setState(() {
      _isBooking = true;
    });

    try {
      await studentVM.toggleReservation(true);

      if (!mounted) return;

      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const OrderSuccessView(),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر حفظ الحجز. يرجى المحاولة مرة أخرى.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  Widget _buildCurrentPage(bool isOrdered) {
    switch (_currentIndex) {
      case 0:
        return _buildMainHomeContent(isOrdered);
      case 1:
        return const ComplaintView();
      case 2:
        return const SettingsView();
      case 3:
        return const ProfileView();
      case 4:
        return const NotificationsView();
      default:
        return _buildMainHomeContent(isOrdered);
    }
  }

  void _goToPage(int index) {
    if (index < 0 || index >= _pageTitles.length) return;
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  void _handleBack() {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentVM = context.watch<StudentViewModel>();
    final isOrdered = studentVM.isReserved;

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFBC6C25),
          appBar: AppBar(
            backgroundColor: const Color(0xFFBC6C25),
            elevation: 0,
            centerTitle: true,
            leadingWidth: 80,
            title: Text(
              _pageTitles[_currentIndex],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(
                  _currentIndex == 4
                      ? Icons.notifications_rounded
                      : Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => _goToPage(4),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 4,
                  bottom: 4,
                ),
                child: _currentIndex == 0
                    ? SizedBox(
                        width: 45,
                        height: 45,
                        child: Image.asset(
                          'lib/assets/images/cookies.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => _goToPage(0),
                      ),
              ),
            ],
          ),
          body: _buildCurrentPage(isOrdered),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex == 4 ? 0 : _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFBC6C25),
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _goToPage,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 28),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 24,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, size: 26),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline_rounded,
                  size: 26,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainHomeContent(bool isOrdered) {
    final bookingClosed = _isBookingClosed;

    return Container(
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أهلاً بك زميلي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isOrdered
                  ? 'طلبك لليوم: "تم الحجز."'
                  : 'طلبك لليوم: "لم يتم الحجز بعد"',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'مخصصاتك اليومية: "1 ربطة فقط"',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 35),
            Center(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: isOrdered
                      ? const Color(0x4DBC6C25)
                      : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: isOrdered
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                ),
                child: ElevatedButton(
                  onPressed: (isOrdered || _isBooking || bookingClosed)
                      ? null
                      : _bookBread,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: _isBooking
                      ? const CircularProgressIndicator(
                          color: Color(0xFFBC6C25),
                        )
                      : Text(
                          isOrdered
                              ? 'تم حجز حصتك'
                              : bookingClosed
                                  ? 'الحجز مغلق'
                                  : 'اطلب خبزك الآن',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (isOrdered || bookingClosed)
                                ? const Color(0xFFBC6C25)
                                : Colors.black54,
                            height: 1.3,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // قبل انتهاء الوقت يبقى العداد فقط.
            // بعد انتهاء الوقت يظهر نص إغلاق الحجز.
            Center(
              child: isOrdered
                  ? const Text(
                      'طلبك قيد المعالجة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  : bookingClosed
                      ? const Text(
                          'الحجز مغلق',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBC6C25),
                          ),
                        )
                      : Text(
                          _formatDuration(_remainingTime),
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                            letterSpacing: 1.5,
                          ),
                        ),
            ),

            // زر الفائض لا يظهر إلا بعد انتهاء العداد.
            if (bookingClosed) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openSurplusPage,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text(
                    'استكشف الفائض الآن',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBC6C25),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => _goToPage(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFBC6C25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDA15E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'هل تواجه أي مشكلة؟',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'يمكنك إرسال شكوى حول المشكلة',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              'آخر الطلبات:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildHistoryCard(
              'تم استلام ربطة',
              'استلمت مخصصاتك في الساعة 05:20 مساءً',
              'اليوم',
            ),
            const SizedBox(height: 10),
            _buildHistoryCard(
              'تم استلام ربطة',
              'استلمت مخصصاتك في الساعة 07:15 مساءً',
              '4 يناير 2026',
            ),
            const SizedBox(height: 10),
            _buildHistoryCard(
              'تم استلام ربطة',
              'استلمت مخصصاتك في الساعة 10:00 مساءً',
              '3 يناير 2026',
            ),
            const SizedBox(height: 15),
            const Center(
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    String title,
    String subtitle,
    String date,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const DeliverySuccessView(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
