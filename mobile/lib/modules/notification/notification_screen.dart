// lib/modules/notification/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/notification/notification_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Quản lý thông báo'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNotificationStatus(),
                      const SizedBox(height: 24),
                      _buildTestSection(),
                      const SizedBox(height: 24),
                      _buildScheduledNotifications(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildPermissionStatus(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationStatus() {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: controller.notificationsEnabled
                      ? [Colors.green.shade50, Colors.green.shade100]
                      : [Colors.orange.shade50, Colors.orange.shade100],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            controller.notificationsEnabled
                                ? Icons.notifications_active
                                : Icons.notifications_off,
                            key: ValueKey(controller.notificationsEnabled),
                            color: controller.notificationsEnabled
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.notificationsEnabled
                                    ? 'Thông báo đã bật'
                                    : 'Thông báo chưa bật',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: controller.notificationsEnabled
                                      ? Colors.green.shade800
                                      : Colors.orange.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.notificationsEnabled
                                    ? 'Bạn sẽ nhận được thông báo nhắc lịch tiêm chủng'
                                    : 'Vui lòng cấp quyền để nhận thông báo nhắc lịch',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!controller.notificationsEnabled) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await controller.requestPermissions();
                            Get.snackbar(
                              'Thông báo',
                              'Đã yêu cầu cấp quyền thông báo',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue.shade50,
                              colorText: Colors.blue.shade800,
                            );
                          },
                          icon: const Icon(Icons.settings),
                          label: const Text('Cấp quyền thông báo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildTestSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.science,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kiểm tra thông báo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Gửi thông báo thử nghiệm để kiểm tra hệ thống hoạt động',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await controller.sendTestNotification();
                    Get.snackbar(
                      'Thành công',
                      'Đã gửi thông báo thử nghiệm',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.shade50,
                      colorText: Colors.green.shade800,
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Gửi thông báo thử nghiệm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduledNotifications() {
    return Obx(() => Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.purple.shade50, Colors.purple.shade100],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.purple.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Thông báo đã lên lịch',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${controller.scheduledNotifications.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (controller.scheduledNotifications.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Chưa có thông báo nào được lên lịch',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.scheduledNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = controller.scheduledNotifications[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                Icons.notifications,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            title: Text(
                              notification.title ?? 'Không có tiêu đề',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  notification.body ?? 'Không có nội dung',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${notification.id}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade400,
                              ),
                              onPressed: () => _cancelNotification(notification.id),
                              tooltip: 'Xóa thông báo',
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bolt,
                    color: Colors.teal.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hành động nhanh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _scheduleTestReminder();
                        Get.snackbar(
                          'Thành công',
                          'Đã lên lịch thông báo thử nghiệm',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade50,
                          colorText: Colors.green.shade800,
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_alarm),
                      label: const Text('Lên lịch thử nghiệm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await controller.cancelAllNotifications();
                        Get.snackbar(
                          'Đã xóa',
                          'Đã xóa tất cả thông báo đã lên lịch',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade50,
                          colorText: Colors.red.shade800,
                          icon: Icon(
                            Icons.delete_sweep,
                            color: Colors.red.shade600,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Xóa tất cả'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        foregroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _buildPermissionStatus() {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getStatusColor(controller.permissionStatus),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor(controller.permissionStatus).withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  _getStatusIcon(controller.permissionStatus),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusTitle(controller.permissionStatus),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getStatusText(controller.permissionStatus),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.permissionStatus == PermissionStatus.denied ||
                  controller.permissionStatus == PermissionStatus.permanentlyDenied)
                IconButton(
                  onPressed: () => openAppSettings(),
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 20,
                  ),
                  tooltip: 'Mở cài đặt',
                ),
            ],
          ),
        ));
  }

  Color _getStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
        return Colors.orange;
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      case PermissionStatus.restricted:
        return Colors.purple;
      case PermissionStatus.limited:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return Icons.check_circle;
      case PermissionStatus.denied:
        return Icons.warning;
      case PermissionStatus.permanentlyDenied:
        return Icons.error;
      case PermissionStatus.restricted:
        return Icons.do_not_disturb;
      case PermissionStatus.limited:
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Quyền thông báo đã được cấp';
      case PermissionStatus.denied:
        return 'Quyền thông báo bị từ chối. Vui lòng cấp quyền.';
      case PermissionStatus.permanentlyDenied:
        return 'Quyền thông báo bị từ chối vĩnh viễn. Vui lòng cấp quyền trong cài đặt.';
      case PermissionStatus.restricted:
        return 'Quyền thông báo bị hạn chế';
      case PermissionStatus.limited:
        return 'Quyền thông báo bị giới hạn';
      default:
        return 'Trạng thái quyền không xác định';
    }
  }

  String _getStatusTitle(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Quyền đã cấp';
      case PermissionStatus.denied:
        return 'Quyền bị từ chối';
      case PermissionStatus.permanentlyDenied:
        return 'Quyền bị từ chối vĩnh viễn';
      case PermissionStatus.restricted:
        return 'Quyền bị hạn chế';
      case PermissionStatus.limited:
        return 'Quyền bị giới hạn';
      default:
        return 'Trạng thái không xác định';
    }
  }

  void _cancelNotification(int id) {
    controller.cancelNotification(id);
  }

  void _scheduleTestReminder() async {
    final now = DateTime.now();
    final testTime = now.add(const Duration(seconds: 10));

    // Then schedule the notification
    final success = await controller.scheduleVaccineReminder(
      doseNumber: 1,
      vaccineName: 'Vaccine Test',
      reminderTime: testTime,
      facilityName: 'Bệnh viện Test',
    );

    print('Scheduling result: ${success ? 'SUCCESS' : 'FAILED'}');

    if (success) {
      Get.snackbar('Thành công', 'Đã lên lịch thông báo thử nghiệm');
    } else {
      Get.snackbar('Lỗi', 'Không thể lên lịch thông báo');
    }
  }
}
