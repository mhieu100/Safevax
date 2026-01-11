import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/medical_details/medical_details_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class MedicalNewsDetailScreen extends GetView<MedicalNewsDetailController> {
  const MedicalNewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text(
          'Chi tiết tin tức',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF199A8E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final news = controller.newsDetail;

        if (news.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  news["image"] ?? "",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                news["title"] ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF199A8E),
                ),
              ),
              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Text(
                    news["date"] ?? "",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),

              // Content
              Html(
                data: news["content"] ??
                    "<p>Không có nội dung chi tiết cho bài báo này.</p>",
                style: {
                  "p": Style(
                    fontSize: FontSize(15),
                    lineHeight: LineHeight(1.6),
                    color: const Color(0xFF475569),
                  ),
                  "h2": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF199A8E),
                    margin: Margins.only(bottom: 8),
                  ),
                  "h3": Style(
                    fontSize: FontSize(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF199A8E),
                    margin: Margins.only(bottom: 6),
                  ),
                  "ul": Style(
                    margin: Margins.only(left: 16, bottom: 8),
                  ),
                  "li": Style(
                    fontSize: FontSize(15),
                    lineHeight: LineHeight(1.6),
                    color: const Color(0xFF475569),
                  ),
                },
              ),

              const SizedBox(height: 24),

              // Source
              if (news["source"] != null && news["source"]!.isNotEmpty)
                Text(
                  "Nguồn: ${news["source"]}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF64748B),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
