import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:futter_to_do_app/services/notification_service.dart';
import 'package:futter_to_do_app/services/theme_service.dart';
import 'package:futter_to_do_app/ui/style.dart';
import 'package:futter_to_do_app/ui/theme.dart';
import 'package:futter_to_do_app/ui/widgets/add_task_page.dart';
import 'package:futter_to_do_app/ui/widgets/button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
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
      body: Column(children: [_addTaskBar(), _datePicker()]),
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
        MyButton(label: '+Add Task', onTap: () => Get.to(AddTaskPage()))
      ],
    ),
  );
}

_datePicker() {
  DateTime selectDate = DateTime.now();
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
      onDateChange: (date) {
        selectDate = date;
      },
    ),
  );
}
