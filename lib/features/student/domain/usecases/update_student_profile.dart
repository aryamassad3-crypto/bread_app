import '../entities/student.dart';
import '../repositories/student_repository.dart';

class UpdateStudentProfile {
  final StudentRepository repository;

  UpdateStudentProfile(this.repository);

  Future<void> call(Student student) async {
    await repository.updateStudent(student);
  }
}