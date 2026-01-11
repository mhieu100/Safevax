import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedItem {
  final String id;
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final String type; // 'vaccine', 'article', 'facility', etc.

  SavedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.type,
  });
}

class SavedItemsController extends GetxController {
  final savedItems = <SavedItem>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedItems();
  }

  void loadSavedItems() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    savedItems.value = [
      SavedItem(
        id: '1',
        title: 'Vaccine COVID-19',
        description: 'Thông tin về vaccine phòng COVID-19',
        date: '20/09/2024',
        icon: Icons.vaccines,
        type: 'vaccine',
      ),
      SavedItem(
        id: '2',
        title: 'Bệnh viện Việt Đức',
        description: 'Cơ sở y tế uy tín tại Hà Nội',
        date: '18/09/2024',
        icon: Icons.local_hospital,
        type: 'facility',
      ),
      SavedItem(
        id: '3',
        title: 'Cách chăm sóc sức khỏe mùa đông',
        description: 'Bài viết về cách bảo vệ sức khỏe trong mùa lạnh',
        date: '15/09/2024',
        icon: Icons.article,
        type: 'article',
      ),
      SavedItem(
        id: '4',
        title: 'Vaccine sởi',
        description: 'Lịch tiêm vaccine phòng sởi cho trẻ em',
        date: '12/09/2024',
        icon: Icons.vaccines,
        type: 'vaccine',
      ),
    ];

    isLoading.value = false;
  }

  void removeItem(SavedItem item) {
    savedItems.remove(item);
    Get.snackbar(
      'Đã xóa',
      'Đã xóa khỏi mục đã lưu',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openItem(SavedItem item) {
    // Navigate to the specific item based on its type
    switch (item.type) {
      case 'vaccine':
        Get.toNamed('/vaccineInfo', arguments: item.id);
        break;
      case 'facility':
        Get.toNamed('/facilityDetail', arguments: item.id);
        break;
      case 'article':
        Get.toNamed('/articleDetail', arguments: item.id);
        break;
      default:
        Get.snackbar(
          'Thông báo',
          'Không thể mở mục này',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }

  void clearAllItems() {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả mục đã lưu?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              savedItems.clear();
              Get.snackbar(
                'Đã xóa',
                'Đã xóa tất cả mục đã lưu',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Xóa tất cả',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}