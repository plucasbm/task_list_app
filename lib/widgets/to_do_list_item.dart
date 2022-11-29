import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_list_app/models/task_model.dart';

class ToDoListItem extends StatelessWidget {
  final Task task;
  final Function(Task) onPressed;
  const ToDoListItem({
    super.key,
    required this.task,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: const Color(0xffdddddd),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd/MM/yyy - HH:mm').format(task.date),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: (){
              onPressed(task);
            },
            icon: const Icon(
              Icons.delete,
              size: 26,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
