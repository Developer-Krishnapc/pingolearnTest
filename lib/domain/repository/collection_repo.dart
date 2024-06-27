import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/common_success_model.dart';
import '../model/collection_model.dart';

abstract class CollectionRepository {
  Future<Either<AppException, List<CollectionItem>>> getCollectionList(
    int pageNumber,
    int pageSize,
    String searchString,
    bool isStaff,
  );
  Future<Either<AppException, CommonSuccessModel>> addCollection({
    required String collectionName,
    required List<String> selectedImageLIst,
  });
  Future<Either<AppException, CommonSuccessModel>> updateCollection({
    required String collectionName,
    required List<String> selectedImageLIst,
    required int collectionId,
  });

  Future<Either<AppException, CommonSuccessModel>> removeCollection({
    required int collectionId,
    required int documentId,
  });
  Future<Either<AppException, CommonSuccessModel>> toggleCollectionStatus({
    required int collectionId,
  });
}
