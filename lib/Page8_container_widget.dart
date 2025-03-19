import 'dart:async';
import 'dart:math';

import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// ============================ 容器组件示例 =====================================

class Page8_container_widget extends StatefulWidget {
  const Page8_container_widget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage8();
}

class StatePage8 extends State<Page8_container_widget> {
  @override
  void initState() {
    super.initState();
    // do nothing ...
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              paddingTop(30),
              InfoText("============== Transformer ============="),
              InfoText("============== 坐标轴倾斜 ============="),
              SkewDemo(),
              InfoText("============== 平移 ============="),
              TranslationDemo(),
              InfoText("============== 旋转 ============="),
              RotationDemo(),
              InfoText("============== 缩放 ============="),
              ScaleDemo(),
              InfoText("============== margin/padding ============="),
              SpacingDemo(),
              InfoText("============== 裁剪 ============="),
              InfoText("注：裁剪后，只是展示区域发生了变化，实际占用位置不受影响"),
              ClipDemo(),
              InfoText("============== FittedBox ============="),
              FittedBoxDemo(),
            ],
          ),
        ),
      ),
    ),
  );
}

class SkewDemo extends StatefulWidget {
  @override
  State<SkewDemo> createState() => SkewDemoState();
}

class SkewDemoState extends State<SkewDemo> {
  double bookmarkAnimValue = 1;
  Timer? bookmarkTimer;

  void startBookmarkAnim({required bool isPressDown}) async {
    bookmarkTimer?.cancel();
    final double duration = 100.0;
    var remainingMillis = duration;
    bookmarkTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      remainingMillis -= 16;
      setState(() {
        if (isPressDown) {
          bookmarkAnimValue = remainingMillis / duration;
        } else {
          bookmarkAnimValue = (duration - remainingMillis) / duration;
        }
        if (bookmarkAnimValue < 0) {
          bookmarkAnimValue = 0;
        }
        if (1 < bookmarkAnimValue) {
          bookmarkAnimValue = 1;
        }
      });
      if (bookmarkAnimValue < 0 || 1 < bookmarkAnimValue) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (details) {
      startBookmarkAnim(isPressDown: true);
    },
    onTapUp: (details) {
      startBookmarkAnim(isPressDown: false);
    },
    onTapCancel: () {
      startBookmarkAnim(isPressDown: false);
    },
    child: Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: 40),
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow:
                  bookmarkAnimValue <= 0
                      ? []
                      : [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(-3 * bookmarkAnimValue, 0),
                          blurRadius: 5 * bookmarkAnimValue,
                        ),
                      ],
            ),
            child: Container(
              color: Colors.transparent,
              child: Transform(
                alignment: Alignment.topRight,
                transform: Matrix4.skewY(pi / 12 * bookmarkAnimValue)
                  ..rotateY(pi / 12 * bookmarkAnimValue),
                child: SizedBox(
                  height: 22,
                  child: Container(
                    color: Colors.deepOrange,
                    child: paddingAll(2, child: InfoText("· Bookmark 1")),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class TranslationDemo extends StatefulWidget {
  @override
  State<TranslationDemo> createState() => TranslationDemoState();
}

class TranslationDemoState extends State<TranslationDemo> {
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.amber,
    child: Transform.translate(
      offset: Offset(-10, 5),
      child: InfoText("文本：向左向左偏移10，向下偏移5"),
    ),
  );
}

class RotationDemo extends StatefulWidget {
  @override
  State<RotationDemo> createState() => RotationDemoState();
}

class RotationDemoState extends State<RotationDemo> {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Transform.rotate(
        angle: (2 * pi) /*2π即为整个圆*/ * (45 / 360.0),
        child: Container(
          color: Colors.amber,
          child: SizedBox.square(
            dimension: 100,
            child: InfoText("顺时针旋转\n45度\n(Transformer实现)"),
          ),
        ),
      ),
      paddingLeft(50),
      RotatedBox(
        quarterTurns: 1,
        child: Container(
          color: Colors.amber,
          child: SizedBox.square(
            dimension: 100,
            child: InfoText("顺时针旋转\n90度\n(RotatedBox实现)"),
          ),
        ),
      ),
    ],
  );
}

class ScaleDemo extends StatefulWidget {
  @override
  State<ScaleDemo> createState() => ScaleDemoState();
}

class ScaleDemoState extends State<ScaleDemo> {
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.amber,
    child: Transform.scale(
      scaleX: 0.5,
      scaleY: 0.8,
      alignment: Alignment.topRight,
      child: Container(
        color: Colors.blue,
        child: Text(
          "宽度缩小到1/2\n高度缩小到8/10\n(对齐右上方)",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}

class SpacingDemo extends StatefulWidget {
  @override
  State<SpacingDemo> createState() => SpacingDemoState();
}

class SpacingDemoState extends State<SpacingDemo> {
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.blue,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.amber,
          child: Text("padding 10"),
        ),
        Container(
          margin: EdgeInsets.all(10),
          color: Colors.amber,
          child: Text("margin 10"),
        ),
      ],
    ),
  );
}

