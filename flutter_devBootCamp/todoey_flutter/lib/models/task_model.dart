import 'package:flutter/material.dart';
import 'package:todoey_flutter/models/task.dart';
import 'dart:collection';

class TaskModel with ChangeNotifier {
  TaskModel() {
    print('TaskModel() constructed!---------------------------');
  }
  // final List<Task> _values = <Task>[];
  final List<Task> _values = [
    Task(name: 'buy milk!'),
    Task(name: 'buy water!'),
  ];
  // List<Task> get values =>
  //     _values.toList(); // O(N), makes a new copy each time.
  UnmodifiableListView<Task> get values {
    return UnmodifiableListView(_values); // O(N), makes a new copy each time.
  }

  void add(String value) {
    print('TaskModel.add()1 --- $value');
    _values.add(Task(name: value));

    for (var entry in values) {
      print('TaskModel.add()2 --- ${entry.name}');
    }
    notifyListeners();
  }

  int get length => _values.length;

  void updateTask(int index) {
    _values[index].toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _values.remove(task);
    notifyListeners();
  }
}
