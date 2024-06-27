import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage(
      {super.key,
      required this.filePath,
      this.previewPageAppBarColor,
      this.previewPageAppBarTextWidget,
      this.previewPageBottomAreaColor,
      this.selectImageWidget,
      this.deSelectImageWidget,});
  final String filePath;
  final Text? previewPageAppBarTextWidget;
  final Color? previewPageAppBarColor;
  final Color? previewPageBottomAreaColor;
  final Widget? selectImageWidget;
  final Widget? deSelectImageWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: previewPageAppBarColor,
          title: previewPageAppBarTextWidget ?? const Text('Preview Page'),),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Expanded(child: Image.file(File(filePath), fit: BoxFit.cover)),
          Container(
            color: previewPageBottomAreaColor ?? Colors.black,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context, []);
                  },
                  child: deSelectImageWidget ??
                      const Icon(
                        Icons.cancel,
                        size: 30,
                        color: Colors.white,
                      ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, [filePath]);
                  },
                  child: selectImageWidget ??
                      const Icon(
                        Icons.download_done_sharp,
                        size: 30,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ],),
      ),
    );
  }
}