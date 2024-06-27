import 'dart:io';

import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/model/collection_model.dart';
import '../../helper/dio_instance.dart';
import '../../model/common_success_model.dart';

part 'collection_source.g.dart';

@riverpod
CollectionSource collectionSource(CollectionSourceRef ref) {
  return CollectionSource(ref.watch(dioInstanceProvider));
}

@RestApi()
abstract class CollectionSource {
  factory CollectionSource(Dio _dio) => _CollectionSource(_dio);
  @POST(Constants.collectionList)
  Future<List<CollectionItem>> getCollectionList(
    @Body() Map<String, dynamic> body,
  );

  @MultiPart()
  @POST(Constants.addCollection)
  Future<CommonSuccessModel> addCollection({
    @Part(contentType: 'image/jpeg', name: 'images')
    required List<File> fileList,
    @Part() required String name,
  });
  @GET(Constants.updateCollectionStatus)
  Future<CommonSuccessModel> toggleCollectionStatus({
    @Path() required int collectionId,
  });

  @MultiPart()
  @PUT(Constants.updateCollection)
  Future<CommonSuccessModel> updateCollection({
    @Part(contentType: 'image/jpeg', name: 'images')
    required List<File> fileList,
    @Part() required String name,
    @Path() required int collectionId,
  });

  @DELETE(Constants.removeCollectionImage)
  Future<CommonSuccessModel> removeCollectionImage({
    @Path() required int collectionId,
    @Path() required int documentId,
  });
}
