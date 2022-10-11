import 'package:flutter/material.dart';
import 'package:too_do_app/layout/cubit/cubit.dart';

class ReusableTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final bool? isEnabled;
  final void Function()? onTab;
  final void Function(String)? onChange;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final Function()? suffixFunc;
  final TextInputType keyboardInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const ReusableTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.keyboardInputType,
    this.suffixIcon,
    required this.isPassword,
    this.suffixFunc,
    this.controller,
    this.validator,
    this.onTab,
    this.isEnabled,
    this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: isEnabled,
      onTap: onTab,
      onChanged: onChange,
      obscureText: isPassword,
      validator: validator,
      controller: controller,
      keyboardType: keyboardInputType,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon != null
              ? IconButton(onPressed: suffixFunc, icon: Icon(suffixIcon))
              : null,
          prefixIcon: Icon(prefixIcon),
          labelText: labelText),
    );
  }
}

Widget buildTaskItemToDo(Map model, context) => Card(
  elevation: 10,
  child: Dismissible(
    key: Key(model['id'].toString()),
    background: Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(2)),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text("${model['time']}"),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${model['title']}",
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${model['date']}",
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
              icon: const Icon(
                Icons.archive_outlined,
                color: Colors.black45,
              ))
        ],
      ),
    ),
  ),
);

Widget divider({required Color colorOfDivider}) => Padding(
  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: colorOfDivider,
  ),
);

void navigateTo (context,dynamic widget) =>  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => widget),
);