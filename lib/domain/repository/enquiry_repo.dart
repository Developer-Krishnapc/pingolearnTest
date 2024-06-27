import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/common_success_model.dart';
import '../../data/model/create_enquiry_item_res.dart';
import '../../data/model/enquiry_item_body_model.dart';
import '../model/enquiry_model.dart';
import '../model/enquiry_stats_model.dart';
import '../model/predefined.dart';

abstract class EnquiryRepository {
  Future<Either<AppException, List<EnquiryItem>>> getEnquiryList({
    required int pageNumber,
    required int pageSize,
    int? statusId,
    String? name,
    String? location,
  });

  Future<Either<AppException, List<EnquiryItem>>> getEnquiryItemList({
    required int enquiryId,
  });

  Future<Either<AppException, List<Predefined>>> getPredefinedList({
    required String entityType,
  });

  Future<Either<AppException, AddEnquiryItemRes>> createEnquiryItem({
    required int enquiryId,
    required List<EnquiryBodyModel> hangerList,
    required List<EnquiryBodyModel> designList,
  });
  Future<Either<AppException, CommonSuccessModel>> addEnquiry({
    required String userName,
    required String phone,
    required String location,
    required String email,
    required String description,
    required int statusId,
    required List<EnquiryBodyModel> designIds,
    required List<EnquiryBodyModel> hangerIds,
  });

  Future<Either<AppException, CommonSuccessModel>> updateEnquiry({
    int? statusId,
    String? userName,
    String? phone,
    String? location,
    String? emailId,
    String? description,
    required int enquiryId,
    required List<EnquiryBodyModel> hangerList,
    required List<EnquiryBodyModel> designList,
  });
  Future<Either<AppException, EnquiryStatsModel>> enquiryStats();
  Future<Either<AppException, CommonSuccessModel>> updateEnquiryItemStatus({
    required int statusId,
    required int enquiryItemId,
  });

  Future<Either<AppException, List<int>>> exportEnquiry({
    String? searchString,
    int? statusId,
    String? location,
    int? enquiryId,
  });

  Future<Either<AppException, CommonSuccessModel>> deleteEnquiryItem({
    required int enquiryItemId,
  });
  Future<Either<AppException, CommonSuccessModel>> deleteEnquiry({
    required int enquiryId,
  });
  Future<Either<AppException, List<int>>> exportEnquiryPdf({
    required int enquiryId,
  });
}
