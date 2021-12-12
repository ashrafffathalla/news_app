import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:udemy_flutter/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/todo_app/new_tasks/new_tasks_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constance.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget
{

  var scaffoldKey= GlobalKey<ScaffoldState>();
  var formKey= GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();



  @override
  Widget build(BuildContext context)
  {
    return  BlocProvider(
      create: (BuildContext context)  => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit ,AppStates>(
        listener:(BuildContext context, AppStates state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder:(BuildContext context, AppStates state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            backgroundColor: Colors.amber,
          ),
          body: ConditionalBuilder(
            condition: state is! GetDatabaseLoadingState,
            builder: (context)=>cubit.screens[cubit.currentIndex],
            fallback: (context)=>Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: ()
            {
              if(cubit.isBottomSheetShow)
              {
                if(formKey.currentState!.validate())
                {
                  cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                  );
                  // insertToDatabase(
                  //   title: titleController.text,
                  //   time: timeController.text,
                  //   date: dateController.text,
                  // ).then((value) {
                  //   getDataFromDatabase(database).then((value)
                  //   {
                  //     Navigator.pop(context);
                  //     // setState(() {
                  //     //   //خلاص انا قفلت ف لازم اخليه false
                  //     //   isBottomSheetShow = false;
                  //     //   fabIcon = Icons.edit;
                  //     //   tasks = value;
                  //     //   print(tasks);
                  //     // });
                  //   });
                  // });


                }

              } else
              {


                scaffoldKey.currentState!.showBottomSheet(
                      (context) => Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'title must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Title',
                            prefix: Icons.title,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: timeController,
                            type: TextInputType.text,
                            onTab: ()
                            {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value)
                              {
                                timeController.text=value!.format(context).toString();
                                print(value.format(context));
                              });
                            },
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Time',
                            prefix: Icons.watch_later_outlined,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: dateController,
                            type: TextInputType.text,
                            onTab: ()
                            {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2021-12-03'),
                              ).then((value) {
                                print(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
                                dateController.text = DateFormat.yMMMd().format(value!);
                              });
                            },
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'date must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Date',
                            prefix: Icons.calendar_today,
                          ),

                        ],
                      ),
                    ),
                  ),
                  elevation: 20.0,

                ).closed.then((value)
                {
                  cubit.changeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                });
                cubit.changeBottomSheetState(
                  isShow: true,
                  icon: Icons.add,
                );
              }

              // insertToDatabase();
              /*
          try{
            var name = await getName();
            print(name);

            throw('Hello Error!!!!');
          }catch(error)
          {
            print('error ${error.toString()}');
          }*/
              /*
           getName().then((value)
           {
            print(value);
            print('osama');
            throw(' Error Ya bro ');
          }).catchError((error){
            print('error is ${error.toString()}');
          });
*/
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index)
            {
              AppCubit.get(context).changeIndex(index);
            },
            items: const[

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                  color: Colors.amberAccent,
                ),
                label:'Tasks',


              ),
              BottomNavigationBarItem(
                icon:Icon(
                  Icons.check,
                  color: Colors.amberAccent,
                ),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon:Icon(
                  Icons.archive_outlined,
                  color: Colors.amberAccent,
                ),
                label: 'archived',
              ),
            ],
          ),
        );
        },
      ),
    );

  }
  // Future<String> getName()async
  // {
  //   return'Ahmed Ali';
  // }

}



