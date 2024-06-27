import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/extension/widget.dart';
import '../../../domain/model/document_model.dart';
import '../../routes/app_router.dart';
import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';
import 'dashed_container_widget.dart';
import 'dummy_image_widget.dart';
import 'file_upload_widget.dart';

class ImageViewWidget extends StatefulWidget {
  const ImageViewWidget({
    super.key,
    this.heroTag,
    required this.selectedFileList,
    this.onUpload,
    this.onRemove,
    this.maximumImages,
  });

  final String? heroTag;

  final List<DocumentModel> selectedFileList;
  final void Function(List<DocumentModel> filePaths)? onUpload;
  final Future<bool> Function({required int documentId, required int modelId})?
      onRemove;

  final int? maximumImages;

  @override
  // ignore: no_logic_in_create_state
  State<ImageViewWidget> createState() => _ImageViewWidgetState(
        selectedFileList: List.from(selectedFileList),
      );
}

class _ImageViewWidgetState extends State<ImageViewWidget> {
  _ImageViewWidgetState({
    required this.selectedFileList,
  });

  @override
  void dispose() {
    _selectedImagePageViewCtrl.dispose();
    _urlImagePageViewCtrl.dispose();
    super.dispose();
  }

  final _selectedImagePageViewCtrl = PageController();
  final _urlImagePageViewCtrl = PageController();

  List<DocumentModel> selectedFileList = [];

  @override
  Widget build(BuildContext context) {
    final isEmpty = selectedFileList.isEmpty;
    return InkWell(
      onTap: () {
        if (widget.onUpload == null && selectedFileList.isNotEmpty) {
          context.pushRoute(ImageListRoute(imageList: selectedFileList));
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              if (isEmpty)
                SizedBox(
                  height: 150,
                  width: double.maxFinite,
                  child: DashedBorderContainer(
                    color: AppColor.primary,
                    strokeWidth: 2,
                    dashLength: 10,
                    gapLength: 12,
                    borderRadius: 10,
                    child: Center(
                      child: Text(
                        'No image is selected yet',
                        style: AppTextTheme.label14.copyWith(
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!isEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 150,
                    width: double.maxFinite,
                    child: Hero(
                      tag: widget.heroTag ?? '',
                      child: PageView(
                        controller: (selectedFileList.isNotEmpty)
                            ? _selectedImagePageViewCtrl
                            : null,
                        children:
                            List.generate(selectedFileList.length, (index) {
                          if (selectedFileList[index].id != -1) {
                            return CachedNetworkImage(
                              imageUrl: selectedFileList[index].url,
                              fit: BoxFit.cover,
                              errorWidget: (context, string, obj) {
                                return const DummyImageWidget();
                              },
                            );
                          } else {
                            return Image.file(
                              File(
                                selectedFileList[index].url,
                              ),
                              fit: BoxFit.cover,
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              if (!isEmpty)
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // if (_urlImagePageViewCtrl.page != 0 &&
                      //     _selectedImagePageViewCtrl.page != 0)
                      InkWell(
                        onTap: () {
                          if (selectedFileList.isNotEmpty) {
                            _selectedImagePageViewCtrl.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear,
                            );
                          }
                        },
                        child: SizedBox(
                          width: 30,
                          height: 35,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColor.whiteBackground,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColor.black,
                              size: 13,
                            ),
                          ),
                        ),
                      ),
                      // if (_urlImagePageViewCtrl.page != urlList.length - 1 &&
                      //     _selectedImagePageViewCtrl.page !=
                      //         selectedFileList.length - 1)
                      InkWell(
                        onTap: () {
                          if (selectedFileList.isNotEmpty) {
                            _selectedImagePageViewCtrl.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear,
                            );
                          }
                        },
                        child: SizedBox(
                          width: 30,
                          height: 35,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColor.whiteBackground,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.black,
                              size: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ).pad(
            left: 10,
            right: 10,
            top: 15,
            bottom: 15,
          ),
          if (widget.onUpload != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedFileList.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      final pageIdx = _selectedImagePageViewCtrl.page?.toInt();
                      if (pageIdx != null) {
                        final document = selectedFileList[pageIdx];
                        if (document.id != -1) {
                          final data = await widget.onRemove?.call(
                            documentId: selectedFileList[pageIdx].id,
                            modelId: selectedFileList[pageIdx].modelId,
                          );
                          if (data == true) {
                            selectedFileList.removeAt(pageIdx);
                            widget.onUpload?.call(selectedFileList);
                          }
                        } else {
                          selectedFileList.removeAt(pageIdx);
                          widget.onUpload?.call(selectedFileList);
                        }
                      }
                    },
                    child: Text(
                      'Remove',
                      style: AppTextTheme.label14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.red,
                        fontSize: 15,
                      ),
                    ).pad(left: 10, right: 10, top: 5, bottom: 5),
                  ),
                if (selectedFileList.isNotEmpty &&
                    (widget.maximumImages == null ||
                        selectedFileList.length < (widget.maximumImages ?? -1)))
                  const Row(
                    children: [
                      Gap(10),
                      SizedBox(
                        height: 15,
                        child: VerticalDivider(
                          color: AppColor.black,
                          thickness: 1,
                        ),
                      ),
                      Gap(10),
                    ],
                  ),
                if (widget.maximumImages == null ||
                    selectedFileList.length < (widget.maximumImages ?? -1))
                  InkWell(
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return UploadWidget(
                            filePathCtrl: TextEditingController(),
                            allowedExtensions: const [
                              'jpg',
                              'HEIC',
                              'png',
                            ],
                            isMultipleAllowed: widget.maximumImages == null,
                            maxPhotos: widget.maximumImages,
                            onUpload: (files) async {
                              selectedFileList.insertAll(
                                0,
                                files.map((e) => DocumentModel(url: e)),
                              );
                              widget.onUpload?.call([
                                ...selectedFileList,
                              ]);

                              context.popRoute();
                            },
                            type: EntityType.collectionModule,
                          );
                        },
                      );
                      // setState(() {});
                    },
                    child: Text(
                      'Add',
                      style: AppTextTheme.label14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.red,
                        fontSize: 15,
                      ),
                    ).pad(left: 10, right: 10, top: 5, bottom: 5),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
