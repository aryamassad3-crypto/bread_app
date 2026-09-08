import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 👈 استيراد مكتبة اللغات الرسمية
import 'package:provider/provider.dart';
import 'view_models/admin_vm.dart';
import 'view_models/student_vm.dart';
import 'views/splash_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => StudentViewModel()),
      ],
      child: const BakeryApp(),
    ),
  );
}

class BakeryApp extends StatelessWidget {
  const BakeryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق خبز السكن الجامعي',
      debugShowCheckedModeBanner: false,
      
      // 🌍 إجبار التطبيق بالكامل بكل شاشاته وحقوله على الاتجاه العربي الصحيح
      locale: const Locale('ar', 'AE'), 
      supportedLocales: const [
        Locale('ar', 'AE'), // اللغة العربية
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Cairo', // أو 'Farsan' حسب اسم خطك الفعلي المعتمد
      ),
      home: const SplashView(),
    );
  }
}
