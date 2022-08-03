import 'dart:ffi';

import 'package:futter_to_do_app/db/db_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../model/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getTask();
  }

  var taskList = <Task>[].obs;

  Future<int?> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
    print(taskList.length);
  }

  void deleteTask(Task task) {
    var val = DBHelper.delete(task);
    print(val);
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
  }
}
