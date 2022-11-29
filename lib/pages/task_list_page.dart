import 'package:flutter/material.dart';
import 'package:task_list_app/models/task_model.dart';
import 'package:task_list_app/repositories/task_repository.dart';
import 'package:task_list_app/widgets/to_do_list_item.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final controller = TextEditingController();
  final taskRepository = TaskRepository();

  List<Task> tasks = [];
  Task? deletedTask;
  int? deletedTaskIdx;
  String? textError;

  @override
  void initState() {
    super.initState();

    taskRepository.getTaskList().then((value){
        setState(() {
          tasks = value;
      });
    });
    
  }

  void _delete(Task task) {
    deletedTask = task;
    deletedTaskIdx = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });
    taskRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${task.title} removida com sucesso!',
          style: const TextStyle(
            color: Color(0xff060708),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              tasks.insert(deletedTaskIdx!, deletedTask!);
            });
            taskRepository.saveTaskList(tasks);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content: const Text('Tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Color(0xff00d7f3),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tasks.clear();
              });
              taskRepository.saveTaskList(tasks);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Adicione uma tarefa',
                          border: const OutlineInputBorder(),
                          errorText: textError,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: const Color(0xff00d7f3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      onPressed: () {
                        if(controller.text.isEmpty){
                          setState(() {
                            textError = 'Campo obrigatório';
                          });
                          return;
                        }

                        setState(() {
                          Task newTask = Task(
                            title: controller.text,
                            date: DateTime.now(),
                          );
                          tasks.add(newTask);
                          textError = null;
                        });
                        controller.clear();
                        taskRepository.saveTaskList(tasks);
                      },
                      child: const Icon(Icons.add, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks)
                        ToDoListItem(
                          task: task,
                          onPressed: _delete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Você possui ${tasks.length} tarefas pendentes'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _showDeleteDialog,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: const Color(0xff00d7f3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text(
                        'Limpar tudo',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
