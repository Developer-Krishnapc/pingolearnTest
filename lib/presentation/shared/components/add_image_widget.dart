import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/entity_type.dart';
import '../../../domain/model/document_model.dart';
import '../../theme/config/app_color.dart';
import '../gen/assets.gen.dart';
import 'app_text_theme.dart';
import 'dashed_container_widget.dart';
import 'file_upload_widget.dart';
import 'image_view_widget.dart';

class AddImageWidget extends StatefulWidget {
  const AddImageWidget({
    super.key,
    required this.onUpload,
    required this.selectedFiles,
    this.heroTag,
    this.onRemove,
    this.maxImages,
  });
  final void Function(List<DocumentModel> filePaths) onUpload;
  final Future<bool> Function({required int documentId, required int modelId})?
      onRemove;
  final List<DocumentModel> selectedFiles;
  final String? heroTag;
  final int? maxImages;

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted)
        setState(() {
          newselectedFiles = widget.selectedFiles;
        });
    });
    super.initState();
  }

  List<DocumentModel> newselectedFiles = [];
  @override
  Widget build(BuildContext context) {
    if (widget.selectedFiles.isNotEmpty || newselectedFiles.isNotEmpty) {
      return ImageViewWidget(
        selectedFileList: widget.selectedFiles.length > newselectedFiles.length
            ? widget.selectedFiles
            : newselectedFiles,
        onUpload: widget.onUpload,
        heroTag: widget.heroTag,
        onRemove: widget.onRemove,
        maximumImages: widget.maxImages,
      );
    }
    return InkWell(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return UploadWidget(
              filePathCtrl: TextEditingController(),
              allowedExtensions: const [
                'jpg',
                'HEIC',
                'png',
              ],
              isMultipleAllowed: widget.maxImages == null,
              maxPhotos: widget.maxImages,
              onUpload: (files) {
                widget.onUpload
                    .call(files.map((e) => DocumentModel(url: e)).toList());
                context.popRoute();
                setState(() {
                  newselectedFiles =
                      files.map((e) => DocumentModel(url: e)).toList();
                });
              },
              type: EntityType.collectionModule,
            );
          },
        );
      },
      child: DashedBorderContainer(
        color: AppColor.primary,
        strokeWidth: 1.5,
        dashLength: 5,
        gapLength: 3,
        borderRadius: 10,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Gap(20),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.svg.cameraIcon.svg(),
                        Text(
                          'Camera',
                          style: AppTextTheme.label12,
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      endIndent: 10,
                      indent: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.svg.cloudIcon.svg(),
                        Text(
                          'Files',
                          style: AppTextTheme.label12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(15),
              Text(
                'Upload Multiple Image',
                textAlign: TextAlign.center,
                style:
                    AppTextTheme.semiBold14.copyWith(color: AppColor.primary),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
