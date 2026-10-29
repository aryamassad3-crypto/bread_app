
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../view_models/student_vm.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentVM = context.read<StudentViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "تسجيل الدخول",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              Image.asset(
                'lib/assets/images/cookies.png',
                height: 160,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              const Text(
                "سجل دخولك الآن:",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              _buildFieldTitle("الاسم الكامل"),

              TextField(
                controller: _nameController,
                textAlign: TextAlign.right,
                decoration: _buildInputDecoration(
                  "أدخل اسمك الكامل الموحد",
                ),
              ),

              const SizedBox(height: 15),

              _buildFieldTitle("كلمة المرور"),

              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "********",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFAFAFA),
                  prefixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFBC6C25),
                      width: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 45),

              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        final enteredName =
                            _nameController.text.trim();
                        final enteredPassword =
                            _passwordController.text;

                        if (enteredName.isEmpty ||
                            enteredPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "يرجى ملء الاسم وكلمة المرور أولاً!",
                                textAlign: TextAlign.right,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final success = studentVM.login(
                          name: enteredName,
                          password: enteredPassword,
                        );

                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "الاسم أو كلمة المرور غير متطابقة مع الحساب المسجل!",
                                textAlign: TextAlign.right,
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "أهلاً بك مجدداً! تم تسجيل الدخول بنجاح.",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );

                        context.go('/home');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBC6C25),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: const Text(
                      "أنشئ حسابك الآن",
                      style: TextStyle(
                        color: Color(0xFFBC6C25),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Text(
                    "ليس لديك حساب؟",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
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
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFBC6C25),
          width: 1,
        ),
      ),
    );
  }
}

