import 'package:intl/intl.dart';

class FeaturedNewsResponse {
  final List<NewsItem> news;

  FeaturedNewsResponse({required this.news});

  factory FeaturedNewsResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedNewsResponse(
      news: (json['data'] as List<dynamic>?)
              ?.map((item) => NewsItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': news.map((item) => item.toJson()).toList(),
    };
  }
}

class NewsItem {
  final int id;
  final String slug;
  final String title;
  final String shortDescription;
  final String content;
  final String thumbnailImage;
  final String coverImage;
  final String category;
  final String author;
  final int viewCount;
  final bool isFeatured;
  final bool isPublished;
  final String publishedAt;
  final String tags;
  final String source;
  final String createdAt;
  final String updatedAt;

  NewsItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.content,
    required this.thumbnailImage,
    required this.coverImage,
    required this.category,
    required this.author,
    required this.viewCount,
    required this.isFeatured,
    required this.isPublished,
    required this.publishedAt,
    required this.tags,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      content: json['content'] as String? ?? '',
      thumbnailImage: json['thumbnailImage'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? '',
      viewCount: json['viewCount'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isPublished: json['isPublished'] as bool? ?? false,
      publishedAt: json['publishedAt'] as String? ?? '',
      tags: json['tags'] as String? ?? '',
      source: json['source'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'shortDescription': shortDescription,
      'content': content,
      'thumbnailImage': thumbnailImage,
      'coverImage': coverImage,
      'category': category,
      'author': author,
      'viewCount': viewCount,
      'isFeatured': isFeatured,
      'isPublished': isPublished,
      'publishedAt': publishedAt,
      'tags': tags,
      'source': source,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Computed properties for backward compatibility
  String get summary => shortDescription;
  String get imageUrl => thumbnailImage;
  String get date {
    // Try publishedAt first
    if (publishedAt.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(publishedAt);
        return DateFormat('dd/MM/yyyy').format(dateTime);
      } catch (e) {
        // If parsing fails, return as is
        return publishedAt;
      }
    }
    // Fallback to createdAt
    if (createdAt.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(createdAt);
        return DateFormat('dd/MM/yyyy').format(dateTime);
      } catch (e) {
        return createdAt;
      }
    }
    // Last fallback
    return 'N/A';
  }

  String get readTime => '5 min'; // Default read time
}
