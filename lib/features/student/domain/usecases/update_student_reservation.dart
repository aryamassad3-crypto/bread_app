import '../entities/student.dart';
import '../repositories/student_repository.dart';

class UpdateStudentReservation {
  final StudentRepository repository;

  UpdateStudentReservation(this.repository);

  Future<void> call(Student student, bool isReserved) async {
    final updatedStudent = student.copyWith(
      isReserved: isReserved,
    );

    await repository.updateStudent(updatedStudent);
  }
}