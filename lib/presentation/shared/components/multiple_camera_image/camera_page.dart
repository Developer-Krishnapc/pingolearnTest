import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_utils.dart';
import 'preview_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.cameras,
    this.shutterWidget,
    this.bottomStripColor,
    this.completedWidget,
    this.noImageWidget,
    this.imageCountBgColor,
    this.imageCountTextStyle,
    this.cameraLoadingWidget,
    this.previewPageAppBarColor,
    this.previewPageAppBarTextWidget,
    this.previewPageBottomAreaColor,
    this.selectImageWidget,
    this.deSelectImageWidget,
    this.maxImageCount,
  });
  final List<CameraDescription>? cameras;

  // Height<=70
  final Widget? shutterWidget;

  final Color? bottomStripColor;

  // Height <= 70, width<=60
  final Widget? completedWidget;

  // Height <= 40, width<=40
  final Widget? noImageWidget;

  final Color? imageCountBgColor;

  final TextStyle? imageCountTextStyle;

  final Widget? cameraLoadingWidget;

  final Text? previewPageAppBarTextWidget;
  final Color? previewPageAppBarColor;
  final Color? previewPageBottomAreaColor;
  final Widget? selectImageWidget;
  final Widget? deSelectImageWidget;
  final int? maxImageCount;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  List<String> selectedImagePathList = [];

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.max);

    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint('camera error $e');
    }
  }

  @override
  void initState() {
    super.initState();

    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      final XFile picture = await _cameraController.takePicture();

      // ignore: use_build_context_synchronously
      final List<dynamic>? data = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(
            filePath: picture.path,
            deSelectImageWidget: widget.deSelectImageWidget,
            previewPageAppBarColor: widget.previewPageAppBarColor,
            previewPageAppBarTextWidget: widget.previewPageAppBarTextWidget,
            previewPageBottomAreaColor: widget.previewPageBottomAreaColor,
            selectImageWidget: widget.selectImageWidget,
          ),
        ),
      );

      if (data != null && data.isNotEmpty) {
        setState(() {
          selectedImagePathList.add(picture.path);
        });
      }
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _cameraController.value.isInitialized
            ? Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CameraPreview(_cameraController),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      color: widget.bottomStripColor ?? Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (selectedImagePathList.length >=
                                  (widget.maxImageCount ?? double.infinity)) {
                                AppUtils.flushBar(
                                  context,
                                  'Only ${widget.maxImageCount} is allowed',
                                  isSuccessPopup: false,
                                );
                                return;
                              }
                              await takePicture();
                            },
                            child: widget.shutterWidget ??
                                const Icon(
                                  Icons.circle,
                                  size: 65,
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 10,
                    child: (selectedImagePathList.isNotEmpty)
                        ? Stack(
                            children: [
                              const SizedBox(
                                width: 40,
                                height: 40,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CircleAvatar(
                                  radius: 27,
                                  child: Image.file(
                                    File(selectedImagePathList.last),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor:
                                      widget.imageCountBgColor ?? Colors.red,
                                  radius: 10,
                                  child: Text(
                                    selectedImagePathList.length.toString(),
                                    style: widget.imageCountTextStyle ??
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: 40,
                            height: 40,
                            child: widget.noImageWidget,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(
                            context,
                            [...selectedImagePathList],
                          );
                        },
                        child: SizedBox(
                          height: 70,
                          width: 60,
                          child: Center(
                            child: widget.completedWidget ??
                                const Text(
                                  'Done',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : widget.cameraLoadingWidget ??
                const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
