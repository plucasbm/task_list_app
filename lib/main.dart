import 'package:flutter/material.dart';
import 'package:task_list_app/pages/task_list_page.dart';

void main(){
  runApp(
     const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}