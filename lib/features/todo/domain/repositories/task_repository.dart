import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(int id);
  Future<int> addTask(Task task);
  Future<int> updateTask(Task task);
  Future<int> deleteTask(int id);
}
