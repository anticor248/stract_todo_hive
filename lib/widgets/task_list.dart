import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stract_todo_hive/data/local_storage.dart';

import '../main.dart';
import '../models/task_model.dart';

class TaskList extends StatefulWidget {
  final Task task;
  TaskList({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TextEditingController _taskTitle = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    _taskTitle.text = widget.task.title;
    _localStorage = locator<LocalStorage>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO decoration container
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isDone = !widget.task.isDone;
            _localStorage.updateTask(task: widget.task);

            setState(() {});
          },
          child: widget.task.isDone
              ? Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 36,
                )
              : Icon(
                  Icons.circle_outlined,
                  size: 36,
                ),
        ),

        //TODO decoration title linetrough done or editable

        title: widget.task.isDone
            ? Text(
                widget.task.title,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black38,
                ),
              )
            : TextField(
                controller: _taskTitle,
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (newTitle) {
                  widget.task.title = newTitle;
                  _localStorage.updateTask(task: widget.task);
                  setState(() {});
                },
              ),
        trailing: Text(
          DateFormat('HH:mm').format(
            widget.task.createdAt,
          ),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
