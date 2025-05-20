import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTaskById {
  final TaskRepository repository;

  GetTaskById(this.repository);

  Future<Task?> call(int id) async {
    return await repository.getTaskById(id);
  }
}
