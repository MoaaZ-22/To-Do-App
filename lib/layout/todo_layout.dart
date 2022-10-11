// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class ToDoLayout extends StatelessWidget

{
  const ToDoLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    var titleController = TextEditingController();
    var timeController = TextEditingController();
    var dateController = TextEditingController();
    bool isClickable = true;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context ,AppStates state)
      {
        if (state is AppInsertDateBaseState)
        {
          Navigator.pop(context);
          titleController.clear();
          timeController.clear();
          dateController.clear();
        }
      },

      builder: (BuildContext context ,AppStates state){
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(cubit.titles[cubit.currantIndex]),
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDateBaseLoadingState,
            builder: (context) => cubit.screen[cubit.currantIndex],
            fallback: (context) =>const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isButtonSheetShown) {
                if (_formKey.currentState!.validate()) {
                  cubit.insertDataBase(title: titleController.text, time: timeController.text, date: dateController.text);

                }
              } else {
                scaffoldKey.currentState?.showBottomSheet(

                        (context) => Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReusableTextField(
                            isEnabled: isClickable,
                            controller: titleController,
                            isPassword: false,
                            prefixIcon: Icons.title,
                            keyboardInputType: TextInputType.text,
                            labelText: 'Task Title',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Title must not be Empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextField(
                            isEnabled: isClickable,
                            onTab: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text = value!.format(context);
                              });
                            },
                            controller: timeController,
                            isPassword: false,
                            prefixIcon: Icons.watch_later_outlined,
                            keyboardInputType: TextInputType.datetime,
                            labelText: 'Task Time',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Time must not be Empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextField(
                            isEnabled: isClickable,
                            onTab: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2022, 11, 15),
                              ).then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              }).catchError((error) {
                                if (kDebugMode) {
                                  print(
                                      'There Is Error When You Try to Select Date ${error.toString()}');
                                }
                              });
                            },
                            controller: dateController,
                            isPassword: false,
                            prefixIcon: Icons.date_range,
                            keyboardInputType: TextInputType.datetime,
                            labelText: 'Task Date',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Date must not be Empty';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )).closed.then((value)
                {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  timeController.clear();
                  titleController.clear();
                  dateController.clear();
                }
                );
                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currantIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archive')
            ],
          ),
        );
      },
    );
  }


}



