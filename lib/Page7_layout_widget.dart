import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// ============================ 布局组件示例 =====================================
/**
 * （下列描述中的“限制”都是指 对高度和宽度的限制）
 *
 * 1. 对于多重限制：
 *    如果父/子容器都设置了 minWidth/minHeight， 取较[大]的那个值，以避免冲突
 *    如果父/子容器都设置了 maxWidth/maxHeight， 取较[小]的那个值，以避免冲突
 *
 * 2. 解除外层父容器限制：
 *    嵌套一层UnconstrainedBox(child: ...)而不设置任何约束
 *    注：
 *      - 外层父容器的限制不能完全解除，UnconstrainedBox只是解除了对内部组件的限制，但它本身还是受到外层父容器的限制
 *      - debug模式下，内部组件高宽如果溢出，会报错提示，但在release模式下会被直接截断
 *      - 防止组件高宽溢出，可以使用 SingleChildScrollView 进行包裹，实现滑动效果
 *
 * 3. 线性布局：Column/Row
 *    关于默认尺寸：
 *      主轴方向：默认填充长度
 *          注：当外层嵌套了SingleChildScrollView时：
 *                若 滑动方向 和主轴  [一致]：主轴方向将长度将不能填充，也会变成自适应长度
 *                若 滑动方向 和主轴[不一致]：主轴长度将变为0！！！
 *      纵轴方向：默认自适应长度（取决于[最大子元素]长度）
 *
 * 4. Align和Stack对比：
 *    不同点：
 *        +===========================+===================================+
    | Stack                     | Align                             |
    +===========================+===================================+
    | 基于四边进行偏移             | 任意位置                           |
    | 支持多个子widget            | 仅支持单个子widget                  |
    | 通过Positoned子组件进行定位  | 通过Alignment或FractionalOffset定位 |
    +---------------------------+-----------------------------------+
 *
 * 5. LayoutBuilder用于响应式布局，动态更改组件的类型
 *    比如：当可以宽度啊大于200，采用双列布局，小于等于200时采用单列布局，本代码示例暂无演示
 *    注：
 *      LayoutBuilder比Builder多一个父容器的BoxConstrains参数
 *      LayoutBuilder一般用于响应式布局；Builder一般用于解决上下文context冲突的问题
 */

class Page7_layout_widget extends StatefulWidget {
  const Page7_layout_widget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage7();
}

class StatePage7 extends State<Page7_layout_widget> {
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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              paddingTop(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Container(
                        color: Colors.blue,
                        child: InfoText("AspectRatio 2"),
                      ),
                    ),
                  ),
                  paddingLeft(5),
                  SizedBox(
                    height: 200,
                    child: AspectRatio(
                      aspectRatio: 0.5,
                      child: Container(
                        color: Colors.blue,
                        child: InfoText("AspectRatio 0.5"),
                      ),
                    ),
                  ),
                  paddingLeft(5),
                ],
              ),
              paddingTop(5),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                  minWidth: 300,
                ),
                child: Container(
                  color: Colors.blue,
                  child: InfoText(
                    "ConstrainedBox\nmaxHeight: double.infinity\nminWidth: 300",
                  ),
                ),
              ),
              paddingTop(5),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  color: Colors.blue,
                  child: InfoText("FractionallySizedBox\n宽度占比0.5"),
                ),
              ),
              paddingTop(5),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.green,
                      child: InfoText("Expanded-weight:3"),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: Colors.yellow,
                      child: InfoText("Expanded-weight:7"),
                    ),
                  ),
                ],
              ),
              paddingTop(5),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.spaceAround,
                children: [
                  Container(color: Colors.amber, child: InfoText("wrap\n组件测试")),
                  Container(color: Colors.amber, child: InfoText("0000000000")),
                  Container(color: Colors.amber, child: InfoText("1111111111")),
                  Container(color: Colors.amber, child: InfoText("2222222222")),
                  Container(color: Colors.amber, child: InfoText("3333333333")),
                  Container(color: Colors.amber, child: InfoText("4444444444")),
                  Container(color: Colors.amber, child: InfoText("5555555555")),
                  Container(color: Colors.amber, child: InfoText("6666666666")),
                ],
              ),
              paddingTop(5),
              InfoText("===========用Flow实现Wrap水平换行效果============="),
              MyWrapByFLow(
                children: [
                  Container(color: Colors.amber, child: InfoText("落霞与孤鹜齐飞")),
                  Container(color: Colors.amber, child: InfoText("，")),
                  Container(color: Colors.amber, child: InfoText("秋水共长天一色")),
                  Container(color: Colors.amber, child: InfoText("。")),
                  Container(color: Colors.amber, child: InfoText("渔舟唱晚")),
                  Container(color: Colors.amber, child: InfoText("，")),
                  Container(color: Colors.amber, child: InfoText("响穷彭蠡之滨")),
                  Container(color: Colors.amber, child: InfoText("，")),
                  Container(color: Colors.amber, child: InfoText("雁阵惊寒")),
                  Container(color: Colors.amber, child: InfoText("，")),
                  Container(color: Colors.amber, child: InfoText("声断衡阳之浦")),
                  Container(color: Colors.amber, child: InfoText("。")),
                ],
              ),
              paddingTop(5),
              InfoText(
                "===========Stack+Positioned（类似FrameLayout）=============",
              ),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        color: Colors.amber,
                        child: InfoText("左上：Positioned(top:0,left:0)"),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        color: Colors.amber,
                        child: InfoText("右上：Positioned(top:0,right:0)"),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        color: Colors.amber,
                        child: InfoText("左下：Positioned(bottom:0,left:0)"),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        color: Colors.amber,
                        child: InfoText("右下：Positioned(bottom:0,right:0)"),
                      ),
                    ),
                    Container(
                      color: Colors.amber,
                      child: InfoText("无Position包裹：根据外层Stack配置，自动居中"),
                    ),
                  ],
                ),
              ),
              paddingTop(5),
              InfoText("====== Align（类似FrameLayout，但只有一个child widget） ======="),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      InfoText("alignment定位参数值:\nAlignment(2.0, 0.0)"),
                      Container(
                        color: Color(0xFFBECED8),
                        child: Align(
                          widthFactor: 2,
                          // 容器宽度在 水平方向 的放大倍数（基于child widget）
                          heightFactor: 2,
                          // 容器宽度在 垂直方向 的放大倍数（基于child widget）
                          alignment: Alignment(
                            2.0, // 水平偏移比例（容器范围从左至右是[-1,1]，超出这个范围级会超出容器）
                            0.0, // 垂直偏移比例（容器范围从上至下是[-1,1]，0表示居中）
                          ),
                          child: FlutterLogo(size: 35),
                        ),
                      ),
                    ],
                  ),
                  paddingLeft(30),
                  Column(
                    children: [
                      InfoText("alignment定位参数值:\nFractionalOffset(0, 0.5)"),
                      Container(
                        color: Color(0xFFBECED8),
                        child: Align(
                          widthFactor: 2,
                          heightFactor: 2,
                          alignment: FractionalOffset(
                            0, // 水平偏移比例（容器范围从左至右是[0,1]，超出这个范围级会超出容器）
                            0.5, // 垂直偏移比例（容器范围从上至下是[0,1]，0.5表示居中）
                          ),
                          child: FlutterLogo(size: 35),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              paddingTop(5),
              InfoText("================ AfterLayout ==============="),
              Container(
                color: Colors.amber,
                child: Align(
                  widthFactor: null,
                  heightFactor: 1,
                  child: InfoText("Align widthFactor设为null（默认），自动填充宽度"),
                ),
              ),
              paddingTop(5),
              AfterLayoutDemo(),
            ],
          ),
        ),
      ),
    ),
  );
}

