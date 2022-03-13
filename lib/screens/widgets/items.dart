import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home/controller.dart';

Widget ItemNewTask(model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(

        padding: const EdgeInsets.all(15.0),

        child: Row(

          children: [

            CircleAvatar(

              radius: 35,

              child: Text(

                '${model['time']}',

                style: TextStyle(fontSize: 15),

              ),

            ),

            SizedBox(

              width: 20,

            ),

            Expanded(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(

                    '${model['title']}',

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                  ),

                  Text(

                    '${model['date']}',

                    style: TextStyle(color: Colors.grey),

                  ),

                ],

              ),

            ),

            SizedBox(

              width: 20,

            ),

            IconButton(

                onPressed: () {

                  HomeController.get(context)

                      .upDateData(status: 'done', id: model['id']);

                },

                icon: Icon(

                  Icons.check_box,

                  color: Colors.green,

                )),

            IconButton(

                onPressed: () {

                  HomeController.get(context)

                      .upDateData(status: 'archive', id: model['id']);

                },

                icon: Icon(

                  Icons.archive,

                  color: Colors.black54,

                )),

          ],

        ),

      ),
  onDismissed: (direction){
    HomeController.get(context).deleteData(id: model['id']);
  },
);

Widget ConditionTask(@required List<Map> tasks) => ConditionalBuilder(
      condition: tasks.length > 0,
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 80,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet , Please Add Some Tasks',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => ItemNewTask(tasks[index], context),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey,
          margin: const EdgeInsetsDirectional.only(start: 25),
        ),
        itemCount: tasks.length,
      ),
    );
