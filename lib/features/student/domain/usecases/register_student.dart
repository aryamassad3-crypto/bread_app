import '../entities/student.dart';
import '../repositories/student_repository.dart';

class RegisterStudent {
  final StudentRepository repository;

  RegisterStudent(this.repository);

  Future<void> call(Student student) async {
    await repository.saveStudent(student);
  }
}