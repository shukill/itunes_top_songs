import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Request battery optimization permission
  Future<bool> requestBatteryOptimizationPermission() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }

  /// Check notification permission status
  Future<bool> isNotificationPermissionGranted() async {
    return await Permission.notification.isGranted;
  }

  /// Check battery optimization permission status
  Future<bool> isBatteryOptimizationPermissionGranted() async {
    return await Permission.ignoreBatteryOptimizations.isGranted;
  }

  /// Request all required permissions
  Future<Map<String, bool>> requestAllPermissions() async {
    final notificationPermission = await requestNotificationPermission();
    final batteryOptimizationPermission =
        await requestBatteryOptimizationPermission();

    return {
      'notification': notificationPermission,
      'batteryOptimization': batteryOptimizationPermission,
    };
  }

  /// Show permission dialog
  Future<void> showPermissionDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onRequestPermission,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRequestPermission();
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
}