class MyWrapByFLow extends StatelessWidget {
  List<Widget> children;

  MyWrapByFLow({required this.children});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder:
        (context, constraints) => Flow(
          delegate: WrapDelegateForFlow(
            horizontalSpacing: 8,
            verticalSpacing: 4,
          ),
          children: children,
        ),
  );
}

class WrapDelegateForFlow extends FlowDelegate {
  double horizontalSpacing;
  double verticalSpacing;

  WrapDelegateForFlow({
    required this.horizontalSpacing,
    required this.verticalSpacing,
  });

  var usedWidth = 0.0;
  var usedHeight = 0.0;

  var rowIndex = 0;
  var rowItemIndex = 0;
  var currentLineHeight = 0.0;

  @override
  void paintChildren(FlowPaintingContext context) {
    // 循环处理每个child widget
    for (int i = 0; i < context.childCount; i++) {
      var childWidth = context.getChildSize(i)!.width;
      var childHeight = context.getChildSize(i)!.height;

      // 根据行内元素索引，判断是否需要添加左侧margin（从第二个元素开始，用来实现水平spacing）
      var marginStart = rowItemIndex > 0 ? horizontalSpacing : 0;
      if (usedWidth + marginStart + childWidth > context.size.width) {
        // 如果超出1行最大宽度，则换到下一行，处理下面4个数据状态：
        usedWidth = 0; // 新的一行，重置已用宽度
        rowItemIndex = 0; // 新的一行，行内元素索引，重新从0开始计
        usedHeight += currentLineHeight; // 保存已用行高
        rowIndex++; // 行索引+1
      }
      // 更新一下左侧margin（因为：如果换行的话，第一个元素就不需要左侧margin了）
      marginStart = rowItemIndex > 0 ? horizontalSpacing : 0;
      // 根据行索引，判断是否需要顶部margin（从第二行开始，实现垂直方向的spacing）
      var marginTop = rowIndex > 0 ? verticalSpacing : 0;

      // 放置child widget
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          // 距离Flow容器左侧的距离
          usedWidth + marginStart,
          // 距离Flow容器顶部的距离
          usedHeight + marginTop,
          // Z轴的距离（平面绘制传0即可）
          0,
        ),
      );

      // 更新行内数据
      usedWidth += marginStart + childWidth; // 已用宽度
      rowItemIndex++; // 行内元素索引++
      // 更新当前行的高度（取元素最大高度）
      currentLineHeight = max(currentLineHeight, marginTop + childHeight);
    }
  }

  @override
  Size getSize(BoxConstraints constraints) => Size(double.infinity, 50);

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return this != oldDelegate;
  }
}

class AfterLayoutDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AfterLayoutDemoState();
}

class AfterLayoutDemoState extends State<AfterLayoutDemo>
    with AfterLayoutMixin<AfterLayoutDemo> {
  var width = 0, height = 0;

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.amber,
    child: SizedBox(
      width: double.infinity,
      height: Random(DateTime.now().millisecondsSinceEpoch).nextInt(10) + 20,
      child: Center(
        child: InfoText("AfterLayout 获取组件大小 width：${width},height：${height}"),
      ),
    ),
  );

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    var boxRender = context.size;
    setState(() {
      width = (boxRender?.width ?? 0.0).toInt();
      height = (boxRender?.height ?? 0.0).toInt();
    });
  }
}
