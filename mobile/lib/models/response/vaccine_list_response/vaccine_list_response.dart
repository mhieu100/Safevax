// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine.dart';

part 'vaccine_list_response.g.dart';

@JsonSerializable()
class VaccineListResponse {
  final int? statusCode;
  final String? message;
  final VaccineListData? data;

  const VaccineListResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  @override
  String toString() {
    return 'VaccineListResponse(statusCode: $statusCode, message: $message, data: $data)';
  }

  factory VaccineListResponse.fromJson(Map<String, dynamic> json) {
    return _$VaccineListResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VaccineListResponseToJson(this);

  VaccineListResponse copyWith({
    int? statusCode,
    String? message,
    VaccineListData? data,
  }) {
    return VaccineListResponse(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VaccineListResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode ^ data.hashCode;
}

@JsonSerializable()
class VaccineListData {
  final PaginationMeta? meta;
  final List<Vaccine>? result;

  const VaccineListData({
    this.meta,
    this.result,
  });

  @override
  String toString() {
    return 'VaccineListData(meta: $meta, result: $result)';
  }

  factory VaccineListData.fromJson(Map<String, dynamic> json) {
    return _$VaccineListDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VaccineListDataToJson(this);

  VaccineListData copyWith({
    PaginationMeta? meta,
    List<Vaccine>? result,
  }) {
    return VaccineListData(
      meta: meta ?? this.meta,
      result: result ?? this.result,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VaccineListData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => meta.hashCode ^ result.hashCode;
}

@JsonSerializable()
class PaginationMeta {
  final int? page;
  final int? pageSize;
  final int? pages;
  final int? total;

  const PaginationMeta({
    this.page,
    this.pageSize,
    this.pages,
    this.total,
  });

  @override
  String toString() {
    return 'PaginationMeta(page: $page, pageSize: $pageSize, pages: $pages, total: $total)';
  }

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return _$PaginationMetaFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);

  PaginationMeta copyWith({
    int? page,
    int? pageSize,
    int? pages,
    int? total,
  }) {
    return PaginationMeta(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      pages: pages ?? this.pages,
      total: total ?? this.total,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PaginationMeta) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      page.hashCode ^ pageSize.hashCode ^ pages.hashCode ^ total.hashCode;
}
