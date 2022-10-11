import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:too_do_app/layout/cubit/states.dart';
import '../../modules/archive.dart';
import '../../modules/done.dart';
import '../../modules/tasks.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  // Object From This Class
  static AppCubit get(context) => BlocProvider.of(context);

  int currantIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  IconData fabIcon = Icons.edit;
  bool isButtonSheetShown = false;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  bool isClickable = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();


    late Database database;

  List<Widget> screen =
  [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchiveTasksScreen()
  ];

  List<String> titles =
  [
    'New Task Screen',
    'Done Task Screen',
    'Archive Task Screen'
  ];
  void changeIndex(int index)
  {
    currantIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  //  Create DataBase
  void createDataBase() {
   openDatabase(
      'todo.db', //Name Of DataBase You Want
      version: 1,
      //Version Of DataBase Don't change it
      // until you Change Table Structure
      // Such As add New Column or Delete Column
      onCreate: (database, version)
      // It's Executed once When DataBase Created
      // (one Time Execute)
      //Then We Create table Here
      {
        if (kDebugMode) {
          print('DataBase Created');
        }
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          if (kDebugMode) {
            print('Table Created');
          }
        }).catchError((error) {
          if (kDebugMode) {
            print('Error When Creating Table ${error.toString()}');
          }
        });
      },
      onOpen: (database)
      // It Gets Called Every Time The App Opens

      {
        if (kDebugMode) {
          print('DataBase Opened');
          getDataFromDatabase(database);
        }
      },
    ).then((value) => {
      database = value,
        emit(AppCreateDateBaseState())
    });

  }

  // Insert Into DataBase
   insertDataBase({required String title,required String time,required String date}) async{
    await database.transaction((txn) => txn
        .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date" , "$time","new")')
        .then((value) {
      if (kDebugMode) {
        print('$value Has Been Inserted');
        emit(AppInsertDateBaseState());

        getDataFromDatabase(database);
      }
    }
    ).catchError((error) {
      if (kDebugMode) {
        print('There Is an Error when data Inserted ${error.toString()}');
      }
    }));
  }

  // Get Data From DataBase
  getDataFromDatabase(database)
   {
     newTasks = [];
     doneTasks = [];
     archiveTasks = [];

    emit(AppGetDateBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element) {
       if(element['status'] == 'new')
         {
           newTasks.add(element);
         }
       else if(element['status'] == 'done')
         {
           doneTasks.add(element);
         }else
           {
             archiveTasks.add(element);
           }
      });
      emit(AppGetDateBaseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon,})
  {
    isButtonSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({required String status, required int id }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDateBaseState());
    });
    if (kDebugMode) {
      print('updated: ');
    }

  }

  void deleteData({required int id }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDateBaseState());
    });
    if (kDebugMode) {
      print('Deleted: ');
    }

  }

}