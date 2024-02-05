import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task.dart';
import 'package:todoey_flutter/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function checkBoxCallback;
  final Function onLongPressedCallback;
  // void checkboxCallback(bool checkboxState) {}

  TaskTile({
    required this.isChecked,
    required this.taskTitle,
    required this.checkBoxCallback,
    required this.onLongPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        print('ListTile long pressed');
        onLongPressedCallback();
      },
      title: Text(
        taskTitle,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: isChecked,
        onChanged: (newValue) {
          checkBoxCallback(newValue);
        },
        // onChanged: toggleCheckboxState,
        // setState(
        //   () {
        //     checkboxState = newValue!;
        //   },
        // );
      ),
    );
  }
}
