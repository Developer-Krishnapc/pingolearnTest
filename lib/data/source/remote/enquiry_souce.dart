import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/model/enquiry_model.dart';
import '../../../domain/model/enquiry_stats_model.dart';
import '../../../domain/model/predefined.dart';
import '../../helper/dio_instance.dart';
import '../../model/common_success_model.dart';
import '../../model/create_enquiry_item_res.dart';

part 'enquiry_souce.g.dart';

@riverpod
EnquirySource enquirySource(EnquirySourceRef ref) {
  return EnquirySource(ref.watch(dioInstanceProvider));
}

@RestApi()
abstract class EnquirySource {
  factory EnquirySource(Dio _dio) => _EnquirySource(_dio);
  @POST(Constants.enquiryList)
  Future<List<EnquiryItem>> getEnquiryList(
    @Body() Map<String, dynamic> body,
  );

  @GET(Constants.enquiryStats)
  Future<EnquiryStatsModel> getEnquiryStats();

  @POST(Constants.addEnquiryItem)
  Future<AddEnquiryItemRes> createEnquiryItem(
    @Body() Map<String, dynamic> body,
    @Path() int enquiryId,
  );

  @POST(Constants.predefinedList)
  Future<List<Predefined>> getPredefinedList(
    @Body() Map<String, dynamic> body,
  );

  @POST(Constants.exportEnquiry)
  Future<List<int>> exportEnquiry(
    @Body() Map<String, dynamic> body,
  );

  @POST(Constants.enquiryItemList)
  Future<List<EnquiryItem>> getEnquiryItemList(
    @Path() int enquiryId,
  );

  @POST(Constants.addEnquiry)
  Future<CommonSuccessModel> addEnquiry({
    @Body() required Map<String, dynamic> body,
  });

  @PUT(Constants.updateEnquiryStatus)
  Future<CommonSuccessModel> updateEnquiry({
    @Path() required int enquiryId,
    @Body() required Map<String, dynamic> body,
  });

  @PUT(Constants.updateEnquiryItemStatus)
  Future<CommonSuccessModel> updateEnquiryItemStatus({
    @Path() required int enquiryItemId,
    @Body() required Map<String, dynamic> body,
  });

  @DELETE(Constants.deleteEnquiryItem)
  Future<CommonSuccessModel> deleteEnquiryItem({
    @Path() required int enquiryItemId,
  });

  @DELETE(Constants.deleteEnquiry)
  Future<CommonSuccessModel> deleteEnquiry({
    @Path() required int enquiryId,
  });

  @POST(Constants.exportHangerPDF)
  Future<List<int>> exportEnquiryPDF(
    @Body() Map<String, dynamic> body,
  );
}
