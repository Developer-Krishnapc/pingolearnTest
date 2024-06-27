import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/collection_dropdown_model.dart';
import '../../data/model/common_success_model.dart';
import '../model/hanger_model.dart';

abstract class HangerRepository {
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
  });
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
  });
  Future<Either<AppException, HangerItem>> getHangerById({
    required int hangerId,
  });

  Future<Either<AppException, List<CollectionDropdownModel>>>
      collectionDropdownList({
    required bool isStaff,
  });
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
  });

  Future<Either<AppException, CommonSuccessModel>> removeHangerImage({
    required int hangerId,
    required int documentId,
  });
  Future<Either<AppException, CommonSuccessModel>> deleteHanger({
    required int hangerId,
  });

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
  });

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
  });
}
