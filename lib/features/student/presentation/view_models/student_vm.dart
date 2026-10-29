
import 'package:flutter/material.dart';

import '../../domain/entities/student.dart';
import '../../domain/usecases/get_student.dart';
import '../../domain/usecases/register_student.dart';
import '../../domain/usecases/update_student_profile.dart';
import '../../domain/usecases/update_student_reservation.dart';

class StudentViewModel extends ChangeNotifier {
  final RegisterStudent _registerStudent;
  final UpdateStudentReservation _updateStudentReservation;
  final UpdateStudentProfile _updateStudentProfile;
  final GetStudent _getStudent;

  Student _student = const Student(
    name: '',
    password: '',
    universityId: '',
    phone: '',
    unit: '',
    floor: '',
    room: '',
  );

  StudentViewModel(
    this._registerStudent,
    this._updateStudentReservation,
    this._updateStudentProfile,
    this._getStudent,
  ) {
    _loadSavedStudent();
  }

  String get studentName => _student.name;
  String get studentPassword => _student.password;
  String? get pickedFaceImagePath => _student.faceImagePath;
  String get uniId => _student.universityId;
  String get phone => _student.phone;
  String get unit => _student.unit;
  String get floor => _student.floor;
  String get room => _student.room;
  bool get isReserved => _student.isReserved;

  void _loadSavedStudent() {
    final savedStudent = _getStudent();

    if (savedStudent != null) {
      _student = savedStudent;
      notifyListeners();
    }
  }

  Future<void> updateFaceImage(String path) async {
    final updatedStudent = _student.copyWith(
      faceImagePath: path,
    );

    await _updateStudentProfile(updatedStudent);

    _student = updatedStudent;
    notifyListeners();
  }

 Future<void> registerStudent({
  required String name,
  required String password,
  required String uniId,
  required String phone,
  required String unit,
  required String floor,
  required String room,
}) async {
  final student = Student(
    name: name,
    password: password,
    universityId: uniId,
    phone: phone,
    unit: unit,
    floor: floor,
    room: room,
    isReserved: false,
    faceImagePath: _student.faceImagePath,
  );

  await _registerStudent(student);

  _student = student;
  notifyListeners();
}

  Future<void> updateProfile(Student student) async {
    // احتفظ بالصورة الحالية إذا لم يرسل التعديل صورة جديدة.
    final updatedStudent = student.copyWith(
      faceImagePath: student.faceImagePath ?? _student.faceImagePath,
    );

    await _updateStudentProfile(updatedStudent);

    _student = updatedStudent;
    notifyListeners();
  }

  Future<void> toggleReservation(bool value) async {
    final updatedStudent = _student.copyWith(
      isReserved: value,
    );

    await _updateStudentReservation(_student, value);

    // نستخدم النسخة التي أعادها تحديث الحجز حتى لا نفقد الصورة.
    _student = updatedStudent;
    notifyListeners();
  }
}
