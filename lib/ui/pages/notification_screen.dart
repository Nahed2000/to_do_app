import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.pylode}) : super(key: key);
  final String pylode;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late String _pyload;

  @override
  void initState() {
    _pyload = widget.pylode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _pyload.toString().split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        backgroundColor: context.theme.backgroundColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hello ,Nahed',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Get.isDarkMode ? Colors.white : darkGreyClr)),
                const SizedBox(height: 10),
                Text('Your have a reminder',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color:
                            Get.isDarkMode ? Colors.grey[100] : darkGreyClr)),
              ],
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row_Notifcaton('Title',Icons.text_format),
                      const SizedBox(height: 20),
                      Text(
                        _pyload.toString().split('|')[0],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row_Notifcaton('Description',Icons.description),
                      const SizedBox(height: 20),
                      Text(
                        _pyload.toString().split('|')[1],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row_Notifcaton('Time', Icons.calendar_today_sharp),
                      const SizedBox(height: 20),
                      Text(
                        _pyload.toString().split('|')[0],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row Row_Notifcaton(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 35, color: Colors.white),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 30, color: Colors.white)),
      ],
    );
  }
}
