import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, int>> call(Tasks task) async {
    return await repository.updateTask(task);
  }
}
