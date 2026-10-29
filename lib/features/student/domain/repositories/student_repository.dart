import '../entities/student.dart';

abstract class StudentRepository {
  Student? getStudent();

  Future<void> saveStudent(Student student);

  Future<void> updateStudent(Student student);
}