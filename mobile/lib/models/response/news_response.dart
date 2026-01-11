class NewsResponse {
  final List<NewsItem> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  NewsResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => NewsItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}

class NewsItem {
  final String id;
  final String title;
  final String date;
  final String summary;
  final String readTime;
  final String imageUrl;
  final String category;
  final String author;

  NewsItem({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
    required this.readTime,
    required this.imageUrl,
    required this.category,
    required this.author,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      readTime: json['readTime'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'summary': summary,
      'readTime': readTime,
      'imageUrl': imageUrl,
      'category': category,
      'author': author,
    };
  }
}
