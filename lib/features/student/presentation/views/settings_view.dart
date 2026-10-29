import 'package:flutter/material.dart';
import 'login_view.dart'; 
import 'instructions_view.dart';
import 'change_password_view.dart';
import 'about_app_view.dart'; 

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // متغير تفاعلي للتحكم بوضعية المفتاح (Switch) الخاص بكتم الإشعارات
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              "الإعدادات:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 25),

            // 1. خيار حول التطبيق
            _buildNavigationOption(
              title: "حول التطبيق",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutAppView()),
                );
              },
            ),

            // 2. خيار تعليمات الاستخدام
            _buildNavigationOption(
              title: "تعليمات الاستخدام",
              onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InstructionsView()),
    );
  },
),
 
            // 3. خيار تغيير كلمة المرور
            _buildNavigationOption(
              title: "تغيير كلمة المرور",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordView()),
                );
              },
            ),

            // 4. خيار كتم الإشعارات مضاف إليه الـ Switch التفاعلي كالتصميم تماماً
            _buildSwitchOption(
              title: "كتم الإشعارات",
              value: _isMuted,
              onChanged: (bool newValue) {
                setState(() {
                  _isMuted = newValue;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newValue ? "تم تفعيل وضع كتم الإشعارات" : "تم إلغاء كتم الإشعارات"),
                    backgroundColor: const Color(0xFFBC6C25),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 5. زر تسجيل الخروج التفاعلي مع الأيقونة واللون المخصص
            _buildLogoutOption(context),
          ],
        ),
      ),
    );
  }

  // 📦 الـ Widget المساعد لبناء الخيارات القياسية المتبوعة بسهم رمادي ناعم وخط فاصل
  Widget _buildNavigationOption({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
        ],
      ),
    );
  }

  // 📦 الـ Widget المساعد لبناء خيار الـ Switch التفاعلي لكتم الإشعارات
  Widget _buildSwitchOption({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFFBC6C25), // اللون البني المعتمد عند التفعيل
                activeTrackColor: const Color(0xFFDDA15E).withOpacity(0.4),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade200,
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
      ],
    );
  }

  // 🚪 الـ Widget المساعد لزر تسجيل الخروج والعودة لصفحة الـ Login فوراً برمجياً
  Widget _buildLogoutOption(BuildContext context) {
    return InkWell(
      onTap: () {
        // تنظيف الواجهات والعودة لصفحة تسجيل الدخول من الصفر
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم تسجيل الخروج بنجاح. نراك قريباً!")),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // محاذاة النص والأيقونة جهة اليسار والوسط كصورتكِ
          children: [
            const Text(
              "تسجيل الخروج",
              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Icon(Icons.logout_rounded, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة سريعة لإظهار رسائل منبثقة أنيقة عند النقر
  void _showFeatureSnackBar(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("جاري فتح قسم $featureName..."),
        backgroundColor: const Color(0xFFBC6C25),
      ),
    );
  }
}
