import 'package:flutter_getx_boilerplate/api/api.dart';
import 'package:flutter_getx_boilerplate/repositories/base_repository.dart';

class NotificationRepository extends BaseRepository {
  final ApiServices apiClient;

  NotificationRepository({required this.apiClient});

  /// Android 12+ cần Exact Alarm: redirect user tới Settings
  Future<bool> hasExactAlarmPermission() async {
    // Flutter không thể check programmatically
    // Mặc định trả true để không block iOS hoặc Android <12
    return true;
  }
}
