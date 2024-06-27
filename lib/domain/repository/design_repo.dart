import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/common_success_model.dart';
import '../../data/model/hanger_dropdown_model.dart';
import '../model/design_model.dart';
import '../model/home_stats_model.dart';

abstract class DesignRepository {
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
  });
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
  });
  Future<Either<AppException, DesignItem>> getDesignById({
    required int designId,
  });

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
  });

  Future<Either<AppException, CommonSuccessModel>> removeDesignImage({
    required int designId,
    required int documentId,
  });
  Future<Either<AppException, CommonSuccessModel>> deleteDesign({
    required int designId,
  });

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
  });

  Future<Either<AppException, List<HangerDropdownModel>>> hangerDropdownList({
    required String onSearch,
    int? collectionId,
    required bool isStaff,
  });
  Future<Either<AppException, HomeStatsModel>> getHomeStats();
}
