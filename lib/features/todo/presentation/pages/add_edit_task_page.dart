import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';

class AddEditTaskPage extends StatelessWidget {
  final Task? task;

  const AddEditTaskPage({Key? key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize TextEditingController and local state variables
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController =
        TextEditingController(text: task?.description ?? '');
    bool isCompleted = task?.isCompleted ?? false;

    // Create a GlobalKey for the form
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
        elevation: 0,
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (!context.mounted) return;
          if (state is TaskAdded || state is TaskUpdated) {
            Navigator.pop(context);
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                if (task != null) ...[
                  Row(
                    children: [
                      Checkbox(
                        value: isCompleted,
                        onChanged: (value) {
                          isCompleted = value ?? false;
                        },
                      ),
                      const Text('Mark as completed'),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        final newTask = Task(
                          id: task?.id,
                          title: titleController.text,
                          description: descriptionController.text,
                          isCompleted: isCompleted,
                        );

                        if (task == null) {
                          context
                              .read<TaskBloc>()
                              .add(AddTaskEvent(task: newTask));
                        } else {
                          context
                              .read<TaskBloc>()
                              .add(UpdateTaskEvent(task: newTask));
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text(task == null ? 'Add Task' : 'Update Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
