import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';
import '../shared/components/components.dart';



class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener:(BuildContext context ,AppStates states){},
        builder:(BuildContext context ,AppStates states) {
          var tasks = AppCubit.get(context).archiveTasks;
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