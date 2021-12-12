import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/layout/news-app/cubit/states.dart';
import 'package:udemy_flutter/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:udemy_flutter/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/todo_app/new_tasks/new_tasks_screen.dart';
import 'package:udemy_flutter/shared/components/constance.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=> BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex (int index)
  {
   currentIndex = index;
   emit(AppChangeBottomNavBarState());
  }
   late Database database;
   List<Map> newTasks = [];
   List<Map> doneTasks = [];
   List<Map> archivedTasks = [];

  void createDatabase()
  {
     openDatabase(
        'todo_five.db',
        version: 1,
        onCreate: (database, version)
        {
          print('Data base created');
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value){
            print('table Created');
          }).catchError((error){
            print('Error When Create Table ${error.toString()}');
          });
        },

        onOpen: (database){
          getDataFromDatabase(database);
          print ('database opened');
        }).then((value) {
          database = value;
          emit(AppCreateDatabaseState());
     } );

  }
  insertToDatabase({
    required String title,
    required String time,
    required String date,

  }) async
  {
    await database.transaction((txn){
      txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")').then((value){
        print('$value Inserted status successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error){
        print('Error When insert data in Table ${error.toString()}');
      });
      return null;
    });

  }
  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element) 
      {
      if(element['status'] == 'new') {
        newTasks.add(element);
      } else if(element['status'] == 'done') {
        doneTasks.add(element);
      }else {
        archivedTasks.add(element);
      }
      });
      emit(AppGetDatabaseState());
    });

  }
  void updateDateData({
  required String status,
  required int id,
})async
  {
    await database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
          emit(AppUpdateDatabaseState());
    });


  }
  // Delete
  void deleteData({
    required int id,
  })async
  {
    await database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],

    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });


  }
  bool isBottomSheetShow = false;
  IconData fabIcon  = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
  bool isDark = false;

  void changeAppMode({ bool? fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
    }

  CacheHelper.putData(key: 'isDark', value: isDark).then((value)
  {
    emit(AppChangeModeState());
  });


  }
}

