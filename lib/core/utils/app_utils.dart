// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/model/api_res.dart';
import '../../presentation/shared/components/app_text_theme.dart';
import '../../presentation/shared/gen/assets.gen.dart';
import '../../presentation/theme/config/app_color.dart';
import '../exceptions/app_exception.dart';
import '../extension/datetime.dart';
import '../extension/widget.dart';

class AppUtils {
  static Either<DioException, Object?> checkError(
    dynamic data,
    RequestOptions requestOptions,
  ) {
    if (data is List) {
      return right(data);
    }
    if (data is! Map<String, dynamic>) {
      return right(
        ApiRes(
          data: data,
        ).data,
      );
    }
    final apiRes = ApiRes.fromJson(data);
    // if (apiRes.error?.message?.isNotEmpty == true) {
    if (apiRes.error?.isNotEmpty == true) {
      return left(
        DioException(
          requestOptions: requestOptions,
          error: AppException(
            // message: apiRes.error?.message ?? '',
            message: apiRes.error ?? '',
            type: ErrorType.responseError,
          ),
        ),
      );
    }
    if (apiRes.data != null) {
      return right(apiRes.data);
    }
    return right(data);
  }

  static dynamic convertDataToMap(dynamic data) {
    final temp = <String, dynamic>{};
    if (data == null) {
      return temp;
    }
    if (data is String) {
      if (data.contains('{')) {
        return jsonDecode(data);
      }
      return temp..['data'] = data;
    }
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data')) {
        return data['data'];
      }
      temp.addAll(data);
    }
    if (temp.isEmpty) {
      return data;
    }
    return temp;
  }

  static Future<String> getFilePath({required String filename}) async {
    String path = '';
    final Directory directory = await getApplicationDocumentsDirectory();

    if (Platform.isAndroid) {
      // path = '/storage/emulated/0/Download';
      // // Create the Downloads directory if it doesn't exist
      // await Directory(path).create(recursive: true);
      path = p.join('/storage/emulated/0/Download', filename);
    } else {
      path = p.join(directory.path, filename);
    }
    return path;
  }

  static String timeDifference({required DateTime dateTime}) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} day ago';
    }
    return dateTime.toDDMMYY();
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> flushBar(
    BuildContext contextt,
    String message, {
    bool isSuccessPopup = true,
  }) {
    return ScaffoldMessenger.of(contextt).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        content: Container(
          decoration: BoxDecoration(
            color: isSuccessPopup ? AppColor.green : AppColor.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (isSuccessPopup)
                Assets.svg.correctIcon.svg(height: 50, width: 50).padHor()
              else
                Assets.svg.incorrectIcon.svg(height: 60, width: 60).padHor(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isSuccessPopup ? 'Success' : 'Error',
                      style: AppTextTheme.semiBold16
                          .copyWith(color: AppColor.white),
                    ),
                    Text(
                      message,
                      style:
                          AppTextTheme.label14.copyWith(color: AppColor.white),
                    ).padRight(),
                  ],
                ),
              ),
            ],
          ).padVer(10),
        ),
      ),
    );
  }
}
