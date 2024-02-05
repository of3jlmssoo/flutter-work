import 'package:flutter/material.dart';
import 'package:todoey_flutter/widgets/task_tile.dart';
// import 'package:todoey_flutter/models/task.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task_model.dart';

class TasksList extends StatelessWidget {
//   // final List<Task> tasks;
//   // TasksList({required this.tasks});
//
//   @override
//   _TasksListState createState() => _TasksListState();
//   // State<StatefulWidget> createState() {
//   //   // TODO: implement createState
//   //   // throw UnimplementedError();
//   // }
// }
//
// class _TasksListState extends State<TasksList> {
  // List<Task> tasks = [
  //   Task(name: 'buy milk'),
  //   Task(name: 'buy water'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, tasks, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = tasks.values[index];
            return TaskTile(
              // isChecked: widget.tasks[index].isDone,
              // taskTitle: widget.tasks[index].name,
              // isChecked: Provider.of<TaskModel>(context).values[index].isDone,
              // taskTitle: Provider.of<TaskModel>(context).values[index].name,

              // isChecked: tasks.values[index].isDone,
              // taskTitle: tasks.values[index].name,
              isChecked: task.isDone,
              taskTitle: task.name,
              checkBoxCallback: (checkboxState) {
                tasks.updateTask(index);
              },
              onLongPressedCallback: () {
                tasks.deleteTask(task);
              },
            );
          },
          itemCount: tasks.length,
        );
      },
    );
    // return ListView(
    //   children: <Widget>[
    //     TaskTile(
    //       taskTitle: tasks[0].name,
    //       isChecked: tasks[0].isDone,
    //     ),
    //     TaskTile(
    //       taskTitle: tasks[1].name,
    //       isChecked: tasks[1].isDone,
    //     ),
    //   ],
    // );
  }
}
