import 'package:flutter/material.dart';
import '../widgets/add_task_sheet.dart';
import '../../../core/constants/app_colors.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('New Task')),
      body: const AddTaskSheet(),
    );
  }
}
