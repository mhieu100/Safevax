class VaccineListResponse {
  final int statusCode;
  final String message;
  final VaccineListData data;

  VaccineListResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory VaccineListResponse.fromJson(Map<String, dynamic> json) {
    return VaccineListResponse(
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: VaccineListData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class VaccineListData {
  final Meta meta;
  final List<VaccineItem> result;

  VaccineListData({
    required this.meta,
    required this.result,
  });

  factory VaccineListData.fromJson(Map<String, dynamic> json) {
    return VaccineListData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      result: (json['result'] as List<dynamic>?)
              ?.map((item) => VaccineItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'result': result.map((item) => item.toJson()).toList(),
    };
  }
}

class Meta {
  final int page;
  final int pageSize;
  final int pages;
  final int total;

  Meta({
    required this.page,
    required this.pageSize,
    required this.pages,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 12,
      pages: json['pages'] ?? 1,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'pages': pages,
      'total': total,
    };
  }
}

class VaccineItem {
  final int id;
  final String slug;
  final String name;
  final String country;
  final String image;
  final int price;
  final int stock;
  final String descriptionShort;
  final String description;
  final String manufacturer;
  final List<dynamic> injection;
  final List<dynamic> preserve;
  final List<dynamic> contraindications;
  final int dosesRequired;
  final int duration;

  VaccineItem({
    required this.id,
    required this.slug,
    required this.name,
    required this.country,
    required this.image,
    required this.price,
    required this.stock,
    required this.descriptionShort,
    required this.description,
    required this.manufacturer,
    required this.injection,
    required this.preserve,
    required this.contraindications,
    required this.dosesRequired,
    required this.duration,
  });

  factory VaccineItem.fromJson(Map<String, dynamic> json) {
    return VaccineItem(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      descriptionShort: json['descriptionShort'] ?? '',
      description: json['description'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      injection: json['injection'] ?? [],
      preserve: json['preserve'] ?? [],
      contraindications: json['contraindications'] ?? [],
      dosesRequired: json['dosesRequired'] ?? 1,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'country': country,
      'image': image,
      'price': price,
      'stock': stock,
      'descriptionShort': descriptionShort,
      'description': description,
      'manufacturer': manufacturer,
      'injection': injection,
      'preserve': preserve,
      'contraindications': contraindications,
      'dosesRequired': dosesRequired,
      'duration': duration,
    };
  }
}
