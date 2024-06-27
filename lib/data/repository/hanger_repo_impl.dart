import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../domain/model/hanger_model.dart';
import '../../domain/repository/hanger_repo.dart';
import '../model/collection_dropdown_model.dart';
import '../model/common_success_model.dart';
import '../source/remote/hanger_source.dart';

part 'hanger_repo_impl.g.dart';

@riverpod
HangerRepository hangerRepo(HangerRepoRef ref) =>
    HangerRepositoryImpl(ref.read(hangerSourceProvider));

class HangerRepositoryImpl implements HangerRepository {
  HangerRepositoryImpl(this._source);

  final HangerSource _source;

  @override
  Future<Either<AppException, List<HangerItem>>> getHangerList({
    required int pageNumber,
    required int pageSize,
    required bool isStaff,
    String? searchString,
    int? collectionId,
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
    if (searchString != null) {
      body['search_by'] = searchString;
    }
    if (collectionId != null) {
      body['collection_id'] = collectionId;
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

    return _source.getHangerList(body).guardFuture();
  }

  @override
  Future<Either<AppException, HangerItem>> getHangerById({
    required int hangerId,
  }) {
    return _source.getHangerById(hangerId: hangerId).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> addHanger({
    required String hangerName,
    required String millRefNo,
    String? buyerRefNo,
    String? composition,
    String? count,
    int? width,
    int? weight,
    String? construction,
    String? hangerCode,
    required int collectionId,
    required List<String> selectedImageLIst,
  }) {
    final body = {
      'name': hangerName,
      'code': hangerCode,
      'mill_reference_number': millRefNo,
      'count': count,
      'collection_id': collectionId,
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
        .addHanger(
          fileList: selectedImageLIst.map((e) => File(e)).toList(),
          data: jsonEncode(body),
        )
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> removeHangerImage({
    required int hangerId,
    required int documentId,
  }) {
    return _source
        .removeHangerImage(hangerId: hangerId, documentId: documentId)
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> updateHanger({
    required String? hangerName,
    required String? millRefNo,
    required String? buyerRefNo,
    required String? composition,
    required String? count,
    required String? width,
    required String? weight,
    required String? construction,
    required String? hangerCode,
    required int? collectionId,
    required List<String> selectedImageLIst,
    required int hangerId,
  }) {
    final body = {};
    if (hangerName != null && hangerName.isNotEmpty) {
      body['name'] = hangerName;
    }
    if (hangerCode != null && hangerCode.isNotEmpty) {
      body['code'] = hangerCode;
    }
    if (collectionId != null) {
      body['collection_id'] = collectionId;
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
        .updateHanger(
          hangerId: hangerId,
          fileList: selectedImageLIst.map((e) => File(e)).toList(),
          data: jsonEncode(body),
        )
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> deleteHanger({
    required int hangerId,
  }) {
    return _source.deleteHanger(hangerId: hangerId).guardFuture();
  }

  @override
  Future<Either<AppException, List<int>>> exportHanger({
    String? searchString,
    int? collectionId,
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
    if (collectionId != null) {
      body['collection_id'] = collectionId;
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

    return _source.exportHanger(body).guardFuture();
  }

  @override
  Future<Either<AppException, List<CollectionDropdownModel>>>
      collectionDropdownList({
    required bool isStaff,
  }) {
    return _source.getcollectionDropdownList(isStaff: isStaff).guardFuture();
  }

  @override
  Future<Either<AppException, List<int>>> exportHangerPDF({
    String? searchString,
    int? collectionId,
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
    if (hangerId != null) {
      body['hanger_id'] = hangerId;
    }
    if (searchString != null && searchString.isNotEmpty) {
      body['search_by'] = searchString;
    }
    if (collectionId != null) {
      body['collection_id'] = collectionId;
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

    return _source.exportHangerPDF(body).guardFuture();
  }
}
