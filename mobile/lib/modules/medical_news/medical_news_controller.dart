import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/models/response/featured_news_response.dart';
import 'package:flutter_getx_boilerplate/repositories/medical_news_repository.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:get/get.dart';

class MedicalNewsController extends BaseController<MedicalNewsRepository> {
  MedicalNewsController(super.repository);

  // Loading state
  var isLoading = false.obs;

  // Filtering and sorting
  var searchQuery = ''.obs;
  var sortBy = 'date'.obs;
  var sortOrder = 'desc'.obs;

  // Data
  var newsList = <NewsItem>[].obs;
  var filteredNewsList = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
    setLoading(true);
    newsList.clear();

    try {
      final response = await repository.getFeaturedNews();
      newsList.assignAll(response.news);
      applyFilters();
    } catch (e) {
      showError('Error', 'Failed to load news');
    } finally {
      setLoading(false);
    }
  }

  void refreshNews() {
    loadNews();
  }

  void applyFilters() {
    var filtered = newsList.toList();

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((news) =>
              news.title
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              news.summary
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Apply sorting
    if (sortBy.value == 'date') {
      filtered.sort((a, b) {
        // Parse dates for comparison
        try {
          final dateA = DateTime.parse(a.publishedAt);
          final dateB = DateTime.parse(b.publishedAt);
          return sortOrder.value == 'asc'
              ? dateA.compareTo(dateB)
              : dateB.compareTo(dateA);
        } catch (e) {
          return 0; // If parsing fails, keep original order
        }
      });
    } else if (sortBy.value == 'title') {
      filtered.sort((a, b) {
        final comparison = a.title.compareTo(b.title);
        return sortOrder.value == 'asc' ? comparison : -comparison;
      });
    }

    filteredNewsList.assignAll(filtered);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setSorting(String by, String order) {
    sortBy.value = by;
    sortOrder.value = order;
    applyFilters();
  }

  void toMedicalNewsDetailScreen(NewsItem newsItem) {
    Get.toNamed(Routes.medicalNewsDetail, arguments: newsItem.toJson());
  }
}
