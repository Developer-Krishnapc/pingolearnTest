import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/entity_type.dart';
import '../../theme/config/app_color.dart';
import '../gen/assets.gen.dart';
import 'file_upload_widget.dart';

class ProfileImageEditWidget extends StatelessWidget {
  const ProfileImageEditWidget({
    super.key,
    required this.imageUrl,
    this.selectedImagePath,
    this.onUpload,
  });
  final String imageUrl;
  final String? selectedImagePath;
  final void Function(List<String>)? onUpload;

  @override
  Widget build(BuildContext context) {
    final isValidImage = imageUrl.isNotEmpty ||
        (selectedImagePath != null && selectedImagePath?.isNotEmpty == true);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.bluishGrey,
                ),
                height: 110,
                width: 110,
                child: (selectedImagePath != null &&
                        selectedImagePath?.isNotEmpty == true)
                    ? Image.file(
                        File(
                          selectedImagePath ?? '',
                        ),
                        fit: BoxFit.cover,
                      )
                    : (imageUrl.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              if (onUpload != null)
                Positioned.fill(
                  child: InkWell(
                    onTap: () {
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
                            isMultipleAllowed: false,
                            maxPhotos: 1,
                            onUpload: (files) async {
                              if (files.isNotEmpty) {}
                              onUpload?.call(files);

                              context.popRoute();
                            },
                            type: EntityType.collectionModule,
                          );
                        },
                      );
                    },
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 10,
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: isValidImage ? AppColor.neonGreen : AppColor.darkRed,
              shape: BoxShape.circle,
            ),
            child: isValidImage
                ? Assets.svg.correctIcon.svg()
                : Assets.svg.incorrectIcon.svg(),
          ),
        ),
      ],
    );
  }
}
