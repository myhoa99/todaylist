import 'package:flutter/material.dart';
import 'package:futter_to_do_app/services/notification_service.dart';
import 'package:futter_to_do_app/services/theme_service.dart';
import 'package:get/get.dart';

import '../generated/resource.dart';

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
      appBar: _appBar(),
      body: Column(children: []),
    );
  }
}

_appBar() {
  return AppBar(
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
      child: const Icon(
        Icons.nightlight_round,
        size: 20,
      ),
    ),
    actions: const [
      CircleAvatar(backgroundImage: AssetImage(R.ASSETS_PNG_IMAGES_PNG)),
      SizedBox(
        width: 20,
      )
    ],
  );
}
