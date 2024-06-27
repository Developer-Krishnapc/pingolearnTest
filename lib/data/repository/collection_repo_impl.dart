import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../domain/model/collection_model.dart';
import '../../domain/repository/collection_repo.dart';
import '../model/common_success_model.dart';
import '../source/remote/collection_source.dart';

part 'collection_repo_impl.g.dart';

@riverpod
CollectionRepository collectionRepo(CollectionRepoRef ref) =>
    CollectionRepositoryImpl(ref.read(collectionSourceProvider));

class CollectionRepositoryImpl implements CollectionRepository {
  CollectionRepositoryImpl(this._source);

  final CollectionSource _source;

  @override
  Future<Either<AppException, List<CollectionItem>>> getCollectionList(
    int pageNumber,
    int pageSize,
    String searchString,
    bool isStaff,
  ) {
    {
      final body = {
        'page': pageNumber,
        'per_page': pageSize,
        'search_by': searchString,
        'is_staff': isStaff,
      };

      return _source.getCollectionList(body).guardFuture();
    }
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> addCollection({
    required String collectionName,
    required List<String> selectedImageLIst,
  }) {
    final fileList = selectedImageLIst.map((e) => File(e)).toList();
    return _source
        .addCollection(fileList: fileList, name: collectionName)
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> updateCollection({
    required String collectionName,
    required List<String> selectedImageLIst,
    required int collectionId,
  }) {
    final fileList = selectedImageLIst.map((e) => File(e)).toList();
    return _source
        .updateCollection(
          fileList: fileList,
          name: collectionName,
          collectionId: collectionId,
        )
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> removeCollection({
    required int collectionId,
    required int documentId,
  }) async {
    return _source
        .removeCollectionImage(
          collectionId: collectionId,
          documentId: documentId,
        )
        .guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> toggleCollectionStatus({
    required int collectionId,
  }) {
    return _source
        .toggleCollectionStatus(collectionId: collectionId)
        .guardFuture();
  }
}
