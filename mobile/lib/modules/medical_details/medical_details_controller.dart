import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/models/response/featured_news_response.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_details_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MedicalNewsDetailController
    extends BaseController<MedicalNewsDetailRepository> {
  MedicalNewsDetailController(super.repository);
  // Observable news detail data
  var newsDetail = {}.obs;

  @override
  void onInit() {
    super.onInit();
    loadNewsDetail();
  }

  void loadNewsDetail() {
    // Get news data from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      // Create NewsItem from args to use its computed date property
      final newsItem = NewsItem.fromJson(args);
      newsDetail.value = {
        "title": newsItem.title,
        "image": newsItem.imageUrl,
        "date": newsItem.date,
        "content": newsItem.content,
        "source": newsItem.source,
      };
    } else {
      // Fallback to empty data
      newsDetail.value = {};
    }
  }
}
