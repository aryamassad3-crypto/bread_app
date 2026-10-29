import 'package:flutter/material.dart';

class DeliverySuccessView extends StatelessWidget {
  const DeliverySuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25), // لون الخلفية البني العلوي
      appBar: AppBar(
        backgroundColor: const Color(0xFFBC6C25),
        elevation: 0,
        centerTitle: true,
        
        title: const Text(
          "تأكيد الاستلام",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // سهم الرجوع جهة اليمين متناسق مع لغة التطبيق العربية
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // أيقونة جرس التنبيهات جهة اليسار
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
            onPressed: () {},
          ),
        ],
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // 🟠 الدائرة البنية الكبيرة وبداخلها علامة الصح العريضة (Bold) كالصورة تماماً
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFFBC6C25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 110, // حجم كبير لتعبئة الدائرة
                  color: Colors.white,
                  weight: 900, // إجبار الأيقونة على الظهور بأعلى درجات العرض والسمك (Bold)
                ),
              ),
              const SizedBox(height: 40),

              // 📝 نص تأكيد نجاح استلام الخبز
              const Text(
                "تم استلام حصتك لليوم بنجاح",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      // 🧭 شريط التنقل السفلي المعتمد والمطابق لهوية شاشات الطالب
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // تفعيل أيقونة الرئيسية باللون البني دائمًا
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFBC6C25),
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 28), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded, size: 24), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined, size: 26), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 26), label: ""),
        ],
      ),
    );
  }
}
