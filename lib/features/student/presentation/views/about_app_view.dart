import 'package:flutter/material.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25), // الخلفية البنية العلوية المتناسقة مع التطبيق
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 🏆 شريط العنوان العلوي (App Bar المخصص)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                  const Text(
                    "حول التطبيق",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context), // العودة للشاشة السابقة عند الضغط
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 🤍 حاوية المحتوى البيضاء ذات الزوايا الدائرية العلوية
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🥖 شعار التطبيق (نفس الصورة المستخدمة في الـ Splash Screen كما لاحظتِ)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
                          child: Image.asset(
                            'lib/assets/images/bread.png', // تأكدي أن هذا هو نفس مسار صورتكِ في الـ Splash
                            width: 110,
                            height: 110,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // 📝 القسم الأول: حول التطبيق
                      _buildSectionTitle("حول التطبيق:"),
                      _buildSectionBody(
                        "تطبيق الخبز الجامعي هو منصة رقمية رسمية تابعة لإدارة السكن الجامعي، تهدف إلى تنظيم وتسهيل حصول الطلاب على مخصصاتهم اليومية من الخبز. نسعى من خلال هذا التحول الرقمي إلى توفير وقت الطالب وضمان العدالة والكرامة في التوزيع والحد من الازدحام عبر نظام حجز وإشعارات ذكي.",
                      ),
                      const SizedBox(height: 25),

                      // ✨ القسم الثاني: مميزات الخدمة
                      _buildSectionTitle("مميزات الخدمة:"),
                      _buildBulletPoint("حجز ذكي: ضمان حصتك اليومية بضغطة زر واحدة."),
                      _buildBulletPoint("تنبيهات لحظية: إشعارات فورية عند وصول الخبز وبدء دور طابقك."),
                      _buildBulletPoint("شفافية كاملة: سجل دقيق لعمليات الحجز والاستلام الخاصة بك."),
                      _buildBulletPoint("تواصل مباشر: نظام شكاوى فعال لإيصال صوتك للإدارة مباشرة."),
                      const SizedBox(height: 25),

                      // ⚖️ القسم الثالث: قيمنا الأساسية (تلوين الكلمات المفتاحية بالبني)
                      _buildSectionTitle("قيمنا الأساسية:"),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.6, fontFamily: 'Cairo'),
                          children: [
                            TextSpan(text: "نلتزم في هذا المشروع بتقديم خدمة تقوم على "),
                            TextSpan(text: "العدالة", style: TextStyle(color: Color(0xFFBC6C25), fontWeight: FontWeight.bold)),
                            TextSpan(text: " في التوزيع، "),
                            TextSpan(text: "الشفافية", style: TextStyle(color: Color(0xFFBC6C25), fontWeight: FontWeight.bold)),
                            TextSpan(text: " في التعامل، "),
                            TextSpan(text: "والاحترام", style: TextStyle(color: Color(0xFFBC6C25), fontWeight: FontWeight.bold)),
                            TextSpan(text: " الكامل لوقت الطالب وخصوصيته بما يليق ببيئتنا الجامعية السورية."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 📊 القسم الرابع: معلومات الإصدار
                      _buildSectionTitle("معلومات الإصدار:"),
                      _buildBulletPoint("الجهة المشرفة: إدارة السكن الجامعي - وزارة التعليم العالي."),
                      _buildBulletPoint("الإصدار: 1.0.0 (نسخة تجريبية)."),
                      _buildBulletPoint("حقوق النشر: جميع الحقوق محفوظة © 2026."),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ميثود مساعدة لإنشاء عناوين الأقسام بنمط موحد
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Cairo'),
      ),
    );
  }

  // ميثود مساعدة لإنشاء النصوص الطويلة للأقسام
  Widget _buildSectionBody(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.6, fontWeight: FontWeight.w500, fontFamily: 'Cairo'),
    );
  }

  // ميثود مساعدة لإنشاء النقاط المنسقة بقوائم منقطة
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0, right: 4.0, left: 8.0),
            child: Icon(Icons.circle, size: 5, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.5, fontWeight: FontWeight.w500, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }
}
