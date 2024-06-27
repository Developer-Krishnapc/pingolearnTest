import 'package:flutter/material.dart';

extension ColumnExt on List<Widget> {
  Widget toColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this,
      );
}

extension PaddingExt on Widget {
  Padding padDefault() => Padding(
        padding: const EdgeInsets.all(20),
        child: this,
      );
  Padding padAll(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );

  Padding padHorDefault() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: this,
      );
  Padding padHor([double? padding]) => Padding(
        padding: EdgeInsets.symmetric(horizontal: padding ?? 20),
        child: this,
      );
  Padding padVer([double? padding]) => Padding(
        padding: EdgeInsets.symmetric(vertical: padding ?? 20),
        child: this,
      );
  Padding padVertDefault() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: this,
      );
  Padding padLeft([double? padding]) => Padding(
        padding: EdgeInsets.only(left: padding ?? 20),
        child: this,
      );
  Padding padRight([double? padding]) => Padding(
        padding: EdgeInsets.only(right: padding ?? 20),
        child: this,
      );

  Padding pad({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        ),
        child: this,
      );
}

extension MarginExt on Widget {
  Container marginDefault() => Container(
        margin: const EdgeInsets.all(20),
        child: this,
      );

  Container marginHorDefault() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: this,
      );

  Container marginHor([double? margin]) => Container(
        margin: EdgeInsets.symmetric(horizontal: margin ?? 20),
        child: this,
      );

  Container marginVertDefault() => Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: this,
      );

  Container marginLeft([double? margin]) => Container(
        margin: EdgeInsets.only(left: margin ?? 20),
        child: this,
      );

  Container marginRight([double? margin]) => Container(
        margin: EdgeInsets.only(right: margin ?? 20),
        child: this,
      );

  Container marginTop([double? margin]) => Container(
        margin: EdgeInsets.only(top: margin ?? 20),
        child: this,
      );

  Container marginBottom([double? margin]) => Container(
        margin: EdgeInsets.only(bottom: margin ?? 20),
        child: this,
      );

  Container margin({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) =>
      Container(
        margin: EdgeInsets.only(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        ),
        child: this,
      );
}
