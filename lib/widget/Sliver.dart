import 'package:flutter/cupertino.dart';

typedef OnBuild =
    Widget Function(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
    );

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double extentMax;
  final double extentMin;
  final OnBuild onBuild;

  SliverHeaderDelegate({
    required this.extentMax,
    required this.extentMin,
    required this.onBuild,
  });

  SliverHeaderDelegate.fixedExtent({
    required double extent,
    required Widget child,
  }) : extentMax = extent,
       extentMin = extent,
       onBuild = ((_, _, _) => child);

  SliverHeaderDelegate.builder({
    required this.extentMax,
    required this.extentMin,
    required Widget child,
  }) : onBuild = ((_, _, _) => child);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = onBuild(context, shrinkOffset, overlapsContent);
    //测试代码：如果在调试模式，且子组件设置了key，则打印日志
    assert(() {
      if (child.key != null) {
        print('${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => extentMax;

  @override
  double get minExtent => extentMin;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate old) =>
      old.maxExtent != maxExtent || old.minExtent != minExtent;
}
