import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/student_vm.dart';
class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  // برمجية التحكم في النصوص المدخلة لحقول الأمان
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  // متغير حالة ذكي للتحكم في عرض واجهة المدخلات أو واجهة النجاح المباشرة كالفجما
  bool _isSuccessState = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBC6C25), // اللون البني العلوي الثابت
      appBar: AppBar(
        backgroundColor: const Color(0xFFBC6C25),
        elevation: 0,
        centerTitle: true,
        // تغيير العنوان ديناميكياً لتطابق الشاشتين بالفيجما تماماً
        title: Text(
          _isSuccessState ? "تأكيد الاستلام" : "تغيير كلمة المرور",
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // 🔙 سهم الرجوع المعتمد يساراً للعودة لصفحة الإعدادات حسب قاعدتكِ الذهبية
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 22),
              onPressed: () {
                Navigator.pop(context); // Erase page from navigation tree
              },
            ),
          ),
        ],
        // 🔔 جرس الإشعارات الثابت يميناً في كل الصفحات
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
        // تبديل الواجهة بنعومة وسلاسة فورية حسب الضغط
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSuccessState ? _buildSuccessBody() : _buildInputBody(),
        ),
      ),
    );
  }

  // 🔒 1. واجهة إدخال كلمات المرور الحالية والجديدة
  Widget _buildInputBody() {
    return SingleChildScrollView(
      key: const ValueKey('InputBody'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "تغيير كلمة المرور",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 25),

          _buildFieldLabel("كلمة المرور الحالية"),
          _buildPasswordField(_currentPasswordController),
          const SizedBox(height: 20),

          _buildFieldLabel("كلمة المرور الجديدة"),
          _buildPasswordField(_newPasswordController),
          const SizedBox(height: 45),

          // 🟫 زر تأكيد التغيير البني الممتد كالتصميم مع منطق الـ Provider المتكامل
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // جلب الـ ViewModel النشط حياً بدون الاستماع لتفادي الأخطاء
                final studentVM = Provider.of<StudentViewModel>(context, listen: false);

                // 1. فحص الحقول للتأكد من عدم تركها فارغة
                if (_currentPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("يرجى تعبئة كافة الحقول أولاً لحماية حسابك!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // 2. فحص هل كلمة المرور الحالية المكتوبة تطابق الحقيقية المخزنة في الـ ViewModel فعلاً
                if (_currentPasswordController.text != studentVM.studentPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("كلمة المرور الحالية التي أدخلتها غير صحيحة!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // 3. تحديث كلمة المرور بشكل حقيقي ومباشر عبر دالة الـ registerStudent الشاملة في الـ ViewModel 🔑✨
                setState(() {
                  studentVM.registerStudent(
                    name: studentVM.studentName,
                    password: _newPasswordController.text, // تمرير الكلمة الجديدة هنا بنجاح
                    uniId: studentVM.uniId,
                    phone: studentVM.phone,
                    unit: studentVM.unit,
                    floor: studentVM.floor,
                    room: studentVM.room,
                  );
                  _isSuccessState = true; // الانتقال لواجهة النجاح بالفيجما
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBC6C25),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                "تأكيد",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //  2. واجهة تأكيد النجاح الدائرية المطابقة للفيجما
  Widget _buildSuccessBody() {
    return Center(
      key: const ValueKey('SuccessBody'),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  علامة الصح الدائرية الأنيقة بوسط الواجهة
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                color: Color(0xFFBC6C25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 75,
              ),
            ),
            const SizedBox(height: 35),
            
            // 📝 نص النجاح المنسق والواضح تماماً كصورتكِ
            const Text(
              "تم تغيير كلمة مرورك بنجاح يرجى استخدامها\nفي المرة القادمة عند تسجيل الدخول.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ميثود مساعدة لإنشاء ملصقات الحقول العلوية الرمادية
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 2.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ميثود مساعدة لبناء حقول كلمة المرور المؤمنة والمشفرة بالنقاط مع أيقونة القفل
  Widget _buildPasswordField(TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true, // لإخفاء وتعمية كلمة المرور بنقاط أمان دائرية
      decoration: InputDecoration(
        hintText: "********",
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, letterSpacing: 2),
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
        ),
      ),
    );
  }
}
