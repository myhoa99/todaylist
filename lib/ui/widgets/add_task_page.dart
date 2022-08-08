// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:futter_to_do_app/controller/task_controller.dart';
import 'package:futter_to_do_app/model/task.dart';

import 'package:futter_to_do_app/ui/string_util.dart';
import 'package:futter_to_do_app/ui/style.dart';
import 'package:futter_to_do_app/ui/theme.dart';
import 'package:futter_to_do_app/ui/widgets/button.dart';
import 'package:futter_to_do_app/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = '9:30 PM';
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> listRemind = [5, 10, 15, 20, 25];
  String _selectedRepeat = 'None';
  List<String> listRepeat = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Text('Add Task',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? Colors.white : Colors.black))),
        leading:
            BackButton(color: Get.isDarkMode ? Colors.white : Colors.black),
        backgroundColor: context.theme.backgroundColor,
      ),
      body: Container(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
            child: GestureDetector(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MyInputField(
              title: 'Title',
              hint: 'Enter your Title',
              controller: _titleController,
            ),
            MyInputField(
              title: 'Note',
              hint: 'Enter your Note',
              controller: _noteController,
            ),
            MyInputField(
              title: 'Date',
              hint: "${stringDateFormat(_selectedDate.toString())}",
              widget: IconButton(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _getDateFromUser();
                  print(_selectedDate);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: MyInputField(
                    title: 'Start Time',
                    hint: _startTime,
                    widget: IconButton(
                      icon: Icon(Icons.access_time_rounded),
                      onPressed: () {
                        _getTimeFromuser(true);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: MyInputField(
                    title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      icon: Icon(Icons.access_time_rounded),
                      onPressed: () {
                        _getTimeFromuser(false);
                      },
                    ),
                  ),
                )
              ],
            ),
            MyInputField(
                title: 'Remind',
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 1),
                  items: listRemind.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                        value: value.toString(), child: Text(value.toString()));
                  }).toList(),
                )),
            MyInputField(
                title: 'Repeat',
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 1),
                  items:
                      listRepeat.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value.toString(), child: Text(value.toString()));
                  }).toList(),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _colorPallete(),
                Container(
                    margin: EdgeInsets.only(right: 20, top: 30),
                    child: MyButton(
                        label: 'Create Task',
                        onTap: () {
                          _validateDate();
                        }))
              ],
            )
          ]),
        )),
      ),
    );
  }

  _getDateFromUser() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  _getTimeFromuser(bool isStartTime) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: childWidget!);
        });
  }
  // initialTime: TimeOfDay(
  //     hour: int.parse(_startTime.split(":")[0]),
  //     minute: int.parse(_startTime.split(":")[1].split("")[0])));

  _colorPallete() {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: titleStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            children: List<Widget>.generate(3, (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 0
                          ? primayClr
                          : index == 1
                              ? pinkClr
                              : yellowClr,
                      child: _selectedColor == index
                          ? Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 16,
                            )
                          : Text('')),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      // add to databasse
      setState(() {
        _addTasktoDB();

        Get.back();
      });
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", " All fieldes are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addTasktoDB() async {
    int? value = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      date: stringDateFormat(_selectedDate.toString()),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    ));
    print(' My Task + $value');
  }
}
