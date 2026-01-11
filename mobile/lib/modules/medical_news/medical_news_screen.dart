// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/featured_news_response.dart';
import 'package:flutter_getx_boilerplate/modules/medical_news/medical_news_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:get/get.dart';

class MedicalNewsScreen extends GetView<MedicalNewsController> {
  const MedicalNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Kiến thức & Tin tức y tế',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Search button
          IconButton(
            onPressed: () => _showSearchDialog(context),
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          // Filter button
          IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF199A8E)),
            ),
          );
        }

        if (controller.filteredNewsList.isEmpty) {
          return _buildEmptyState();
        }

        return Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredNewsList.length,
              itemBuilder: (context, index) {
                final news = controller.filteredNewsList[index];
                return _buildEnhancedNewsCard(news, index);
              },
            ));
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.article_outlined,
              size: 64,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Không có tin tức nào',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chúng tôi sẽ cập nhật tin tức y tế mới nhất cho bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedNewsCard(NewsItem news, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            controller.toMedicalNewsDetailScreen(news);
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xFF199A8E).withOpacity(0.1),
          highlightColor: const Color(0xFF199A8E).withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // News image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      news.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.article,
                            color: Color(0xFF9CA3AF),
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // News content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF199A8E),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Summary
                      Text(
                        news.summary,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Read more indicator
                      const Row(
                        children: [
                          Text(
                            'Đọc thêm',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF199A8E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: Color(0xFF199A8E),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController =
        TextEditingController(text: controller.searchQuery.value);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tìm kiếm tin tức'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Nhập từ khóa tìm kiếm...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              controller.setSearchQuery(searchController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Tìm kiếm'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String selectedSortBy = controller.sortBy.value;
    String selectedSortOrder = controller.sortOrder.value;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sắp xếp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sort by
            DropdownButtonFormField<String>(
              value: selectedSortBy,
              decoration: const InputDecoration(labelText: 'Sắp xếp theo'),
              items: const [
                DropdownMenuItem(value: 'date', child: Text('Ngày')),
                DropdownMenuItem(value: 'title', child: Text('Tiêu đề')),
              ],
              onChanged: (value) => selectedSortBy = value ?? 'date',
            ),
            const SizedBox(height: 16),
            // Sort order
            DropdownButtonFormField<String>(
              value: selectedSortOrder,
              decoration: const InputDecoration(labelText: 'Thứ tự'),
              items: const [
                DropdownMenuItem(value: 'desc', child: Text('Mới nhất')),
                DropdownMenuItem(value: 'asc', child: Text('Cũ nhất')),
              ],
              onChanged: (value) => selectedSortOrder = value ?? 'desc',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              controller.setSorting(selectedSortBy, selectedSortOrder);
              Navigator.of(context).pop();
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }
}
