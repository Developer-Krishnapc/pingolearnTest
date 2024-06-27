import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../domain/model/design_model.dart';
import '../../domain/model/home_stats_model.dart';
import '../../domain/repository/design_repo.dart';
import '../model/common_success_model.dart';
import '../model/hanger_dropdown_model.dart';
import '../source/remote/design_source.dart';

part 'design_repo_impl.g.dart';

@riverpod
DesignRepository designRepo(DesignRepoRef ref) =>
    DesignRepositoryImpl(ref.read(designSourceProvider));

class DesignRepositoryImpl implements DesignRepository {
  DesignRepositoryImpl(this._source);

  final DesignSource _source;

  @override
  Future<Either<AppException, CommonSuccessModel>> addDesign({
    required String millRefNo,
    String? buyerRefNo,
    String? composition,
    String? count,
    int? width,
    int? weight,
    String? construction,
    required int hangerId,
    required List<String> selectedImageLIst,
  }) {
    final body = {
      'mill_reference_number': millRefNo,
      'hanger_id': hangerId,
    };
    if (buyerRefNo != null && buyerRefNo.isNotEmpty) {
      body['buyer_reference_construction'] = buyerRefNo;
    }
    if (construction != null && construction.isNotEmpty) {
      body['construction'] = construction;
    }
    if (composition != null && composition.isNotEmpty) {
      body['composition'] = composition;
    }
    if (weight != null) {
      body['gsm'] = weight;
    }
    if (width != null) {
      body['width'] = width;
    }
    if (count != null && count.isNotEmpty) {
      body['count'] = count;
    }
    return _source
        .addDesign(
          fileList: selectedImageLIst.map((e) => File(e)).toList(),
          data: jsonEncode(body),
        )
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> deleteDesign({
    required int designId,
  }) {
    return _source.deleteSample(sampleId: designId).guardFuture();
  }

  @override
  Future<Either<AppException, dynamic>> exportDesign({
    String? searchString,
    int? hangerId,
    String? buyRefNo,
    String? count,
    String? composition,
    String? construction,
    String? millRefNo,
    String? gsm,
    String? width,
  }) {
    final Map<String, dynamic> body = {
      'page': 1,
      'per_page': 250000,
    };
    if (searchString != null && searchString.isNotEmpty) {
      body['search_by'] = searchString;
    }
    if (hangerId != null) {
      body['hanger_id'] = hangerId;
    }
    if (buyRefNo != null && buyRefNo.isNotEmpty) {
      body['buyer_reference_construction'] = buyRefNo;
    }
    if (count != null && count.isNotEmpty) {
      body['count'] = count;
    }
    if (composition != null && composition.isNotEmpty) {
      body['composition'] = composition;
    }
    if (construction != null && construction.isNotEmpty) {
      body['construction'] = construction;
    }
    if (millRefNo != null && millRefNo.isNotEmpty) {
      body['mill_reference_number'] = millRefNo;
    }
    if (gsm != null && gsm.isNotEmpty) {
      body['gsm'] = int.parse(gsm);
    }
    if (width != null && width.isNotEmpty) {
      body['width'] = int.parse(width);
    }

    return _source.exportDesign(body).guardFuture();
  }

  @override
  Future<Either<AppException, DesignItem>> getDesignById({
    required int designId,
  }) {
    return _source.getDesignById(sampleId: designId).guardFuture();
  }

  @override
  Future<Either<AppException, List<DesignItem>>> getDesignList({
    required int pageNumber,
    required int pageSize,
    required bool isStaff,
    String? searchString,
    int? hangerId,
    String? buyRefNo,
    String? count,
    String? composition,
    String? construction,
    String? millRefNo,
    String? gsm,
    String? width,
  }) {
    final Map<String, dynamic> body = {
      'page': pageNumber,
      'per_page': pageSize,
      'is_staff': isStaff,
    };
    if (searchString != null && searchString.isNotEmpty) {
      body['search_by'] = searchString;
    }
    if (hangerId != null) {
      body['hanger_id'] = hangerId;
    }
    if (buyRefNo != null && buyRefNo.isNotEmpty) {
      body['buyer_reference_construction'] = buyRefNo;
    }
    if (count != null && count.isNotEmpty) {
      body['count'] = count;
    }
    if (composition != null && composition.isNotEmpty) {
      body['composition'] = composition;
    }
    if (construction != null && construction.isNotEmpty) {
      body['construction'] = construction;
    }
    if (millRefNo != null && millRefNo.isNotEmpty) {
      body['mill_reference_number'] = millRefNo;
    }
    if (gsm != null && gsm.isNotEmpty) {
      body['gsm'] = int.parse(gsm);
    }
    if (width != null && width.isNotEmpty) {
      body['width'] = int.parse(width);
    }

    return _source.getDesignList(body).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> removeDesignImage({
    required int designId,
    required int documentId,
  }) {
    return _source
        .removeSampleImage(sampleId: designId, documentId: documentId)
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> updateDesign({
    required String? millRefNo,
    required String? buyerRefNo,
    required String? composition,
    required String? count,
    required String? width,
    required String? weight,
    required String? construction,
    required int? hangerId,
    required List<String> selectedImageLIst,
    required int designId,
  }) {
    final body = {};

    if (hangerId != null) {
      body['hanger_id'] = hangerId;
    }
    if (buyerRefNo != null && buyerRefNo.isNotEmpty) {
      body['buyer_reference_construction'] = buyerRefNo;
    }
    if (count != null && count.isNotEmpty) {
      body['count'] = count;
    }
    if (composition != null && composition.isNotEmpty) {
      body['composition'] = composition;
    }
    if (construction != null && construction.isNotEmpty) {
      body['construction'] = construction;
    }
    if (millRefNo != null && millRefNo.isNotEmpty) {
      body['mill_reference_number'] = millRefNo;
    }
    if (weight != null && weight.isNotEmpty) {
      body['gsm'] = int.parse(weight);
    }
    if (width != null && width.isNotEmpty) {
      body['width'] = int.parse(width);
    }

    return _source
        .updateDesign(
          sampleId: designId,
          fileList: selectedImageLIst.map((e) => File(e)).toList(),
          data: jsonEncode(body),
        )
        .guardFuture();
  }

  @override
  Future<Either<AppException, List<HangerDropdownModel>>> hangerDropdownList({
    required String onSearch,
    int? collectionId,
    required bool isStaff,
  }) {
    final body = {
      'search_by': onSearch,
      'per_page': 50,
      'page': 1,
      'is_staff': isStaff,
    };
    if (collectionId != null) {
      body['collection_id'] = collectionId;
    }
    return _source.getHangerDropdownList(body).guardFuture();
  }

  @override
  Future<Either<AppException, HomeStatsModel>> getHomeStats() {
    return _source.getHomeStats().guardFuture();
  }
}
