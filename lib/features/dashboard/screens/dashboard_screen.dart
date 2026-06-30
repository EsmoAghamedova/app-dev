import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../tasks/services/task_service.dart';
import '../../../models/task_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Good morning, ${user?.username ?? 'User'} 👋', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressCard(user?.id),
                const SizedBox(height: 32),
                _buildSectionHeader('Today\'s Tasks'),
                const SizedBox(height: 16),
                _buildTodayTasksList(user?.id),
                const SizedBox(height: 32),
                _buildSectionHeader('Quick Stats'),
                const SizedBox(height: 16),
                _buildQuickStats(user?.id),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String? userId) {
    if (userId == null) return const SizedBox();
    return StreamBuilder<List<TaskModel>>(
      stream: _taskService.getTasksStream(userId),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
        final totalTasks = tasks.length;
        final percentage = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFFA78BFA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily Progress', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      percentage == 1.0 
                          ? 'Amazing! You finished everything.' 
                          : 'Keep it up! You\'re doing great.', 
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toInt()}%', 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: AppColors.primary))),
      ],
    );
  }

  Widget _buildTodayTasksList(String? userId) {
    if (userId == null) return const SizedBox();
    return StreamBuilder<List<TaskModel>>(
      stream: _taskService.getTasksStream(userId),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        if (tasks.isEmpty) return const Text('No tasks for today');
        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return GestureDetector(
                onTap: () => context.push(AppRoutes.taskDetails.replaceFirst(':id', task.id)),
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.surfaceLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(task.priority).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(task.priority.displayName, 
                          style: TextStyle(color: _getPriorityColor(task.priority), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white), 
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(task.deadline.toString().split(' ')[0], style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(String? userId) {
    if (userId == null) return const SizedBox();
    return FutureBuilder<Map<String, int>>(
      future: _taskService.getTaskCounts(userId),
      builder: (context, snapshot) {
        final counts = snapshot.data ?? {'planned': 0, 'inProgress': 0, 'completed': 0};
        return Row(
          children: [
            _buildStatItem('Active', counts['inProgress']! + counts['planned']!, AppColors.primary),
            const SizedBox(width: 16),
            _buildStatItem('Done', counts['completed']!, AppColors.secondary),
            const SizedBox(width: 16),
            _buildStatItem('Overdue', 0, AppColors.error),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Column(
          children: [
            Text(count.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low: return AppColors.priorityLow;
      case TaskPriority.medium: return AppColors.priorityMedium;
      case TaskPriority.high: return AppColors.priorityHigh;
    }
  }
}
