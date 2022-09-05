import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:stract_todo_hive/data/local_storage.dart';
import 'package:stract_todo_hive/widgets/task_list.dart';

import 'main.dart';
import 'models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    _allTasks = <Task>[];
    _localStorage = locator<LocalStorage>();

    //because of async, we define method for getAllTask from _locator.getAllTask();
    getAllTaskDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo Hive'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet(context);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                int reversedIndex = _allTasks.length - 1 - index;
                var _currentTask = _allTasks[reversedIndex];

                return Dismissible(
                  //UniqueKey() is important...
                  key: UniqueKey(),
                  background: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _allTasks.removeAt(reversedIndex);
                    _localStorage.deleteTask(task: _currentTask);
                    setState(() {});
                  },
                  child: TaskList(
                    task: _currentTask,
                  ),
                );
              })
          : Center(
              child: Text(
                'Add Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                left: 8.0,
                right: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type Task',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();

                DatePicker.showTimePicker(context, showSecondsColumn: false,

                    //create newTask and add it to _localStorage
                    onConfirm: (time) async {
                  var newTask = Task.create(title: value, createdAt: time);
                  _allTasks.add(newTask);
                  //it takes time and we define async
                  await _localStorage.addTask(task: newTask);
                  setState(() {});
                  //
                });
              },
            ),
          );
        });
  }

  void getAllTaskDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }
}
