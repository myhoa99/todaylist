import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class NotifyPage extends StatelessWidget {
  final String? label;
  const NotifyPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
        title: Text(
          this.label.toString().split("|")[0],
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
          ),
        ),
      ),
      body: Stack(
        children: [
          backgroudImage(),
          Center(
            child: Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.grey : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(24),
                        child: Image.asset('assets/gif/Alarm.gif')),
                    Container(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        this.label.toString().split("|")[1],
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget backgroudImage() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.black, Colors.black12],
        begin: Alignment.bottomCenter,
        end: Alignment.center,
      ).createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/png/Background.png'),

            /// change this to your  image directory
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
      ),
    );
  }
}
