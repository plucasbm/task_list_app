import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

const taskListKey = 'task_list';

class TaskRepository {
  late SharedPreferences sharedPreferences;
  

  Future<List<Task>> getTaskList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String response = sharedPreferences.getString(taskListKey) ?? '[]';
    final List jsonDecoded = json.decode(response) as List;
    return jsonDecoded.map((e) => Task.fromJson(e)).toList();
  }

  void saveTaskList(List<Task> tasks){
    final response = json.encode(tasks);
    sharedPreferences.setString(taskListKey, response);
  }
}