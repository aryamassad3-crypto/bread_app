
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'features/admin/presentation/view_models/admin_vm.dart';
import 'features/student/data/repositories/student_repository_impl.dart';
import 'features/student/domain/usecases/get_student.dart';
import 'features/student/domain/usecases/register_student.dart';
import 'features/student/domain/usecases/update_student_profile.dart';
import 'features/student/domain/usecases/update_student_reservation.dart';
import 'features/student/presentation/view_models/student_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final studentRepository = StudentRepositoryImpl();
  await studentRepository.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AdminViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => StudentViewModel(
            RegisterStudent(studentRepository),
            UpdateStudentReservation(studentRepository),
            UpdateStudentProfile(studentRepository),
            GetStudent(studentRepository),
          ),
        ),
      ],
      child: const BakeryApp(),
    ),
  );
}

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'تطبيق خبز السكن الجامعي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AE'),
      supportedLocales: const [
        Locale('ar', 'AE'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Cairo',
      ),
      routerConfig: appRouter,
    );
  }
}
