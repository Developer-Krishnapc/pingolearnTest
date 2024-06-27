import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../domain/model/enquiry_model.dart';
import '../../domain/model/enquiry_stats_model.dart';
import '../../domain/model/predefined.dart';
import '../../domain/repository/enquiry_repo.dart';
import '../model/common_success_model.dart';
import '../model/create_enquiry_item_res.dart';
import '../model/enquiry_item_body_model.dart';
import '../source/remote/enquiry_souce.dart';

part 'enquiry_repo_impl.g.dart';

@riverpod
EnquiryRepository enquiryRepo(EnquiryRepoRef ref) =>
    EnquiryRepositoryImpl(ref.read(enquirySourceProvider));

class EnquiryRepositoryImpl implements EnquiryRepository {
  EnquiryRepositoryImpl(this._source);

  final EnquirySource _source;

  @override
  Future<Either<AppException, CommonSuccessModel>> addEnquiry({
    required String userName,
    required String phone,
    required String location,
    required String email,
    required String description,
    required int statusId,
    required List<EnquiryBodyModel> designIds,
    required List<EnquiryBodyModel> hangerIds,
  }) {
    final Map<String, dynamic> body = {
      'name': userName,
      'mobile_no': phone,
      'email': email,
      'location': location,
      'description': description,
      'status_id': statusId,
      'sample_ids': List.generate(
        designIds.length,
        (index) => designIds[index].toJson(),
      ),
      'hanger_ids': List.generate(
        hangerIds.length,
        (index) => hangerIds[index].toJson(),
      ),
    };
    return _source.addEnquiry(body: body).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> deleteEnquiry({
    required int enquiryId,
  }) {
    return _source.deleteEnquiry(enquiryId: enquiryId).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> deleteEnquiryItem({
    required int enquiryItemId,
  }) {
    return _source
        .deleteEnquiryItem(enquiryItemId: enquiryItemId)
        .guardFuture();
  }

  @override
  Future<Either<AppException, List<EnquiryItem>>> getEnquiryItemList({
    required int enquiryId,
  }) {
    return _source.getEnquiryItemList(enquiryId).guardFuture();
  }

  @override
  Future<Either<AppException, List<EnquiryItem>>> getEnquiryList({
    required int pageNumber,
    required int pageSize,
    int? statusId,
    String? name,
    String? location,
  }) {
    final Map<String, dynamic> body = {
      'page': pageNumber,
      'per_page': pageSize,
    };
    if (name != null && name.isNotEmpty) {
      body['name'] = name;
    }
    if (statusId != null) {
      body['status_id'] = statusId;
    }
    if (location != null && location.isNotEmpty) {
      body['location'] = location;
    }
    return _source.getEnquiryList(body).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> updateEnquiryItemStatus({
    required int statusId,
    required int enquiryItemId,
  }) {
    final body = {
      'status_id': statusId,
    };
    return _source
        .updateEnquiryItemStatus(enquiryItemId: enquiryItemId, body: body)
        .guardFuture();
  }

  @override
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
  }) {
    final Map<String, dynamic> body = {
      'sample_ids': List.generate(
        designList.length,
        (index) => designList[index].toJson(),
      ),
      'hanger_ids': List.generate(
        hangerList.length,
        (index) => hangerList[index].toJson(),
      ),
    };
    if (statusId != null) {
      body['status_id'] = statusId;
    }

    if (userName != null && userName.trim().isNotEmpty) {
      body['name'] = userName;
    }
    if (phone != null && phone.trim().isNotEmpty) {
      body['mobile_no'] = phone;
    }
    if (emailId != null && emailId.trim().isNotEmpty) {
      body['email'] = emailId;
    }
    if (location != null && location.trim().isNotEmpty) {
      body['location'] = location;
    }
    if (description != null && description.trim().isNotEmpty) {
      body['description'] = description;
    }

    return _source
        .updateEnquiry(enquiryId: enquiryId, body: body)
        .guardFuture();
  }

  @override
  Future<Either<AppException, List<Predefined>>> getPredefinedList({
    required String entityType,
  }) {
    final body = {
      'entity_type': entityType,
    };
    return _source.getPredefinedList(body).guardFuture();
  }

  @override
  Future<Either<AppException, AddEnquiryItemRes>> createEnquiryItem({
    required int enquiryId,
    required List<EnquiryBodyModel> hangerList,
    required List<EnquiryBodyModel> designList,
  }) {
    final body = {
      'sample_ids': List.generate(
        designList.length,
        (index) => designList[index].toJson(),
      ),
      'hanger_ids': List.generate(
        hangerList.length,
        (index) => hangerList[index].toJson(),
      ),
    };
    return _source.createEnquiryItem(body, enquiryId).guardFuture();
  }

  @override
  Future<Either<AppException, EnquiryStatsModel>> enquiryStats() {
    return _source.getEnquiryStats().guardFuture();
  }

  @override
  Future<Either<AppException, List<int>>> exportEnquiry({
    String? searchString,
    int? statusId,
    String? location,
    int? enquiryId,
  }) {
    final Map<String, dynamic> body = {
      'page': 1,
      'per_page': 250000,
    };
    if (enquiryId != null) {
      body['enquiry_id'] = enquiryId;
    } else {
      if (searchString != null && searchString.isNotEmpty) {
        body['name'] = searchString;
      }
      if (statusId != null) {
        body['status_id'] = statusId;
      }
      if (location != null && location.isNotEmpty) {
        body['location'] = location;
      }
    }

    return _source.exportEnquiry(body).guardFuture();
  }

  @override
  Future<Either<AppException, List<int>>> exportEnquiryPdf({
    required int enquiryId,
  }) {
    final body = {
      'enquiry_id': enquiryId,
    };

    return _source.exportEnquiryPDF(body).guardFuture();
  }
}
