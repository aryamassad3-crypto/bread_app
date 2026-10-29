import 'package:flutter/material.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25), // لون الخلفية البني العلوي
      appBar: AppBar(
        backgroundColor: const Color(0xFFBC6C25),
        elevation: 0,
        centerTitle: true,
        // سهم الرجوع جهة اليمين بناءً على لغة النظام العربية
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
              const SizedBox(height: 40),
              // 🟠 الدائرة البنية الكبيرة وبداخلها علامة الصح البيضاء
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFFBC6C25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 110,
                  color: Colors.white,
                  weight: 1100,
                ),
              ),
              const SizedBox(height: 35),

              // 📝 نصوص تأكيد نجاح حجز ربطة الخبز لليوم
              const Text(
                "تم حجز 1 ربطة خبز لليوم بنجاح",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              // 🔢 كرت عرض رقم الطلب المنظم بالكامل والاتجاه الصحيح للمؤشر
              const Text(
                "رقم الطلب: #2458",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 100),

              // 🟫 زر التنبيه العريض السفلي والمكتوب بوضوح كالصورة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFBC6C25),
                  borderRadius: BorderRadius.circular(24), // حواف مستديرة ناعمة كصورتكِ تماماً
                ),
                child: const Text(
                  "ستصلك رسالة تنبيه فور بدء المعتمد بعملية التوزيع",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // 🧭 شريط التنقل السفلي المنسق ليتطابق مع واجهات الطالب
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
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
