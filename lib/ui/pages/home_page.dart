import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/widgets/task_tile.dart';
import '../../services/theme_services.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

import 'add_task_page.dart';
import 'notification_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  final TaskController _taskController = TaskController();
  DateTime _selestedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            _addTask(),
            const SizedBox(height: 8),
            _addDateTask(),
            _showTaske()
          ],
        ),
      )),
    );
  }

  AppBar _appBar() => AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          icon: Get.isDarkMode
              ? const Icon(Icons.wb_sunny_outlined)
              : const Icon(Icons.brightness_3_outlined),
          onPressed: () {
            ThemeServices().switchTheme();
            NotifyHelper()
                .displayingNotificaation(body: 'DFD', title: 'Changed Theme');
            NotifyHelper().scheduledNotification();
          },
        ),
        actions: const [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(width: 6)
        ],
      );

  _showTaske() {
    return Expanded(
        child: TaskTile(Task(
      title: 'Title 1',
      note: 'DescRpet',
      isCompleted: 1,
      startTime: '20:10',
      endTime: '20 : 15',
      color: 2,
    )));
  }

  _addTask() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subheading,
              ),
              Text('Today', style: heading)
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(const AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _addDateTask() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selestedTime,
        onDateChange: (newDate) {
          setState(() {
            _selestedTime = newDate;
          });
        },
        height: 100,
        width: 70,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
      ),
    );
  }

  _noTask() {
    SizeConfig.orientation = Orientation.portrait;
    return Stack(
      children: [
        AnimatedPositioned(
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    'images/task.svg',
                    semanticsLabel: 'Task',
                    height: 90,
                    color: primaryClr.withOpacity(0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      "Don't have any Task\nAdd new Task to make your Day productive",
                      style: subTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 180)
                      : const SizedBox(height: 160),
                ],
              ),
            ),
            duration: const Duration(
              milliseconds: 2000,
            ))
      ],
    );
  }
}