class ClipDemo extends StatefulWidget {
  @override
  State<ClipDemo> createState() => ClipDemoState();
}

class ClipDemoState extends State<ClipDemo> {
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        color: Colors.amber,
        child: ClipWidget(
          // 上下左右各裁剪10
          onClip:
              (size) =>
                  Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
          child: SizedBox(
            width: 200,
            child: Image.asset("assets/image/test_pic.jpg"),
          ),
        ),
      ),
    ],
  );
}

typedef ClipCallback = Rect Function(Size);
typedef CheckReclip = bool Function();

class ClipWidget extends StatelessWidget {
  ClipCallback onClip;
  CheckReclip? reclip = null;
  Widget child;

  ClipWidget({required this.onClip, this.reclip, required this.child});

  @override
  Widget build(BuildContext context) =>
      ClipRect(clipper: Clipper(onClip: onClip, reclip: reclip), child: child);
}

class Clipper extends CustomClipper<Rect> {
  ClipCallback onClip;
  CheckReclip? reclip = null;

  Clipper({required this.onClip, this.reclip});

  @override
  Rect getClip(Size size) => onClip(size);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) =>
      reclip?.call() ?? false;
}

class FittedBoxDemo extends StatefulWidget {
  @override
  State<FittedBoxDemo> createState() => FittedBoxDemoState();
}

class FittedBoxDemoState extends State<FittedBoxDemo> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: paddingSymmetric(
      horizontal: 20,
      vertical: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          testFittedBox(
            BoxFit.contain,
            "BoxFit.contain(默认)\n不可超出父布局\n超出后等比缩放，不裁剪",
          ),
          paddingLeft(20),
          testFittedBox(BoxFit.none, "BoxFit.none\n可以超出父布局\n不缩放，不截断"),
          paddingLeft(20),
          testFittedBox(BoxFit.fill, "BoxFit.fill\n无论什么尺寸，强制拉伸为容器大小"),
          paddingLeft(20),
          testFittedBox(BoxFit.cover, "BoxFit.cover\n等比缩放直到宽度和高度都能将父容器覆盖"),
          paddingLeft(20),
          testFittedBox(BoxFit.fitHeight, "BoxFit.fitHeight\n等比缩放，直到高度和父容器一致"),
          paddingLeft(20),
          testFittedBox(BoxFit.fitWidth, "BoxFit.fitHeight\n等比缩放，直到宽度和父容器一致"),
          paddingLeft(20),
          testFittedBox(BoxFit.scaleDown, "BoxFit.scaleDown\n当高或宽超出，才等比缩小，直到不超出父容器"),
          paddingLeft(20),
        ],
      ),
    ),
  );
}

Widget testFittedBox(BoxFit fit, String text) => Container(
  color: Colors.blue,
  width: 80,
  height: 80,
  child: FittedBox(
    fit: fit,
    child: Container(
      color: Colors.amber.withAlpha(128),
      width: 50,
      height: 100,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
);
