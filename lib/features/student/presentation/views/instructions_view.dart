import 'package:flutter/material.dart';

class InstructionsView extends StatelessWidget {
  const InstructionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25), // اللون البني العلوي المعتمد
      appBar: AppBar(
        backgroundColor: const Color(0xFFBC6C25),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "التعليمات",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // 🔙 سهم الرجوع يحل محل الكوكيز جهة اليسار (Actions) حسب القاعدة الذهبية
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 22),
              onPressed: () {
                Navigator.pop(context); // العودة السلسة لصفحة الإعدادات
              },
            ),
          ),
        ],
        // 🔔 جرس الإشعارات يبقى ثابتاً في مكانه جهة اليمين
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
            onPressed: () {},
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📖 القسم الأول: دليل المستخدم
              _buildSectionTitle("دليل المستخدم:"),
              _buildSectionBody(
                "يسعدنا مساعدتك في تنظيم حجز حصتك اليومية من الخبز، فيما يلي الخطوات الأساسية لاستخدام التطبيق والإجابة على أكثر التساؤلات شيوعاً لضمان أفضل تجربة لك.",
              ),
              const SizedBox(height: 25),

              // 🚶‍♂️ القسم الثاني: خطوات الاستخدام (قائمة رقمية متسلسلة)
              _buildSectionTitle("خطوات الاستخدام:"),
              _buildNumberedPoint(1, "تسجيل الدخول: قم بالدخول باستخدام رقم هاتفك وكلمة المرور التي حصلت عليها من معتمد وحدتك السكنية."),
              _buildNumberedPoint(2, "حجز الحصة: اضغط على زر \"احجز الآن\" في الصفحة الرئيسية قبل الساعة 4 عصراً لتثبيت طلبك لليوم."),
              _buildNumberedPoint(3, "متابعة الإشعارات: انتظر وصول إشعار \"بدء التوزيع\" الخاص بطابقك للتوجه إلى مكان تواجد المعتمد."),
              _buildNumberedPoint(4, "تأكيد الاستلام: عند وصولك، قم بتأكيد استلامك للخبز عبر المعتمد ليتم تحديث سجل عملياتك في التطبيق."),
              _buildNumberedPoint(5, "الشكاوى: في حال واجهت أي مشكلة، استخدم زر الشكاوى لتزويد المشرفين بصورة أو فيديو توضيحي لما حدث."),
              const SizedBox(height: 25),

              // ❓ القسم الثالث: الأسئلة الشائعة (قوائم منسدلة تفاعلية ناعمة)
              _buildSectionTitle("الأسئلة الشائعة:"),
              const SizedBox(height: 8),
              _buildFAQTile("هل يحق لي طلب أكثر من ربطة خبز في اليوم؟", "لا، المخصصات الحالية هي ربطة واحدة فقط لكل طالب يومياً لضمان التوزيع العادل لجميع سكان السكن الجامعي."),
              _buildFAQTile("ماذا أفعل إذا انتهى الوقت ولم أقم بالطلب؟", "يغلق الحجز اليومي في تمام الساعة 4 عصراً، وفي حال فوات الوقت يمكنك الحجز في اليوم التالي مباشرة."),
              _buildFAQTile("كيف يمكنني تغيير كلمة المرور؟", "من صفحة الإعدادات، اضغط على خيار \"تغيير كلمة المرور\" واتبع الخطوات الأمنية لتحديثها."),
              _buildFAQTile("هل يمكنني تقديم شكوى بخصوص جودة الخبز؟", "نعم بكل تأكيد، يمكنك الذهاب لقسم الشكاوى واختيار نوع المشكلة وإرفاق صورة واضحة لتصل للإدارة فوراً."),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ميثود مساعدة لإنشاء عناوين الأقسام
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  // ميثود مساعدة لإنشاء الفقرات النصية
  Widget _buildSectionBody(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.6, fontWeight: FontWeight.w500),
    );
  }

  // ميثود مساعدة لبناء القائمة الرقمية المتسلسلة بدقة وبشكل مريح للعين
  Widget _buildNumberedPoint(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. ",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFBC6C25)),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود مساعدة لبناء الـ ExpansionTile التفاعلي للأسئلة الشائعة كالفجما
  Widget _buildFAQTile(String question, String answer) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent), // لإخفاء الخطوط الإضافية للـ Tile
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          iconColor: const Color(0xFFBC6C25),
          collapsedIconColor: Colors.grey,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 14.0),
              child: Text(
                answer,
                style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
