import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/task_service.dart';
import '../../../models/task_model.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _taskService = TaskService();
  late Future<TaskModel?> _taskFuture;

  @override
  void initState() {
    super.initState();
    _taskFuture = _taskService.getTask(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await context.push(AppRoutes.editTask.replaceFirst(':id', widget.taskId));
              setState(() { _taskFuture = _taskService.getTask(widget.taskId); });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<TaskModel?>(
        future: _taskFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final task = snapshot.data;
          if (task == null) return const Center(child: Text('Task not found'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChip(task.status.displayName, _getStatusColor(task.status)),
                const SizedBox(height: 16),
                Text(task.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 24),
                _buildInfoRow(Icons.calendar_today_outlined, 'Due Date', task.deadline.toString().split(' ')[0]),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.priority_high_rounded, 'Priority', task.priority.displayName),
                const SizedBox(height: 32),
                const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Text(task.description.isEmpty ? 'No description provided' : task.description, 
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5)),
                const SizedBox(height: 48),
                if (task.status != TaskStatus.completed)
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _taskService.updateTask(
                        taskId: widget.taskId, 
                        task: task.copyWith(status: TaskStatus.completed, updatedAt: DateTime.now()),
                      );
                      setState(() {
                        _taskFuture = _taskService.getTask(widget.taskId);
                      });
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark as Completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _taskService.updateTask(
                        taskId: widget.taskId, 
                        task: task.copyWith(status: TaskStatus.planned, updatedAt: DateTime.now()),
                      );
                      setState(() {
                        _taskFuture = _taskService.getTask(widget.taskId);
                      });
                    },
                    icon: const Icon(Icons.undo_rounded),
                    label: const Text('Mark as Active'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.surfaceLight),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text('$label: ', style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.planned: return Colors.blue;
      case TaskStatus.inProgress: return Colors.orange;
      case TaskStatus.completed: return AppColors.secondary;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () async {
            await _taskService.deleteTask(widget.taskId);
            if (mounted) { context.pop(); context.pop(); }
          }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
