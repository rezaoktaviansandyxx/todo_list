import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const HttpExampleApp());
}

class HttpExampleApp extends StatelessWidget {
  const HttpExampleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const HttpExamplePage(),
    );
  }
}

class TodoItem {
  const TodoItem({
    required this.title,
    required this.completed,
  });

  final String title;
  final bool completed;
}

class HttpExamplePage extends StatelessWidget {
  const HttpExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Example'),
      ),
      body: FutureBuilder(
          future: getTodos(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TodoItem>> snapshot) {
            if (snapshot.hasData) {
              List<TodoItem> todos = snapshot.data!;
              return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: todos[index].completed
                            ? const Icon(Icons.check_box)
                            : const Icon(Icons.check_box_outline_blank),
                        title: Text(todos[index].title),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Future<List<TodoItem>> getTodos() async {
  Response res = await get(Uri.http('jsonplaceholder.typicode.com', '/todos'));
  if (res.statusCode == 200) {
    List<dynamic> body = jsonDecode(res.body);
    List<TodoItem> todos = body.map((item) {
      return TodoItem(
          title: item['title'] as String, completed: item['completed'] as bool);
    }).toList();
    return todos;
  } else {
    return [];
  }
}
