import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
import 'add_task_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  SizeConfig sizee = SizeConfig();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  final TaskController _taskController = TaskController();
  DateTime _selestedTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    sizee.init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTask(),
          _addDateTask(),
          _showTask(),
        ],
      ),
    );
  }

  AppBar _appBar() => AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          icon: Get.isDarkMode
              ? const Icon(Icons.wb_sunny_outlined)
              : const Icon(Icons.brightness_3_outlined,size: 24,),
          onPressed: () {
            ThemeServices().switchTheme();
          },
        ),
        actions:  [
          IconButton(

            color: Get.isDarkMode ? Colors.white : Colors.black,
            icon:const Icon(Icons.cleaning_services_outlined,size: 24,),
            onPressed: () {
              notifyHelper.flutterLocalNotificationsPlugin.cancelAll();
              _taskController.deleteAllTask();
            },
          ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          const SizedBox(width: 20)
        ],
      );

  _showTask() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.listTask.isEmpty) {
            return _noTask();
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemCount: _taskController.listTask.length,
                itemBuilder: (BuildContext context, int index) {
                  var task = _taskController.listTask[index];

                  if (task.repeat == 'Delay' ||
                      task.date == DateFormat.yMd().format(_selestedTime)||
                      (task.repeat=='Weekly'&&_selestedTime.difference(DateFormat.yMd().parse(task.date!)).inDays%7 ==0)
                      ||(task.repeat=='Monthly'&&  DateFormat.yMd().parse(task.date!).day==_selestedTime.day)
                  ) {
                    // var hour = task.startTime.toString().split(':')[0];
                    // var minute = task.startTime.toString().split(':')[1];
                    // print('hour : $hour');
                    // print('minute :  $minute');
                    var date = DateFormat.jm().parse(task.startTime!);
                    var myTime = DateFormat('HH:mm').format(date);
                    NotifyHelper().scheduledNotification(
                      int.parse(myTime.toString().split(':')[0]),
                      int.parse(myTime.toString().split(':')[1]),
                      task,
                    );
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 1500),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              print('ok');
                              showbottomsheet(context, task);
                            },
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }

                },
              ),
            );
          }
        },
      ),
    );
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
    return Stack(
      children: [
        AnimatedPositioned(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
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
            ),
            duration: const Duration(
              milliseconds: 2000,
            ))
      ],
    );
  }

  showbottomsheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
              ),
              const SizedBox(height: 10),
              task.isCompleted == 1
                  ? Container()
                  : _buildbottomsheet(
                      label: 'Competed Task',
                      Clr: primaryClr,
                      onTap: () async{
                        _taskController.markTaskCompleted(task.id!);
                        await notifyHelper.flutterLocalNotificationsPlugin.cancel(task.id!);
                        Get.back();
                      }),
              _buildbottomsheet(
                  label: 'Deleted Task',
                  Clr: Colors.red[300]!,
                  onTap: () async {
                    _taskController.delete(task);
                    await notifyHelper.flutterLocalNotificationsPlugin.cancel(task.id!);
                    print('Notification Deleted');

                    Get.back();
                  }),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              ),
              _buildbottomsheet(
                  label: 'Cancel',
                  Clr: primaryClr,
                  onTap: () {
                    Get.back();
                  }),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  _buildbottomsheet(
      {required String label,
      required Function() onTap,
      required Color Clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isClose
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[200]!
                    : Clr),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : Clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? TitleStyle : TitleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }
}
