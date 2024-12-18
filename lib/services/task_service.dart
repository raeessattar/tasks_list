import 'package:tasks_list/models/task.dart';
import 'package:tasks_list/repositories/repository.dart';

class TaskService {
  Repository? _repository;

  TaskService() {
    _repository = Repository();
  }

  saveTask(Task task) async {
    return await _repository?.insertData('tasks', task.taskMap());
  }

  readTask() async {
    return _repository?.readData('tasks');
  }

  //ready data from the table by id
  readTaskById(taskId) async {
    return await _repository?.readDataById('tasks', taskId);
  }

  //update data
  updateTask(Task task) async {
    return await _repository?.updateData('tasks', task.taskMap());
  }

  //delete data from table
  deleteTask(taskId) async {
    return await _repository?.deleteData('tasks', taskId);
  }
}
