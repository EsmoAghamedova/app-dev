import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskService {
  final FirebaseService _firebaseService = FirebaseService();

  // Create task
  Future<TaskModel> createTask({required TaskModel task}) async {
    try {
      final docRef = await _firebaseService.firestore
          .collection('tasks')
          .add(task.copyWith(id: '').toMap());

      return task.copyWith(id: docRef.id);
    } catch (e) {
      throw 'Failed to create task: $e';
    }
  }

  // Get all tasks for user
  Stream<List<TaskModel>> getTasksStream(String userId) {
    return _firebaseService.firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromMap({'id': doc.id, ...doc.data()}))
              .toList();
        });
  }

  // Get tasks by status
  Stream<List<TaskModel>> getTasksByStatus(String userId, String status) {
    return _firebaseService.firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromMap({'id': doc.id, ...doc.data()}))
              .toList();
        });
  }

  // Get single task
  Future<TaskModel?> getTask(String taskId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection('tasks')
          .doc(taskId)
          .get();

      if (doc.exists) {
        return TaskModel.fromMap({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      throw 'Failed to get task: $e';
    }
  }

  // Update task
  Future<void> updateTask({
    required String taskId,
    required TaskModel task,
  }) async {
    try {
      await _firebaseService.firestore
          .collection('tasks')
          .doc(taskId)
          .update(task.copyWith(id: taskId).toMap());
    } catch (e) {
      throw 'Failed to update task: $e';
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firebaseService.firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw 'Failed to delete task: $e';
    }
  }

  // Count tasks by status
  Future<Map<String, int>> getTaskCounts(String userId) async {
    try {
      final Map<String, int> counts = {
        'planned': 0,
        'inProgress': 0,
        'completed': 0,
      };

      final snapshot = await _firebaseService.firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        final status = doc['status'] as String;
        if (status.toLowerCase() == 'planned') {
          counts['planned'] = counts['planned']! + 1;
        } else if (status.toLowerCase().contains('progress')) {
          counts['inProgress'] = counts['inProgress']! + 1;
        } else if (status.toLowerCase() == 'completed') {
          counts['completed'] = counts['completed']! + 1;
        }
      }

      return counts;
    } catch (e) {
      throw 'Failed to get task counts: $e';
    }
  }
}
