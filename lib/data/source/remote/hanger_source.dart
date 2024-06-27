import 'dart:io';

import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/model/hanger_model.dart';
import '../../helper/dio_instance.dart';
import '../../model/collection_dropdown_model.dart';
import '../../model/common_success_model.dart';

part 'hanger_source.g.dart';

@riverpod
HangerSource hangerSource(HangerSourceRef ref) {
  return HangerSource(ref.watch(dioInstanceProvider));
}

@RestApi()
abstract class HangerSource {
  factory HangerSource(Dio _dio) => _HangerSource(_dio);
  @POST(Constants.hangerList)
  Future<List<HangerItem>> getHangerList(
    @Body() Map<String, dynamic> body,
  );

  @MultiPart()
  @POST(Constants.addHanger)
  Future<CommonSuccessModel> addHanger({
    @Part(contentType: 'image/jpeg', name: 'images')
    required List<File> fileList,
    @Part(name: 'data') required String data,
  });

  @GET(Constants.hangerById)
  Future<HangerItem> getHangerById({
    @Path() required int hangerId,
  });

  @MultiPart()
  @PUT(Constants.updateHanger)
  Future<CommonSuccessModel> updateHanger({
    @Part(contentType: 'image/jpeg', name: 'images')
    required List<File> fileList,
    @Part() required String data,
    @Path() required int hangerId,
  });

  @POST(Constants.exportHanger)
  Future<List<int>> exportHanger(
    @Body() Map<String, dynamic> body,
  );

  @GET(Constants.collectionDropdownList)
  Future<List<CollectionDropdownModel>> getcollectionDropdownList({
    @Path() required bool isStaff,
  });

  @DELETE(Constants.removeHangerImage)
  Future<CommonSuccessModel> removeHangerImage({
    @Path() required int hangerId,
    @Path() required int documentId,
  });

  @DELETE(Constants.deleteHanger)
  Future<CommonSuccessModel> deleteHanger({
    @Path() required int hangerId,
  });

  @POST(Constants.exportHangerPDF)
  Future<List<int>> exportHangerPDF(
    @Body() Map<String, dynamic> body,
  );
}
