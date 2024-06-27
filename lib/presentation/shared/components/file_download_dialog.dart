import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/providers/token_provider.dart';
import '../../../core/utils/app_utils.dart';
import '../../shared/components/app_text_theme.dart';
import '../../theme/config/app_color.dart';

class FileDownloadDialog extends ConsumerStatefulWidget {
  const FileDownloadDialog({
    super.key,
    required this.url,
  });

  /// [url] is the url of the file to be downloaded
  final String url;

  @override
  ConsumerState<FileDownloadDialog> createState() => _FileDownloadDialogState();
}

class _FileDownloadDialogState extends ConsumerState<FileDownloadDialog> {
  /// [_port] is used to communicate with the isolates.
  final ReceivePort _port = ReceivePort();

  /// [downloadTaskId] variable is used to store the id of the download task created when the [FlutterDownloader.enqueue] method is called.
  String? downloadTaskId;

  /// [downloadTaskStatus] is used to store the task status.
  int downloadTaskStatus = 0;

  /// [downloadTaskProgress] store the progress of the download task. ranging between 1 to 100.
  int downloadTaskProgress = 0;

  /// [isDownloading] is set to true if the file is being downloaded.
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();

    initDownloadController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      downloadFile(url: widget.url);
    });
  }

  @override
  void dispose() {
    disposeDownloadController();
    super.dispose();
  }

  /// [initDownloadController] method will initialize the downloader controller and perform certain operations like registering the port, initializing the register callback etc.
  initDownloadController() {
    log('DownloadsController - initDownloadController called');
    _bindBackgroundIsolate();
  }

  /// [disposeDownloadController] is used to unbind the isolates and dispose the controller
  disposeDownloadController() {
    _unbindBackgroundIsolate();
  }

  /// [_bindBackgroundIsolate] is used to register the [SendPort] with the name [downloader_send_port].
  /// If the registration is successful then it will return true else it will return false.
  Future<void> _bindBackgroundIsolate() async {
    log('DownloadsController - _bindBackgroundIsolate called');
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );

    log('_bindBackgroundIsolate - isSuccess = $isSuccess');

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    } else {
      _port.listen((message) async {
        setState(
          () {
            print(message);
            downloadTaskId = message[0];
            downloadTaskStatus = message[1];
            downloadTaskProgress = message[2];
          },
        );

        if (message[1] == 2 || message[1] == 1) {
          print('downloading true');
          isDownloading = true;
        } else if (message[1] == 3 && message[2] == 100) {
          if (downloadTaskId != null) {
            print('${message[0]}- download');
            if (Platform.isIOS) {
              await Future.delayed(const Duration(milliseconds: 500));
              await FlutterDownloader.open(taskId: downloadTaskId!);
            }
            AppUtils.flushBar(context, 'File Downloaded Successfully');
            context.popRoute();
          }
          isDownloading = false;
        } else {
          isDownloading = false;
          AppUtils.flushBar(
            context,
            'Downloaded Failed',
            isSuccessPopup: false,
          );
          context.popRoute();
        }
      });
      await FlutterDownloader.registerCallback(registerCallback);
    }
  }

  /// [_unbindBackgroundIsolate] is used to remove the registered [SendPort] [downloader_send_port]'s mapping.
  void _unbindBackgroundIsolate() {
    log('DownloadsController - _unbindBackgroundIsolate called');
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  /// [registerCallback] is used to update the download progress
  @pragma('vm:entry-point')
  static registerCallback(String id, int status, int progress) {
    log('DownloadsController - registerCallback - task id = $id, status = $status, progress = $progress');

    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  /// [downloadFile] method is used to download the enqueue the file to be downloaded using the [url].
  Future<void> downloadFile({required String url}) async {
    log('DownloadsController - downloadFile called');
    log('DownloadsController - downloadFile - url = $url');
    setState(() {
      isDownloading = true;
    });

    /// [downloadDirPath] var stores the path of device's download directory path.
    late String downloadDirPath;
    if (!Platform.isIOS) {
      downloadDirPath = (await getDownloadsDirectory())!.path;
    } else {
      downloadDirPath = (await getApplicationDocumentsDirectory()).path;
    }
    final token = ref.read(tokenNotifierProvider);

    downloadTaskId = await FlutterDownloader.enqueue(
      url: url,
      headers: {
        'Authorization': 'Bearer ${token.accessToken}',
      }, // optional: header send with url (auth token etc)
      savedDir: downloadDirPath,

      saveInPublicStorage: true,
    );
  }

  /// [pauseDownload] pauses the current download task
  Future pauseDownload() async {
    await FlutterDownloader.pause(taskId: downloadTaskId ?? '');
  }

  /// [resumeDownload] resumes the paused download task
  Future resumeDownload() async {
    await FlutterDownloader.resume(taskId: downloadTaskId ?? '');
  }

  /// [cancelDownload] cancels the current download task
  Future cancelDownload() async {
    await FlutterDownloader.cancel(taskId: downloadTaskId ?? '');
    setState(() {
      isDownloading = false;
    });
  }

  /// [getDownloadStatusString] returns the status of the download task in string format to show on the screen.
  String getDownloadStatusString() {
    late String downloadStatus;

    switch (downloadTaskStatus) {
      case 0:
        downloadStatus = 'Undefined';
        break;
      case 1:
        downloadStatus = 'Enqueued';
        break;
      case 2:
        downloadStatus = 'Downloading';
        break;
      case 3:
        downloadStatus = 'Failed';
        break;
      case 4:
        downloadStatus = 'Canceled';
        break;
      case 5:
        downloadStatus = 'Paused';
        break;
      default:
        downloadStatus = 'Error';
    }

    return downloadStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,

      // insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shadowColor: AppColor.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(15),
      ),
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: Container(
        width: 70,
        color: AppColor.white,
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(20),
            Text(
              'Download Status',
              style: AppTextTheme.semiBold14,
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: CircularProgressIndicator(
                    color: AppColor.primary,
                  ),
                ),
                Text(
                  'Downloading....',
                  style: AppTextTheme.label14
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
