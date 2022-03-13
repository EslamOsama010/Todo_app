import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/home/controller.dart';
import 'package:todo_app/screens/home/states.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeController()..createDataBase(),
      child: BlocConsumer<HomeController, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertToDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          final controller = HomeController.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("${controller.titles[controller.selectedIndex]}"),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetLoadingState,
              builder: (context) => controller.pages[controller.selectedIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.selectedIndex,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  controller.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ]),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (controller.isSheetShow) {
                    if (formKey.currentState!.validate()) {
                      controller.insertToDataBase(
                        title: controller.titleController.text,
                        time: controller.timeController.text,
                        date: controller.dateController.text,
                      );
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: controller.titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (dynamic value) {
                                      if (value.isEmpty) {
                                        return 'task must be not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Task Title'),
                                      prefixIcon: Icon(Icons.title),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    controller: controller.timeController,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        controller.timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validator: (dynamic value) {
                                      if (value.isEmpty) {
                                        return 'time must be not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Task Time'),
                                      prefixIcon:
                                          Icon(Icons.watch_later_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: controller.dateController,
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-05-01'),
                                      ).then((value) {
                                        controller.dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validator: (dynamic value) {
                                      if (value.isEmpty) {
                                        return 'date must be not empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Task Date'),
                                      prefixIcon:
                                          Icon(Icons.calendar_today_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 20,
                        )
                        .closed
                        .then((value){
                      controller.changeBottomSheet(
                          isShow: false, icon: Icons.edit);
                    });
                    controller.changeBottomSheet(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(controller.fabIcon)),
          );
        },
      ),
    );
  }
}
