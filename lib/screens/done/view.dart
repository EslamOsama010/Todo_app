import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screens/home/controller.dart';
import 'package:todo_app/screens/home/states.dart';

import '../widgets/items.dart';


class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<HomeController,AppStates>(
          listener: (context,state){
          },
          builder: (context,state){
            var tasks = HomeController.get(context).doneTasks;
            return ConditionTask(tasks);
          }
      );
  }
}