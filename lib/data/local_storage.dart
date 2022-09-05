import 'package:hive/hive.dart';

import '../models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox = Hive.box('task_box');

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    //do not use this
    //await _taskBox.delete(task);
    //or this code same
    //use this code
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];
    _allTask = await _taskBox.values.toList();
    if (_allTask.isNotEmpty) {
      _allTask.sort((Task a, Task b) => a.createdAt.compareTo(b.createdAt));
    }
    return _allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    return _taskBox.get(id);
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
    // other method to do that
    // _taskBox.put(task.id, task);
    //return task;
  }
}
