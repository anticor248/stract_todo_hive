import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  bool isDone;

  Task(
      {required this.id,
      required this.title,
      required this.createdAt,
      required this.isDone});

  factory Task.create({required String title, required DateTime createdAt}) {
    return Task(
        id: Uuid().v1(), title: title, createdAt: createdAt, isDone: false);
  }
}
