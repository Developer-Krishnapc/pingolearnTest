import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../components/multiple_camera_image/camera_page.dart';

part 'file_picking_provider.g.dart';

@Riverpod(keepAlive: true)
class FilePickerNotifier extends _$FilePickerNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  @override
  List<String> build({String? type}) {
    return [];
  }

  Future<String?> pickImage({
    required ImageSource source,
    double maxLengthMB = 2,
    bool isMultiple = false,
  }) async {
    if (!isMultiple) {
      final result = await _imagePicker.pickImage(
        source: source,
        imageQuality: 20,
      );

      if (result != null) {
        final data = await result.length();
        if (data / (1024 * 1024) > maxLengthMB) {
          // ignore: use_build_context_synchronously
          return 'Selected Image is greater than $maxLengthMB';
        }
        state = [...state, result.path];
      }
      return null;
    } else {
      final result = await _imagePicker.pickMultiImage(
        imageQuality: 20,
      );
      int maxFilesLen = 0;
      if (result.isNotEmpty) {
        result.forEach((element) async {
          final data = await element.length();
          if (data / (1024 * 1024) > maxLengthMB) {
            // ignore: use_build_context_synchronously
            maxFilesLen += 1;
          } else {
            state = [...state, element.path];
          }
        });
      }
      if (maxFilesLen > 0) {
        return 'There ${(maxFilesLen == 1) ? 'is' : 'are'} $maxFilesLen ${(maxFilesLen == 1) ? 'file' : 'files'} which ${(maxFilesLen == 1) ? 'is' : 'are'} greater than $maxLengthMB';
      }
    }

    return null;
  }

  void removeImageByIndex(int index) {
    if (index < state.length) {
      final List<String> newlist = List.from(state);
      newlist.removeAt(index);
      state = newlist;
    }
  }

  void clearState() {
    state = <String>[];
  }

  Future<String?> pickFiles({
    required List<String> extensionList,
    bool allowedMultile = false,
    bool allowCompression = false,
    double maxSizeMB = 3,
  }) async {
    final fileData = await FilePicker.platform.pickFiles(
      allowMultiple: allowedMultile,
      allowCompression: false,
      allowedExtensions: [...extensionList],
      type: FileType.custom,
    );

    if (fileData != null) {
      int maxFilesLen = 0;
      for (final element in fileData.files) {
        if (element.size / (1024 * 1024) <= maxSizeMB && element.path != null) {
          state = [...state, element.path!];
        } else {
          maxFilesLen = 1;
        }
      }

      if (maxFilesLen != 0) {
        return 'There ${(maxFilesLen == 1) ? 'is' : 'are'} $maxFilesLen ${(maxFilesLen == 1) ? 'file' : 'files'} which ${(maxFilesLen == 1) ? 'is' : 'are'} greater than $maxSizeMB';
      }
    }
    return null;
  }

  Future<void> getMultiCameraImages({
    required BuildContext context,
  }) async {
    final data = await availableCameras();
    // ignore: use_build_context_synchronously
    final List<String>? response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraPage(cameras: data),
      ),
    );

    if (response != null && response.isNotEmpty) {
      state = [...state, ...response];
    }
  }
}
