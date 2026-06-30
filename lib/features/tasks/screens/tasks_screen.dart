import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../services/task_service.dart';
import '../../auth/services/auth_service.dart';
import '../../../models/task_model.dart';
import '../widgets/add_task_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _taskService = TaskService();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Done'),
          ],
        ),
      ),
      body: user == null
          ? const Center(child: Text('Please log in'))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(user.id, 'All'),
                _buildTaskList(user.id, 'Today'),
                _buildTaskList(user.id, 'Upcoming'),
                _buildTaskList(user.id, 'Done'),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildTaskList(String userId, String filter) {
    return StreamBuilder<List<TaskModel>>(
      stream: _taskService.getTasksStream(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        var tasks = snapshot.data ?? [];
        
        if (filter == 'Today') {
          final now = DateTime.now();
          tasks = tasks.where((t) => t.deadline.day == now.day && t.deadline.month == now.month && t.deadline.year == now.year).toList();
        } else if (filter == 'Upcoming') {
          final now = DateTime.now();
          tasks = tasks.where((t) => t.deadline.isAfter(now) && t.status != TaskStatus.completed).toList();
        } else if (filter == 'Done') {
          tasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
        }

        if (tasks.isEmpty) return const Center(child: Text('No tasks found', style: TextStyle(color: AppColors.textSecondary)));

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _taskService.updateTask(taskId: task.id, task: task.copyWith(status: TaskStatus.completed)),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(24)),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.taskDetails.replaceFirst(':id', task.id)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.surfaceLight),
                    ),
                    child: Row(
                      children: [
                        _buildPriorityIndicator(task.priority),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title, style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.white,
                                decoration: task.status == TaskStatus.completed ? TextDecoration.lineThrough : null,
                              )),
                              const SizedBox(height: 4),
                              Text(task.deadline.toString().split(' ')[0], style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              context.push(AppRoutes.editTask.replaceFirst(':id', task.id));
                            } else if (value == 'delete') {
                              final confirm = await _showDeleteConfirm(context);
                              if (confirm == true) {
                                await _taskService.deleteTask(task.id);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final newStatus = task.status == TaskStatus.completed 
                                ? TaskStatus.planned 
                                : TaskStatus.completed;
                            _taskService.updateTask(
                              taskId: task.id, 
                              task: task.copyWith(status: newStatus),
                            );
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: task.status == TaskStatus.completed
                                ? const Icon(Icons.check_circle, key: ValueKey('done'), color: AppColors.secondary)
                                : Icon(Icons.circle_outlined, key: ValueKey('undone'), color: AppColors.textSecondary.withValues(alpha: 0.3)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color;
    switch (priority) {
      case TaskPriority.low: color = AppColors.priorityLow; break;
      case TaskPriority.medium: color = AppColors.priorityMedium; break;
      case TaskPriority.high: color = AppColors.priorityHigh; break;
    }
    return Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)));
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => const AddTaskSheet(),
    );
  }
}
