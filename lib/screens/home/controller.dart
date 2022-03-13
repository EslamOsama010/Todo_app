import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/screens/archived/view.dart';
import 'package:todo_app/screens/done/view.dart';
import 'package:todo_app/screens/home/states.dart';
import 'package:todo_app/screens/tasks/view.dart';

class HomeController extends Cubit<AppStates> {
  HomeController() : super(AppInitialState());
  static HomeController get(context) => BlocProvider.of(context);
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int selectedIndex = 0;
  List pages = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    selectedIndex = index;
    emit(AppChangePageState());
  }

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  bool isSheetShow = false;
  Database? database;
  IconData fabIcon = Icons.edit;

  void createDataBase()  {
    openDatabase('todo.db', version: 1, onOpen: (database) {
      getDataBase(database);
      print('database opened');
    }, onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  void getDataBase(database) {
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();

    emit(AppGetLoadingState());
    database?.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }

  void upDateData({
    @required String? status,
    @required int? id,
  })  {
    database?.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }


  void deleteData({
    @required int? id,
  }) async {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      getDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void insertToDataBase({
    @required String? title,
    @required String? time,
    @required String? date,
  })  {
     database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,time,date,status)VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDataBaseState());
        getDataBase(database);
      }).catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });
    });
  }

  void changeBottomSheet({@required bool? isShow, @required IconData? icon}) {
    isSheetShow = isShow!;
    fabIcon = icon!;
    emit(AppChangeSheetShowState());
  }
}
