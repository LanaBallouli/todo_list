import 'package:get_it/get_it.dart';

import 'features/todo/data/datasources/local_data_source.dart';
import 'features/todo/data/repositories/task_repository_impl.dart';
import 'features/todo/domain/repositories/task_repository.dart';
import 'features/todo/domain/usecases/add_task.dart';
import 'features/todo/domain/usecases/delete_task.dart';
import 'features/todo/domain/usecases/get_all_tasks.dart';
import 'features/todo/domain/usecases/get_task_by_id.dart';
import 'features/todo/domain/usecases/update_task.dart';
import 'features/todo/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => TaskBloc(
      getAllTasks: sl(),
      getTaskById: sl(),
      addTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetAllTasks(sl()));
  sl.registerLazySingleton(() => GetTaskById(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => DatabaseHelper());
}
