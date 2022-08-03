import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:futter_to_do_app/controller/task_controller.dart';
import 'package:futter_to_do_app/services/notification_service.dart';
import 'package:futter_to_do_app/services/theme_service.dart';
import 'package:futter_to_do_app/ui/string_util.dart';
import 'package:futter_to_do_app/ui/style.dart';
import 'package:futter_to_do_app/ui/theme.dart';
import 'package:futter_to_do_app/ui/widgets/add_task_page.dart';
import 'package:futter_to_do_app/ui/widgets/button.dart';
import 'package:futter_to_do_app/ui/widgets/task_title.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: context.theme.backgroundColor,
      body: Column(children: [
        _addTaskBar(),
        _datePicker(),
        const SizedBox(
          height: 10,
        ),
        _showTask(context),
      ]),
    );
  }
}

_appBar(BuildContext context) {
  return AppBar(
    backgroundColor: context.theme.backgroundColor,
    leading: GestureDetector(
      onTap: () {
        ThemeService().switchTheme();

        var notifyHelper = NotifyHelper();
        notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? " Activated Light Theme"
                : "Activated Dark Theme");
        notifyHelper.scheduledNotification();
      },
      child: Icon(
        Get.isDarkMode ? Icons.nightlight_outlined : Icons.wb_sunny_outlined,
        size: 20,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
    ),
    actions: const [
      CircleAvatar(backgroundImage: AssetImage('assets/png/3135715.png')),
      SizedBox(
        width: 20,
      )
    ],
  );
}

_addTaskBar() {
  final taskController = Get.put(TaskController());
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subheadingStyle,
            ),
            Text(
              'Today',
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
            label: '+Add Task',
            onTap: () async {
              await Get.to(
                () => AddTaskPage(),
              );
              taskController.getTask();
            })
      ],
    ),
  );
}

_datePicker() {
  return Container(
    margin: const EdgeInsets.only(top: 10, left: 10),
    child: DatePicker(
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectedTextColor: Colors.white,
      selectionColor: primayClr,
      dateTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
      monthTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
      onDateChange: (date) {},
    ),
  );
}

_showTask(BuildContext context) {
  return Expanded(
      child: Obx(() => ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            if (task.repeat == 'Daily') {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                        child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTitle(task: task),
                        )
                      ],
                    )),
                  ));
            } else if (task.date ==
                stringDateFormat(_selectedDate.toString())) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                        child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTitle(task: task),
                        )
                      ],
                    )),
                  ));
            } else {
              return Container();
            }
          })));
}

_showBottomSheet(BuildContext context, Task task) {
  Get.bottomSheet(Container(
    color: Get.isDarkMode ? darkGreyClr : Colors.white,
    padding: const EdgeInsets.only(top: 4),
    height: task.isCompleted == 1
        ? MediaQuery.of(context).size.height * 0.23
        : MediaQuery.of(context).size.height * 0.32,
    child: Column(children: [
      Container(
        height: 5,
        width: 120,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      task.isCompleted == 1
          ? Container()
          : _buttomSheetbutton(
              label: "Task Completed",
              onTap: () {
                _taskController.markTaskCompleted(task.id!);
                _taskController.getTask();
                Get.back();
              },
              clr: primayClr,
              context: context),
      const SizedBox(height: 10),
      _buttomSheetbutton(
          label: "Delete Task",
          onTap: () {
            _taskController.deleteTask(task);
            _taskController.getTask();

            Get.back();
          },
          clr: Colors.red[300]!,
          context: context),
      const SizedBox(height: 25),
      _buttomSheetbutton(
          label: "Close",
          onTap: () {
            Get.back();
          },
          isClose: true,
          clr: Colors.red[300]!,
          context: context)
    ]),
  ));
}

_buttomSheetbutton(
    {required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: isClose == true
              ? Get.isDarkMode
                  ? Colors.grey[600]
                  : Colors.white
              : clr,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr)),
      child: Center(
          child: Text(
        label,
        style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
      )),
    ),
  );
}
