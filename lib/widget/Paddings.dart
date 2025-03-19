import 'package:flutter/material.dart';

paddingTop(double padding, {Key? key, Widget? child}) =>
    Padding(padding: EdgeInsets.only(top: padding), key: key, child: child);

paddingLeft(double padding, {Key? key, Widget? child}) =>
    Padding(padding: EdgeInsets.only(left: padding), key: key, child: child);

paddingRight(double padding, {Key? key, Widget? child}) =>
    Padding(padding: EdgeInsets.only(right: padding), key: key, child: child);

paddingBottom(double padding, {Key? key, Widget? child}) =>
    Padding(padding: EdgeInsets.only(bottom: padding), key: key, child: child);

paddingHorizontal(double padding, {Key? key, Widget? child}) => Padding(
  padding: EdgeInsets.symmetric(horizontal: padding),
  key: key,
  child: child,
);

paddingVertical(double padding, {Key? key, Widget? child}) => Padding(
  padding: EdgeInsets.symmetric(vertical: padding),
  key: key,
  child: child,
);

paddingSymmetric({
  double horizontal = 0.0,
  double vertical = 0.0,
  Key? key,
  Widget? child,
}) => Padding(
  padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
  key: key,
  child: child,
);

paddingAll(double padding, {Widget? child}) =>
    Padding(padding: EdgeInsets.all(padding), child: child);

paddingOnly({
  double left = 0.0,
  double top = 0.0,
  double right = 0.0,
  double bottom = 0.0,
  Key? key,
  Widget? child,
}) => Padding(
  padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
  key: key,
  child: child,
);
