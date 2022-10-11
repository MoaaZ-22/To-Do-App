import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:too_do_app/shared/bloc_observer.dart';


import 'layout/cubit/cubit.dart';
import 'layout/todo_layout.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = ToDoAppBlocObserver();
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ToDoLayout(),
      ),
    );
  }
}

