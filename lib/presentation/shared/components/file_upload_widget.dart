// ignore_for_file: avoid_print, prefer_foreach

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/extension/context.dart';
import '../../../../core/extension/log.dart';
import '../../../../core/extension/widget.dart';
import '../../../../core/utils/app_utils.dart';
import '../../theme/app_style.dart';
import '../../theme/config/app_color.dart';
import '../gen/assets.gen.dart';
import '../providers/error_timer_notifier.dart';
import 'app_text_theme.dart';
import 'custom_filled_button.dart';
import 'multiple_camera_image/camera_page.dart';

final fileListProvider =
    StateProvider.family<List<String>, String>((ref, type) {
  return [];
});

class UploadWidget extends ConsumerStatefulWidget {
  const UploadWidget({
    Key? key,
    required this.filePathCtrl,
    required this.allowedExtensions,
    required this.isMultipleAllowed,
    required this.type,
    required this.onUpload,
    this.maxPhotos,
  }) : super(key: key);
  final TextEditingController filePathCtrl;
  final List<String> allowedExtensions;
  final bool isMultipleAllowed;
  final String type;
  final void Function(List<String> filePaths) onUpload;
  final int? maxPhotos;

  @override
  ConsumerState<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends ConsumerState<UploadWidget> {
  File? imageFile;
  String? fileName;
  String filePath = '';

  List<String> selectedFileNames = [];
  List<String> selectedPaths = [];
  late bool isAllowed;
  late bool isPhotoAllowed;
  late bool isDocAllowed;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(fileListProvider(widget.type).notifier).state = [];
    });
    isAllowed = false;

    isPhotoAllowed = false;
    isDocAllowed = false;
    selectedFileNames.clear();
    selectedPaths.clear();
    for (final element in widget.allowedExtensions) {
      if (element == 'png' ||
          element == 'jpg' ||
          element == 'jpeg' ||
          element == 'HEIC') {
        setState(() {
          isPhotoAllowed = true;
        });
      }
    }
    for (final element in widget.allowedExtensions) {
      if (element == 'pdf' || element == 'xls' || element == 'xlsx') {
        setState(() {
          isDocAllowed = true;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final List<XFile> result = [];
      if (source == ImageSource.gallery) {
        if (!widget.isMultipleAllowed) {
          final data = await _imagePicker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 40,
          );
          if (data == null) {
            return;
          }
          result.add(data);
        } else {
          final data = await _imagePicker.pickMultiImage(
            imageQuality: 20,
          );
          if (data.isEmpty) {
            return;
          }
          result.addAll(data);
        }
        bool sizeExceeded = false;
        final List<XFile> newList = [];

        for (final element in result) {
          final lenght = await File(element.path).length() / (1024 * 1024);
          lenght.logError();
          if (await File(element.path).length() / (1024 * 1024) >= 5) {
            if (!sizeExceeded) {
              ref
                  .read(
                    errorTimerNotifierProvider(widget.type).notifier,
                  )
                  .startTime(
                    seconds: 5,
                    error: 'Images must be less than 5 mb',
                  );
              sizeExceeded = true;
            }
          } else {
            newList.add(element);
          }
        }

        for (final element in newList) {
          setState(() {
            selectedFileNames.add(AppUtils.getFileName(element.name));
            selectedPaths.add(element.path);
          });
        }

        ref
            .read(fileListProvider('FILE-UPLOAD').notifier)
            .update((state) => selectedPaths);
      } else {
        final data = await availableCameras();
        if (data.isNotEmpty) {
          // ignore: use_build_context_synchronously
          final List<String>? response = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CameraPage(
                cameras: data,
                maxImageCount: widget.maxPhotos,
              ),
            ),
          );

          if (response != null && response.runtimeType == List<String>) {
            if (response.isNotEmpty) {
              setState(() {
                selectedPaths = selectedPaths + response;
                for (final element in response) {
                  selectedFileNames.add(AppUtils.getFileName(element));
                }
              });
              ref
                  .read(fileListProvider(widget.type).notifier)
                  .update((state) => selectedPaths);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    if (status.isGranted || status.isLimited) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ref.read(errorTimerNotifierProvider(widget.type));
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.white,
            AppColor.primary.withOpacity(0.3),
            AppColor.primary.withOpacity(0.3),
            AppColor.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              width: context.width,
              child: Text(
                isPhotoAllowed && isDocAllowed
                    ? 'Upload Document'
                    : isPhotoAllowed
                        ? 'Upload Photo'
                        : 'Upload Document',
                style: AppTextTheme.semiBold14.copyWith(
                  fontSize: 13,
                  color: AppColor.white,
                ),
              ).padHor(15).padVer(10),
            ),
            const Gap(15),
            Text(
              isPhotoAllowed && isDocAllowed
                  ? 'Please upload documents in JPG, JPEG, PNG, HEIC, PDF'
                  : isPhotoAllowed
                      ? 'Please upload photos in JPG, JPEG, PNG or HEIC format.'
                      : 'Please upload documents in XLS or XLSX format.',
              style: AppTextTheme.semiBold14.copyWith(color: AppColor.primary),
            ).padHor(),
            Container(
              height: context.heightByPercent(25),
              decoration: BoxDecoration(
                // color: AppColor.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                color: AppColor.white,
                boxShadow: AppStyle.shadow,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isPhotoAllowed,
                          child: GestureDetector(
                            onTap: () async {
                              if (!await checkCameraPermission()) {
                                AppUtils.flushBar(
                                  context,
                                  'You have to provide the permission of camera from settings',
                                  isSuccessPopup: false,
                                );
                                context.popRoute();
                                return;
                              }

                              if (!widget.isMultipleAllowed &&
                                  selectedPaths.isNotEmpty) {
                                ref
                                    .read(
                                      errorTimerNotifierProvider(
                                        widget.type,
                                      ).notifier,
                                    )
                                    .startTime(
                                      seconds: 3,
                                      error: 'Only 1 File is allowed to select',
                                    );
                                return;
                              }
                              _pickImage(ImageSource.camera);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Assets.svg.cameraIcon
                                      .svg(
                                        color: AppColor.white,
                                      )
                                      .padAll(10),
                                ),
                                const Gap(5),
                                Text(
                                  'Camera',
                                  style: AppTextTheme.label12.copyWith(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ).padRight(25),
                          ),
                        ),
                        Visibility(
                          visible: isPhotoAllowed,
                          child: GestureDetector(
                            onTap: () async {
                              if (!widget.isMultipleAllowed &&
                                  selectedPaths.isNotEmpty) {
                                ref
                                    .read(
                                      errorTimerNotifierProvider(
                                        widget.type,
                                      ).notifier,
                                    )
                                    .startTime(
                                      seconds: 3,
                                      error: 'Only 1 File is allowed to select',
                                    );
                                return;
                              }
                              _pickImage(ImageSource.gallery);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Assets.svg.cloudIcon
                                      .svg(color: AppColor.white)
                                      .padAll(10),
                                ),
                                const Gap(5),
                                Text(
                                  'Gallery',
                                  style: AppTextTheme.label12.copyWith(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isPhotoAllowed && isDocAllowed,
                          child: const Gap(25),
                        ),
                        Visibility(
                          visible:
                              (isPhotoAllowed && isDocAllowed) || isDocAllowed,
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                if (!widget.isMultipleAllowed &&
                                    selectedPaths.isNotEmpty) {
                                  ref
                                      .read(
                                        errorTimerNotifierProvider(
                                          widget.type,
                                        ).notifier,
                                      )
                                      .startTime(
                                        seconds: 3,
                                        error:
                                            'Only 1 File is allowed to select',
                                      );
                                  return;
                                }
                                final fileData =
                                    await FilePicker.platform.pickFiles(
                                  allowedExtensions: widget.allowedExtensions,
                                  type: FileType.custom,
                                );
                                if (fileData != null) {
                                  final data = fileData.files.first.size;
                                  if (data / (1024 * 1024) >= 5) {
                                    ref
                                        .read(
                                          errorTimerNotifierProvider(
                                            widget.type,
                                          ).notifier,
                                        )
                                        .startTime(
                                          seconds: 3,
                                          error:
                                              'Files must be less than 10 MB',
                                        );
                                  }
                                  final extensions = AppUtils.getExtension(
                                    fileData.files.first.path,
                                  );
                                  for (final element
                                      in widget.allowedExtensions) {
                                    if (element == extensions) {
                                      setState(() {
                                        isAllowed = true;
                                      });
                                    }
                                  }
                                  if (isAllowed) {
                                    filePath =
                                        fileData.files.first.path.toString();
                                    setState(() {
                                      selectedFileNames.add(
                                        AppUtils.getFileName(
                                          fileData.files.first.name,
                                        ),
                                      );
                                      selectedPaths.add(filePath);
                                    });

                                    ref
                                        .read(
                                          fileListProvider(widget.type)
                                              .notifier,
                                        )
                                        .state = selectedPaths;
                                  } else {
                                    ref
                                        .read(
                                          errorTimerNotifierProvider(
                                            widget.type,
                                          ).notifier,
                                        )
                                        .startTime(
                                          seconds: 3,
                                          error: 'Invalid File Type',
                                        );
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.folder_open_outlined,
                                    size: 30,
                                    color: AppColor.white,
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  'Files',
                                  style: AppTextTheme.label12.copyWith(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (selectedFileNames.isNotEmpty)
                              ? 'Selected Files'
                              : '',
                          style: AppTextTheme.semiBold14
                              .copyWith(color: AppColor.white),
                        ).padLeft(20),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            selectedFileNames.length.logError();
                            return Text(
                              (selectedFileNames.isNotEmpty)
                                  ? (selectedFileNames.length <= 2)
                                      ? (selectedFileNames[index].length >= 20)
                                          ? '${index + 1}. ${selectedFileNames[index].substring(0, 20)}...'
                                          : '${index + 1}. ${selectedFileNames[index]}'
                                      : '${index + 1}. ${selectedFileNames[0].substring(0, 20)}}...+${selectedFileNames.length - 1}'
                                  : 'No file selected yet',
                              style: AppTextTheme.label12
                                  .copyWith(color: AppColor.black),
                              textAlign: (selectedFileNames.isEmpty)
                                  ? TextAlign.center
                                  : TextAlign.left,
                              // overflow: TextOverflow.ellipsis,
                            ).padHor();
                          },
                          // itemCount: 3,
                          itemCount: (selectedFileNames.length <= 2 &&
                                  selectedFileNames.isNotEmpty)
                              ? selectedFileNames.length
                              : 1,
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final timeData = ref.watch(
                              errorTimerNotifierProvider(widget.type),
                            );

                            if (timeData.timer != 0) {
                              return Center(
                                child: Text(
                                  timeData.errorText,
                                  style: AppTextTheme.label12
                                      .copyWith(color: AppColor.red),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).padAll(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: CustomFilledButton(
                    title: 'CANCEL',
                    onTap: () {
                      widget.filePathCtrl.clear();
                      context.popRoute();
                    },
                    color: AppColor.primary,
                  ),
                ),
                const Gap(35),
                Expanded(
                  flex: 5,
                  child: CustomFilledButton(
                    title: 'UPLOAD',
                    onTap: () async {
                      if (selectedPaths.isNotEmpty) {
                        widget.onUpload.call(selectedPaths);
                        // context.popRoute();
                      } else {
                        ref
                            .read(
                              errorTimerNotifierProvider(widget.type).notifier,
                            )
                            .startTime(
                              seconds: 3,
                              error: 'Please select a Image',
                            );
                      }
                    },
                    color: AppColor.primary,
                  ),
                ),
              ],
            ).padHorDefault(),
            const Gap(15),
          ],
        ),
      ),
    );
  }
}
