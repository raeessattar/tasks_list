import 'package:flutter/material.dart';
import 'package:tasks_list/models/task.dart';
import 'package:tasks_list/services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskNameController = TextEditingController();
  var _taskDescriptionController = TextEditingController();

  var _editTaskNameController = TextEditingController();
  var _editTaskDescriptionController = TextEditingController();

  Task _task = Task();
  TaskService _taskService = TaskService();

  final List<Task> _taskList = <Task>[];
  var task;

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  getAllTasks() async {
    //_taskList = List<Task>();
    var tasks = await _taskService.readTask();
    tasks.forEach((tasks) {
      setState(() {
        var taskModel = Task();
        taskModel.name = tasks['name'];
        taskModel.description = tasks['description'];
        taskModel.id = tasks['id'];
        _taskList.add(taskModel);
      });
    });
  }

  _editTask(BuildContext context, taskId) async {
    task = await _taskService.readTaskById(taskId);
    setState(() {
      _editTaskNameController.text = task[0]['name'] ?? 'no name';
      _editTaskDescriptionController.text =
          task[0]['description'] ?? 'no description';
    });
    _editFormDialog(context);
  }

  //show form dialog
  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () async {
                  if (_taskNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task title is required!')),
                    );
                    return; // Prevent saving if title is empty
                  }
                  _task.name = _taskNameController.text;
                  _task.description = _taskDescriptionController.text;
                  var result = _taskService.saveTask(_task);
                  setState(() {
                    if (result != null) {
                      Navigator.pop(context);
                    }
                    _taskList.clear();
                    getAllTasks();
                  });
                },
                child: Text('Save'),
              )
            ],
            title: Text('Tasks Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                        hintText: 'Write Task', labelText: 'Task'),
                  ),
                  TextField(
                    controller: _taskDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write Description',
                        labelText: 'Discription'),
                  )
                ],
              ),
            ),
          );
        });
  }

  //edit form dialog
  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () async {
                  _task.id = task[0]['id'];
                  _task.name = _editTaskNameController.text;
                  _task.description = _editTaskDescriptionController.text;
                  var result = _taskService.updateTask(_task);
                  if (result != null) {
                    Navigator.pop(context);
                    _taskList.clear();
                    getAllTasks();
                  }
                },
                child: Text('Update'),
              )
            ],
            title: Text('Edit Tasks Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editTaskNameController,
                    decoration: InputDecoration(
                        hintText: 'Write Task', labelText: 'Task'),
                  ),
                  TextField(
                    controller: _editTaskDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write Description',
                        labelText: 'Discription'),
                  )
                ],
              ),
            ),
          );
        });
  }

  //delete form dialog
  _deleteFormDialog(BuildContext context, taskId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () async {
                  var result = _taskService.deleteTask(taskId);
                  if (result != null) {
                    Navigator.pop(context);
                    _taskList.clear();
                    getAllTasks();
                  }
                },
                child: Text('Delete'),
              )
            ],
            title: Text('Do you want to Delete this'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks List'),
      ),
      body: ListView.builder(
          itemCount: _taskList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editTask(context, _taskList[index].id);
                      /////////////////////////////////////////////////////////
                      // _editTaskNameController.text = _taskList[index].name.toString();
                      // _editTaskDescriptionController.text =
                      //     _taskList[index].description.toString();
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_taskList[index].name.toString()),
                      IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _deleteFormDialog(context, _taskList[index].id);
                          })
                    ],
                  ),
                  subtitle: Text(_taskList[index].description.toString()),
                ),
              ),
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
