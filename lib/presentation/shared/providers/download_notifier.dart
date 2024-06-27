import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../../core/providers/token_provider.dart';
import '../../../data/helper/log_interceptor.dart';

part 'download_notifier.g.dart';

@riverpod
class DownloadNotifier extends _$DownloadNotifier {
  @override
  (bool, double) build() {
    return (false, 0);
  }

  Future<void> startDownload({
    required String url,
    required BuildContext context,
    required Map<String, dynamic> body,
    required String fileName,
  }) async {
    if (await checkAndRequestStoragePermission() == true) {
      final token = ref.read(tokenNotifierProvider);

      final dir = await getApplicationDocumentsDirectory();
      final downloadPath = '${dir.path}/url.pdf';

      final dio = Dio(
        BaseOptions(
          baseUrl: Constants.instance.baseUrl,
          contentType: 'application/json',
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      )..interceptors.add(LogInterceptorsWrapper());

      final data = await dio.post(
        url,
        data: {},
        onReceiveProgress: (received, total) {},
      );
      attemptSaveFile('krishna2.xlsx', data.data);
    }
  }

  Future<bool> checkAndRequestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    final plugin = DeviceInfoPlugin();

    if (!status.isGranted) {
      if (Platform.isAndroid) {
        final android = await plugin.androidInfo;
        status = android.version.sdkInt < 33
            ? await Permission.storage.request()
            : await Permission.manageExternalStorage.request();
      } else {
        await Permission.storage.request();
      }
    }

    return status.isGranted;
  }

  Future<void> attemptSaveFile(String filename, List<int> bytes) async {
    final bool hasPermission = await checkAndRequestStoragePermission();
    if (hasPermission) {
      try {
        await saveFileLocally(filename, bytes);
        print('File download and save completed.');
      } catch (e) {
        print('An error occurred while saving the file: $e');
      }
    } else {
      print('Storage permission not granted. Cannot save the file.');
    }
  }

  Future<void> saveFileLocally(String filename, List<int> bytes) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = p.join(directory.path, filename);
    final File file = File(path);
    await file.writeAsBytes(bytes);
    print('File saved at $path');
  }
}
