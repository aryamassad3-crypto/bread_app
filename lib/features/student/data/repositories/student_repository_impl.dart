
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  static const String _studentKey = 'saved_student';

  SharedPreferences? _preferences;
  Student? _student;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();

    final savedData = _preferences!.getString(_studentKey);

    if (savedData != null) {
      try {
        final Map<String, dynamic> data =
            jsonDecode(savedData) as Map<String, dynamic>;

        _student = Student(
          name: data['name'] as String? ?? '',
          password: data['password'] as String? ?? '',
          universityId: data['universityId'] as String? ?? '',
          phone: data['phone'] as String? ?? '',
          unit: data['unit'] as String? ?? '',
          floor: data['floor'] as String? ?? '',
          room: data['room'] as String? ?? '',
          isReserved: data['isReserved'] as bool? ?? false,
          faceImagePath: data['faceImagePath'] as String?,
        );
      } catch (_) {
        _student = null;
      }
    }
  }

  @override
  Student? getStudent() => _student;

  @override
  Future<void> saveStudent(Student student) async {
    await _save(student);
  }

  @override
  Future<void> updateStudent(Student student) async {
    await _save(student);
  }

  Future<void> _save(Student student) async {
    final preferences =
        _preferences ??= await SharedPreferences.getInstance();

    final data = <String, dynamic>{
      'name': student.name,
      'password': student.password,
      'universityId': student.universityId,
      'phone': student.phone,
      'unit': student.unit,
      'floor': student.floor,
      'room': student.room,
      'isReserved': student.isReserved,
      'faceImagePath': student.faceImagePath,
    };

    final saved = await preferences.setString(
      _studentKey,
      jsonEncode(data),
    );

    if (!saved) {
      throw Exception('تعذر حفظ بيانات الطالب');
    }

    _student = student;
  }
}
