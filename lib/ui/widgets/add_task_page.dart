// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:futter_to_do_app/ui/string_util.dart';
import 'package:futter_to_do_app/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = '9:30 PM';
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> listRemind = [5, 10, 15, 20, 25];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            BackButton(color: Get.isDarkMode ? Colors.white : Colors.black),
        backgroundColor: context.theme.backgroundColor,
      ),
      body: Container(
        child: SingleChildScrollView(
            child: GestureDetector(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: const Text('Add Task',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600))),
            MyInputField(title: 'Title', hint: 'Enter your Title'),
            MyInputField(title: 'Note', hint: 'Enter your Note'),
            MyInputField(
              title: 'Date',
              hint: "${stringDateFormat(_selectedDate.toString())}",
              widget: IconButton(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _getDateFromUser(context);
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
                        _getTimeFromuser(context, true);
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
                        _getTimeFromuser(context, false);
                      },
                    ),
                  ),
                )
              ],
            )
          ]),
        )),
      ),
    );
  }

  _getDateFromUser(BuildContext context) async {
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

  _getTimeFromuser(BuildContext context, bool isStartTime) {
    var pickedTime = _showTimPicker();
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

  _showTimPicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split("")[0])));
  }
}
