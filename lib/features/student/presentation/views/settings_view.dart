
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../view_models/student_vm.dart';
import 'instructions_view.dart';
import 'change_password_view.dart';
import 'about_app_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "الإعدادات:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),

            _buildNavigationOption(
              title: "حول التطبيق",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAppView(),
                  ),
                );
              },
            ),

            _buildNavigationOption(
              title: "تعليمات الاستخدام",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InstructionsView(),
                  ),
                );
              },
            ),

            _buildNavigationOption(
              title: "تغيير كلمة المرور",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordView(),
                  ),
                );
              },
            ),

            _buildSwitchOption(
              title: "كتم الإشعارات",
              value: _isMuted,
              onChanged: (bool newValue) {
                setState(() {
                  _isMuted = newValue;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      newValue
                          ? "تم تفعيل وضع كتم الإشعارات"
                          : "تم إلغاء كتم الإشعارات",
                    ),
                    backgroundColor: const Color(0xFFBC6C25),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildLogoutOption(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationOption({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade100,
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFFBC6C25),
                activeTrackColor:
                    const Color(0xFFDDA15E).withOpacity(0.4),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade200,
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade100,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildLogoutOption(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<StudentViewModel>().logout();

        context.go('/login');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "تم تسجيل الخروج بنجاح. نراك قريباً!",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 4.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "تسجيل الخروج",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.logout_rounded,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
