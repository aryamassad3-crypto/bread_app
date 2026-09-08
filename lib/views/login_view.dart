import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/student_vm.dart';
import 'home_view.dart'; // استيراد الشاشة الرئيسية

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ScrollController _scrollController = ScrollController();
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocus.addListener(() => _scrollToField(_usernameFocus, 180));
    _passwordFocus.addListener(() => _scrollToField(_passwordFocus, 260));
  }

  void _scrollToField(FocusNode focusNode, double position) {
    if (focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            position,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // الاتصال بالـ ViewModel لقراءة البيانات المسجلة
    final studentVM = Provider.of<StudentViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "تسجيل الدخول",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'lib/assets/images/cookies.png',
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 25),
              const Text(
                "سجل دخولك الآن",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),

              _buildFieldTitle("الاسم الكامل"),
              _buildTextField(_usernameController, "الاسم الكامل", _usernameFocus),

              _buildFieldTitle("كلمة المرور"),
              _buildPasswordField(),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "هل نسيت كلمة المرور؟", 
                    style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)
                  ),
                  const SizedBox(width: 4),
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                    activeColor: const Color(0xFFBC6C25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  String inputUser = _usernameController.text.trim();
                  String inputPass = _passwordController.text.trim();

                  // 🔐 الفحص النظامي والتطابق 100%
                  if (inputUser == studentVM.registeredName && inputPass == studentVM.registeredPassword && inputUser.isNotEmpty) {
                    // إذا تطابقت البيانات، يتم نقله فوراً للرئيسية حركياً وبأمان
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                      (route) => false,
                    );
                  } else {
                    // إذا كانت البيانات خاطئة أو فارغة تظهر رسالة تنبيه حمراء
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("عذراً، البيانات المدخلة لا تطابق الحساب المسجل!", textAlign: TextAlign.right),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBC6C25),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "إنشاء حساب",
                      style: TextStyle(color: Color(0xFFBC6C25), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const Text(
                    "ليس لديك حساب؟", 
                    style: TextStyle(color: Colors.grey, fontSize: 16)
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, FocusNode focusNode) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: !_isPasswordVisible,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: "********",
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        prefixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off, 
            color: Colors.grey
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBC6C25), width: 1),
        ),
      ),
    );
  }
}
