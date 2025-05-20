import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';
import '../widgets/task_item.dart';
import 'add_edit_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetAllTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        elevation: 0,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TasksLoaded) {
            return state.tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new task by tapping the + button',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskItem(
                        task: task,
                        onToggleComplete: () {
                          context.read<TaskBloc>().add(
                                UpdateTaskEvent(
                                  task: task.copyWith(
                                    isCompleted: !task.isCompleted,
                                  ),
                                ),
                              );
                          // Refresh the list after updating
                          Future.delayed(
                            const Duration(milliseconds: 300),
                            () => context.read<TaskBloc>().add(GetAllTasksEvent()),
                          );
                        },
                        onEdit: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditTaskPage(task: task),
                            ),
                          );
                          // Refresh the list after editing
                          if (!mounted) return;
                          context.read<TaskBloc>().add(GetAllTasksEvent());
                        },
                        onDelete: () {
                          context.read<TaskBloc>().add(DeleteTaskEvent(id: task.id!));
                          // Refresh the list after deleting
                          Future.delayed(
                            const Duration(milliseconds: 300),
                            () => context.read<TaskBloc>().add(GetAllTasksEvent()),
                          );
                        },
                      );
                    },
                  );
          } else if (state is TaskError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTaskPage(),
            ),
          );
          // Refresh the list after adding
          if (!mounted) return;
          context.read<TaskBloc>().add(GetAllTasksEvent());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
