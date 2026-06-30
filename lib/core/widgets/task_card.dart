import 'package:flutter/material.dart';
import 'package:momentum/core/constants/app_colors.dart';
import 'package:momentum/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
    this.onEditPressed,
    this.onDeletePressed,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.planned:
        return AppColors.info;
      case TaskStatus.inProgress:
        return AppColors.warning;
      case TaskStatus.completed:
        return AppColors.success;
    }
  }

  Color _getStatusBgColor() {
    switch (task.status) {
      case TaskStatus.planned:
        return AppColors.plannedBg;
      case TaskStatus.inProgress:
        return AppColors.inProgressBg;
      case TaskStatus.completed:
        return AppColors.completedBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.grey600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: onEditPressed,
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: onDeletePressed,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.status.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  Text(
                    'Due: ${task.deadline.toString().split(' ')[0]}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
