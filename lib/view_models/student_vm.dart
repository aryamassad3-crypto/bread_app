import 'package:flutter/material.dart';

class StudentViewModel extends ChangeNotifier {
  String? _pickedFaceImagePath;
  
  // متغيرات حفظ بيانات الحساب النظامي
  String _registeredName = "";
  String _registeredPassword = "";

  String? get pickedFaceImagePath => _pickedFaceImagePath;
  String get registeredName => _registeredName;
  String get registeredPassword => _registeredPassword;

  void updateFaceImage(String path) {
    _pickedFaceImagePath = path;
    notifyListeners();
  }

  // دالة حفظ بيانات الطالب عند إنشاء الحساب
  void registerStudent(String name, String password) {
    _registeredName = name;
    _registeredPassword = password;
    notifyListeners();
  }
}
