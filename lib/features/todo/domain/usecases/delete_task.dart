import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, int>> call(int id) async {
    return await repository.deleteTask(id);
  }
}
