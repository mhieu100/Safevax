import 'package:json_annotation/json_annotation.dart';

part 'file_upload_response.g.dart';

@JsonSerializable()
class FileUploadResponse {
  final int? statusCode;
  final String? message;
  final FileUploadData? data;

  const FileUploadResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return _$FileUploadResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);
}

@JsonSerializable()
class FileUploadData {
  final String? fileName;
  final String? uploadedAt;

  const FileUploadData({
    this.fileName,
    this.uploadedAt,
  });

  factory FileUploadData.fromJson(Map<String, dynamic> json) {
    return _$FileUploadDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FileUploadDataToJson(this);
}
