import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/extension/widget.dart';
import '../../domain/model/document_model.dart';
import '../design/components/sample_pages_app_bar.dart';
import '../shared/components/app_text_theme.dart';

@RoutePage()
class ImageListPage extends StatefulWidget {
  const ImageListPage({super.key, required this.imageList});
  final List<DocumentModel> imageList;

  @override
  State<ImageListPage> createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  int currentPage = 0;
  final pageController = PageController();
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SamplePageAppBar(
              title: 'Images',
              actionWidget: Text(
                '${currentPage + 1} / ${widget.imageList.length}',
                style:
                    AppTextTheme.label14.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                controller: pageController,
                children: widget.imageList
                    .map(
                      (e) => InteractiveViewer(
                        maxScale: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: e.url,
                          ),
                        ).pad(bottom: 15, left: 15, right: 15, top: 15),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ).padHor(15),
      ),
    );
  }
}
