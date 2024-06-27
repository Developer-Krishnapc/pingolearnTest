import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_pdf_res.freezed.dart';
part 'export_pdf_res.g.dart';

@freezed
class ExportPdfRes with _$ExportPdfRes {
  const factory ExportPdfRes({
    @JsonKey(name: 'file_path') @Default('') String url,
    @Default('') String name,
  }) = _ExportPdfRes;

  factory ExportPdfRes.fromJson(Map<String, dynamic> json) =>
      _$ExportPdfResFromJson(json);
}
