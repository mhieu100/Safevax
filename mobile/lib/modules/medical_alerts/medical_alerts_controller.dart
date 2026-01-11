import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_alert_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:get/get.dart';

class MedicalAlertsController extends BaseController<MedicalAlertsRepository> {
  MedicalAlertsController(super.repository);

  var alerts = <MedicalAlert>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFakeData();
  }

  void _loadFakeData() {
    alerts.value = [
      MedicalAlert(
        title: 'Nhắc lịch tiêm MMR',
        description: 'Lịch tiêm cho bạn vào 15/09/2025.',
        date: 'Hôm nay',
        type: 'vaccine',
      ),
      MedicalAlert(
        title: 'Cảnh báo vaccine hết hạn',
        description: 'Lô vaccine cúm ABC123 sẽ hết hạn vào 20/08/2025.',
        date: 'Hôm qua',
        type: 'recall',
      ),
      MedicalAlert(
        title: 'Dịch sốt xuất huyết bùng phát',
        description: 'Khu vực Quận 7 đang có số ca sốt xuất huyết tăng cao.',
        date: '2 ngày trước',
        type: 'outbreak',
      ),
      MedicalAlert(
        title: 'Khu vực nguy cơ cao',
        description: 'Bạn đang ở gần khu vực dịch bệnh. Đề xuất tiêm phòng.',
        date: '1 tuần trước',
        type: 'location',
      ),
    ];
  }

  void toMedicalAlertsDetailScreen() {
    NavigatorHelper.toMedicalAlertsDetailScreen();
  }
}

class MedicalAlert {
  final String title;
  final String description;
  final String date;
  final String type; // vaccine, outbreak, recall, location

  MedicalAlert({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });
}
