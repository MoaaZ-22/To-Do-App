import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  final List<Map>? task;
  const NewTasksScreen({Key? key,this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit,AppStates>(
          listener:(BuildContext context ,AppStates states){},
          builder:(BuildContext context ,AppStates states) {
            var tasks = AppCubit.get(context).newTasks;
            return ListView.separated(
              padding: const EdgeInsets.all(5),
              // Widget That i Want To Build In Screen
              itemBuilder: (context,index) => buildTaskItemToDo(tasks[index],context),
              // separator that will be between all Widget
              separatorBuilder: (context,index) => Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.blue[300],
                ),
              ),
              itemCount:tasks.length,


            );}
      );
  }
}