import 'dart:io';

import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/model/design_model.dart';
import '../../../domain/model/home_stats_model.dart';
import '../../helper/dio_instance.dart';
import '../../model/common_success_model.dart';
import '../../model/hanger_dropdown_model.dart';

part 'design_source.g.dart';

@riverpod
DesignSource designSource(DesignSourceRef ref) {
  return DesignSource(ref.watch(dioInstanceProvider));
}

@RestApi()
abstract class DesignSource {
  factory DesignSource(Dio _dio) => _DesignSource(_dio);
  @POST(Constants.designList)
  Future<List<DesignItem>> getDesignList(
    @Body() Map<String, dynamic> body,
  );

  @MultiPart()
  @POST(Constants.addDesign)
  Future<CommonSuccessModel> addDesign({
    @Part(contentType: 'image/jpeg', name: 'images')
    required List<File> fileList,
    @Part(name: 'data') required String data,
  });

  @GET(Constants.designById)
  Future<DesignItem> getDesignById({
    @Path() required int sampleId,
  });

  @GET(Constants.homeStats)
  Future<HomeStatsModel> getHomeStats();

  @POST(Constants.hangerDropdownList)
  Future<List<HangerDropdownModel>> getHangerDropdownList(
    @Body() Map<String,dynamic> body,
  );

  @MultiPart()
  @PUT(Constants.updateDesign)
  Future<CommonSuccessModel> updateDesign({
    @Part(contentType: 'image/jpeg', name: 'images')
    required List<File> fileList,
    @Part() required String data,
    @Path() required int sampleId,
  });

  @POST(Constants.exportDesign)
  Future<dynamic> exportDesign(
    @Body() Map<String, dynamic> body,
  );

  @DELETE(Constants.removeDesignImage)
  Future<CommonSuccessModel> removeSampleImage({
    @Path() required int sampleId,
    @Path() required int documentId,
  });

  @DELETE(Constants.deleteDesign)
  Future<CommonSuccessModel> deleteSample({
    @Path() required int sampleId,
  });
}
