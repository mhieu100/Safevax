// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

part 'vaccine.g.dart';

@JsonSerializable()
class Vaccine {
  final int? id;
  final String? sku;
  final String? name;
  final String? country;
  final String? image;
  final String? descriptionShort;
  final String? description;
  final List<String>? injection;
  final List<String>? preserve;
  final List<String>? contraindications;

  const Vaccine({
    this.id,
    this.sku,
    this.name,
    this.country,
    this.image,
    this.descriptionShort,
    this.description,
    this.injection,
    this.preserve,
    this.contraindications,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return _$VaccineFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VaccineToJson(this);

  Vaccine copyWith({
    int? id,
    String? sku,
    String? name,
    String? country,
    String? image,
    String? descriptionShort,
    String? description,
    List<String>? injection,
    List<String>? preserve,
    List<String>? contraindications,
  }) {
    return Vaccine(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      country: country ?? this.country,
      image: image ?? this.image,
      descriptionShort: descriptionShort ?? this.descriptionShort,
      description: description ?? this.description,
      injection: injection ?? this.injection,
      preserve: preserve ?? this.preserve,
      contraindications: contraindications ?? this.contraindications,
    );
  }
}
