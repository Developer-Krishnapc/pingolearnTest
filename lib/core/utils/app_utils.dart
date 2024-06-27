// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/model/api_res.dart';
import '../../data/model/qr_output_model.dart';
import '../../presentation/profile/providers/user_notifier.dart';
import '../../presentation/shared/components/app_loader.dart';
import '../../presentation/shared/components/app_text_theme.dart';
import '../../presentation/shared/gen/assets.gen.dart';
import '../../presentation/shared/providers/last_file_save_provider.dart';
import '../../presentation/theme/config/app_color.dart';
import '../constants/entity_type.dart';
import '../exceptions/app_exception.dart';
import '../extension/log.dart';
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

  static Future<bool> checkAndRequestStoragePermission() async {
    if (Platform.isAndroid) {
      const bool isPermissionEnabled = true;
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final release = deviceInfo.version.sdkInt;

      PermissionStatus status = await Permission.storage.status;
      if (release <= 29 && status != PermissionStatus.granted) {
        status = await Permission.storage.request();
        return status == PermissionStatus.granted ||
            status == PermissionStatus.limited;
      }

      return isPermissionEnabled;
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
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

  static Future<String?> saveFileLocally(
    String filename,
    List<int> bytes,
    Ref ref,
  ) async {
    String? response;
    try {
      String path = '';
      final Directory directory = await getApplicationDocumentsDirectory();
      const androidDir = '/storage/emulated/0/Download';
      final iosDir = directory.path;
      final random = Random();
      const min = 1000; // Minimum 4-digit number
      const max = 9999; // Maximum 4-digit number
      final randomNumber = min + random.nextInt(max - min);

      if (Platform.isAndroid) {
        // path = '/storage/emulated/0/Download';
        // // Create the Downloads directory if it doesn't exist
        // await Directory(path).create(recursive: true);
        path = p.join('/storage/emulated/0/Download', '$randomNumber$filename');
      } else {
        path = p.join(directory.path, '$randomNumber$filename');
      }

      // Check if the file exists
      bool fileExists = await File(path).exists();

      // If file exists, find a unique name by adding a number
      int count = 1;
      String newFileName;
      do {
        newFileName = '$randomNumber-$count-$filename';
        path = p.join((Platform.isAndroid) ? androidDir : iosDir, newFileName);
        fileExists = await File(path).exists();
        count++;
      } while (fileExists);

      path.logError();

      final File file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      print('File saved at $path');

      ref.read(lastFileSaveProvider.notifier).state = path;
    } catch (e) {
      response = 'Something went wrong';
    }

    return response;
  }

  static void openDefaultFileManager() {
    openFileManager();
  }

  static QROutputModel? validateQROutput({required dynamic data}) {
    try {
      final decodedString = jsonDecode(data ?? '{}');

      if (decodedString
          case {'id': final int id, 'moduleType': final String moduleType}) {
        if (moduleType == EntityType.designModule ||
            moduleType == EntityType.hangerModule) {
          return QROutputModel(id: id, moduleType: moduleType);
        }
      }
    } catch (e) {
      'exception $e'.logError();
      return null;
    }

    return null;
  }

  static Future<bool> attemptSaveFile(
    String filename,
    List<int> bytes,
    Ref ref,
  ) async {
    bool response = false;
    final bool hasPermission = await checkAndRequestStoragePermission();
    if (hasPermission) {
      try {
        response = true;
        final data = await saveFileLocally(filename, bytes, ref);
        if (data != null) {
          return false;
        }
        print('File download and save completed.');
      } catch (e) {
        print('An error occurred while saving the file: $e');
      }
    } else {
      print('Storage permission not granted. Cannot save the file.');
    }
    return response;
  }

  static showDownloadingWidget({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          // shadowColor: AppColor.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(15),
          ),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,

          child: Container(
            height: 100,
            width: 150,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x1C000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            // color: AppColor.white,

            margin: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: const Row(
              children: [
                Text('Downloading'),
                Gap(20),
                AppLoader(),
              ],
            ),
          ),
        );
      },
    );
  }

  static String getFileName(String? filePath) {
    if (filePath == null || filePath == '') {
      return '';
    }
    final data = filePath.split('/');
    return data[data.length - 1];
  }

  static String getExtension(String? filePath) {
    if (filePath == null || filePath == '') {
      return '';
    }
    final data = filePath.split('/');
    final file = data[data.length - 1];
    final newData = file.split('.');
    return newData[newData.length - 1];
  }

  static bool isAccessAllowed({
    required String moduleType,
    required String accessType,
    required WidgetRef ref,
  }) {
    bool hasAccess = false;
    final userAccess =
        ref.read(userNotifierProvider.select((value) => value.data.access));

    switch (moduleType) {
      case EntityType.collectionModule:
        {
          final collectionAccess = userAccess.collection;
          switch (accessType) {
            case EntityType.read:
              {
                hasAccess = collectionAccess?.read ?? false;
              }
            case EntityType.create:
              {
                hasAccess = collectionAccess?.create ?? false;
              }
            case EntityType.update:
              {
                hasAccess = collectionAccess?.update ?? false;
              }
            case EntityType.delete:
              {
                hasAccess = collectionAccess?.delete ?? false;
              }
          }
        }

      case EntityType.hangerModule:
        {
          final hangerAccess = userAccess.hanger;
          switch (accessType) {
            case EntityType.read:
              {
                hasAccess = hangerAccess?.read ?? false;
              }
            case EntityType.create:
              {
                hasAccess = hangerAccess?.create ?? false;
              }
            case EntityType.update:
              {
                hasAccess = hangerAccess?.update ?? false;
              }
            case EntityType.delete:
              {
                hasAccess = hangerAccess?.delete ?? false;
              }
          }
        }

      case EntityType.designModule:
        {
          final designAccess = userAccess.design;
          switch (accessType) {
            case EntityType.read:
              {
                hasAccess = designAccess?.read ?? false;
              }
            case EntityType.create:
              {
                hasAccess = designAccess?.create ?? false;
              }
            case EntityType.update:
              {
                hasAccess = designAccess?.update ?? false;
              }
            case EntityType.delete:
              {
                hasAccess = designAccess?.delete ?? false;
              }
          }
        }

      case EntityType.enquiryModule:
        {
          final enquiryAccess = userAccess.enquiry;
          switch (accessType) {
            case EntityType.read:
              {
                hasAccess = enquiryAccess?.read ?? false;
              }
            case EntityType.create:
              {
                hasAccess = enquiryAccess?.create ?? false;
              }
            case EntityType.update:
              {
                hasAccess = enquiryAccess?.update ?? false;
              }
            case EntityType.delete:
              {
                hasAccess = enquiryAccess?.delete ?? false;
              }
          }
        }
      case EntityType.userModule:
        {
          final userDomailAccess = userAccess.user;
          switch (accessType) {
            case EntityType.read:
              {
                hasAccess = userDomailAccess?.read ?? false;
              }
            case EntityType.create:
              {
                hasAccess = userDomailAccess?.create ?? false;
              }
            case EntityType.update:
              {
                hasAccess = userDomailAccess?.update ?? false;
              }
            case EntityType.delete:
              {
                hasAccess = userDomailAccess?.delete ?? false;
              }
          }
        }
    }
    return hasAccess;
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    BuildContext contextt,
    String title,
    String message, {
    Color color = AppColor.primary,
  }) {
    return ScaffoldMessenger.of(contextt).showSnackBar(
      SnackBar(
        backgroundColor: color,
        margin: const EdgeInsets.all(8.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextTheme.semiBold14,
            ),
            Text(
              message,
              style: AppTextTheme.label12,
            ).padAll(10),
          ],
        ),
      ),
    );
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

  static Future<void> launchUrlExternal(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  static Future<void> lauchStore({
    required String playStoreAppId,
    required String iosId,
  }) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? playStoreAppId : iosId;
      final url = Uri.parse(
        Platform.isAndroid
            ? 'https://play.google.com/store/apps/details?id=$appId'
            : 'https://apps.apple.com/app/id$appId',
      );

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
