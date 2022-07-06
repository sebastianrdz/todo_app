import 'package:flutter/material.dart';
import 'package:todo_app_srdz_v1/database_helper.dart';
import 'package:todo_app_srdz_v1/widgets.dart';

import '../models/task.dart';
import '../models/todo.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  const TaskPage({Key? key, required this.task}) : super(key: key);
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  String? _taskTitle = "";
  String? _taskDescription = "";
  String? _todoText = "";
  int? _taskId = 0;
  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;
  bool _contentVisable = false;

  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task?.title;
      _taskDescription = widget.task?.description;
      _taskId = widget.task?.id;
      _contentVisable = true;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  //Title
                  padding: const EdgeInsets.only(top: 24.0, bottom: 6.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png')),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (widget.task == null) {
                              Task _newTask = Task(
                                title: value,
                              );
                              _taskId = await _dbHelper.insertTask(_newTask);
                              setState(() {
                                _contentVisable = true;
                                _taskTitle = value;
                              });
                              // print('task id: ${_taskId}');
                            } else {
                              await _dbHelper.updateTaskTitle(_taskId!, value);
                              // print('update existing task');
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _taskTitle!,
                        decoration: const InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none),
                        style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551)),
                      ))
                    ],
                  ),
                ),
                Visibility(
                  //Description
                  visible: _contentVisable,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      focusNode: _descriptionFocus,
                      onSubmitted: (value) async {
                        if (value != "") {
                          if (_taskId != null) {
                            await _dbHelper.updateTaskDescription(_taskId!, value);
                            _taskDescription = value;
                          }
                        }
                        _todoFocus.requestFocus();
                      },
                      controller: TextEditingController()
                        ..text =
                            _taskDescription == null ? "" : _taskDescription!,
                      decoration: const InputDecoration(
                        hintText: 'Enter input for the Task..',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  // List
                  visible: _contentVisable,
                  child: FutureBuilder<dynamic>(
                    initialData: [],
                    future: _dbHelper.getTodo(_taskId),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  // swithch todo colpletion state
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            }),
                      );
                    },
                  ),
                ),
                Visibility(
                  //Input
                  visible: _contentVisable,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          margin: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: const Color(0xFF86829D), width: 1.5)),
                          child: const Image(
                            image: AssetImage('assets/images/check_icon.png'),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          focusNode: _todoFocus,
                          controller: TextEditingController()..text = "",
                          onSubmitted: (value) async {
                            if (value != "") {
                              if (_taskId != 0) {
                                DatabaseHelper _dbHelper = DatabaseHelper();
                                Todo _newTodo = Todo(
                                  taskId: _taskId,
                                  title: value,
                                  isDone: 0,
                                );
                                await _dbHelper.insertTodo(_newTodo);
                                setState(() {});
                                _todoFocus.requestFocus();
                              } else {
                                print('no task available');
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Todo Item...',
                            border: InputBorder.none,
                          ),
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              // Button
              visible: _contentVisable,
              child: Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if(_taskId != 0){
                      await _dbHelper.deleteTask(_taskId!);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: const Color(0XFFFE3577),
                        borderRadius: BorderRadius.circular(40.0)),
                    child: const Image(
                        image: AssetImage('assets/images/delete_icon.png')),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
