import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/task_service.dart';
import '../../../models/task_model.dart';
import '../../../core/constants/app_colors.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _taskService = TaskService();
  DateTime? _selectedDeadline;
  String? _selectedStatus;
  String? _selectedPriority;
  bool _isLoading = false;
  TaskModel? _originalTask;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final task = await _taskService.getTask(widget.taskId);
    if (task != null) {
      setState(() {
        _originalTask = task;
        _titleController.text = task.title;
        _descriptionController.text = task.description;
        _selectedDeadline = task.deadline;
        _selectedStatus = task.status.displayName;
        _selectedPriority = task.priority.displayName;
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate() && _originalTask != null) {
      setState(() => _isLoading = true);
      try {
        final updatedTask = _originalTask!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          deadline: _selectedDeadline,
          status: TaskStatus.fromString(_selectedStatus ?? 'Planned'),
          priority: TaskPriority.fromString(_selectedPriority ?? 'Medium'),
          updatedAt: DateTime.now(),
        );
        await _taskService.updateTask(taskId: widget.taskId, task: updatedTask);
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: _originalTask == null || _selectedStatus == null || _selectedPriority == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Task Name'),
                      validator: (v) => v!.isEmpty ? 'Enter a name' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: ['Planned', 'In Progress', 'Completed'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _selectedStatus = v),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: ['Low', 'Medium', 'High'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _selectedPriority = v),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleUpdate,
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Update Task'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
