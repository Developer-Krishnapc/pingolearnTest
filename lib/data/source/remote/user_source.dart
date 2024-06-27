import 'dart:io';

import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/model/role_model.dart';
import '../../../domain/model/user.dart';
import '../../helper/dio_instance.dart';
import '../../model/common_success_model.dart';

part 'user_source.g.dart';

@riverpod
UserSource userSource(UserSourceRef ref) =>
    UserSource(ref.watch(dioInstanceProvider));

@RestApi()
abstract class UserSource {
  factory UserSource(Dio _dio) => _UserSource(_dio);

  @GET(Constants.getUserById)
  Future<User> getUserById(@Path() int id);
  @POST(Constants.getUser)
  Future<User> getUser(@Body() Map<String, dynamic> body);

  @PUT(Constants.updateUserById)
  Future<CommonSuccessModel> updateUserById({
    @Path() required int userId,
    @Body() required Map<String, dynamic> body,
  });

  @MultiPart()
  @POST(Constants.createUser)
  Future<CommonSuccessModel> createUser({
    @Part(name: 'data') required String data,
    @Part(contentType: 'image/jpeg', name: 'image') File? fileData,
  });

  @POST(Constants.userList)
  Future<List<User>> userList({
    @Body() required Map<String, dynamic> body,
  });

  @GET(Constants.roleList)
  Future<List<RoleModel>> getRoleList();

  @MultiPart()
  @PUT(Constants.updateUserProfileImageById)
  Future<CommonSuccessModel> updateProfileImg({
    @Part(contentType: 'image/jpeg', name: 'file') required File fileData,
    @Path() required int userId,
  });
}
