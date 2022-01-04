import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = TaskController();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  String startTime = DateFormat('hh:mm  a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selecRemind = 5;
  List<int> RemindList = [5, 10, 15, 20];
  String _selectRepeat = 'None';
  List<String> repsetList = ['None', 'Delay', 'Weekly', 'Monthly'];
  int _selectedColore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add Task',
                  style: heading,
                ),
                InputField(
                  title: 'Title',
                  hint: 'Enter Title Task',
                  controller: _titlecontroller,
                ),
                InputField(
                  title: 'Note',
                  hint: 'Enter Note Task',
                  controller: _notecontroller,
                ),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedTime),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: InputField(
                      title: 'Start Time',
                      hint: startTime,
                      widget: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time, color: Colors.grey),
                      ),
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: InputField(
                      title: 'End Time',
                      hint: endTime,
                      widget: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.access_time,
                          color: Colors.grey,
                        ),
                      ),
                    )),
                  ],
                ),
                InputField(
                  title: 'Remind',
                  hint: '$_selecRemind minuet early',
                  widget: Row(
                    children: [
                      DropdownButton(
                        underline: Container(height: 0),
                        borderRadius: BorderRadius.circular(10),
                        elevation: 4,
                        style: subTitle,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.grey,
                        ),
                        iconSize: 30,
                        items: RemindList.map<DropdownMenuItem<String>>(
                            (int value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text('$value'))).toList(),
                        onChanged: (String? newvalue) {
                          setState(() {
                            _selecRemind = int.parse(newvalue!);
                          });
                        },
                      ),
                      const SizedBox(width: 6)
                    ],
                  ),
                ),
                InputField(
                  title: 'Repeat',
                  hint: _selectRepeat,
                  widget: Row(
                    children: [
                      DropdownButton(
                        underline: Container(height: 0),
                        style: subTitle,
                        items: repsetList
                            .map<DropdownMenuItem<String>>((String value) =>
                                DropdownMenuItem<String>(
                                    value: value, child: Text(value)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectRepeat = value!;
                          });
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.grey,
                        ),
                        iconSize: 30,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 4,
                      ),
                      const SizedBox(width: 6)
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column_methode(),
                    MyButton(label: 'Add Task', onTap: () {}),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          color: Get.isDarkMode ? Colors.white : Colors.black,
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
        actions: const [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(width: 6)
        ],
      );

  Column Column_methode() {
    return Column(
      children: [
        const Text('Color'),
        Wrap(
          children: List.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColore = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                                ? pinkClr
                                : orangeClr,
                        radius: 14,
                        child: _selectedColore == index
                            ? const Icon(Icons.done,
                                size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                  )),
        )
      ],
    );
  }
}
