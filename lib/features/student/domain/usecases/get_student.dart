
import '../entities/student.dart';
import '../repositories/student_repository.dart';

class GetStudent {
  final StudentRepository repository;

  GetStudent(this.repository);

  Student? call() {
    return repository.getStudent();
  }
}
