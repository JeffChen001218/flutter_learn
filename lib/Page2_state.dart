import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:flutter/material.dart';

class Page2_state extends StatefulWidget {
  const Page2_state({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage2();
}

class StatePage2 extends State<Page2_state> {
  var btnClickCount = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TapBox(),
          paddingTop(10),
          TapBox(),
          paddingTop(10),
          Text("Buttons total click count:${btnClickCount}"),
          Buttons(() {
            setState(() {
              btnClickCount++;
            });
          }),
          LightBorderBox(),
        ],
      ),
    ),
  );
}

// =================================== 1. Widget管理自己的状态 ==========================================
class TapBox extends StatefulWidget {
  var initialActive = false;

  TapBox({super.key, this.initialActive = false});

  @override
  State<StatefulWidget> createState() => TabBoxState();
}

class TabBoxState extends State<TapBox> {
  var isActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isActive = widget.initialActive;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      setState(() {
        isActive = !isActive;
      });
    },
    child: Container(
      color: isActive ? Color(0x802196F3) : Colors.grey,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Center(child: Text("Hello world!")),
      ),
    ),
  );
}

// =================================== 2. 父组件管理子组件Widget状态 ==========================================
class Buttons extends StatelessWidget {
  VoidCallback? onBtnClick;

  Buttons(this.onBtnClick);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: onBtnClick, child: Text("Button 1")),
        paddingLeft(20),
        ElevatedButton(onPressed: onBtnClick, child: Text("Button 2")),
        paddingLeft(20),
        ElevatedButton(onPressed: onBtnClick, child: Text("Button 3")),
      ],
    ),
  );
}

// =================================== 3. 混合管理Widget状态（父组件管理子组件 & 子组件管理自己） ==========================================
typedef OnPressListener = void Function(bool, Color);

class LightBorderBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LightBorderBoxState();
}

class LightBorderBoxState extends State<LightBorderBox> {
  var pressing = false;
  Color primaryColor = Colors.grey;

  void onPressListener(bool pressing, Color primaryColor) {
    setState(() {
      this.pressing = pressing;
      this.primaryColor = primaryColor;
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: pressing ? primaryColor : Colors.grey,
          width: pressing ? 10 : 5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureText(
                text: "green",
                primaryColor: Colors.green,
                onPressListener: onPressListener,
              ),
              paddingLeft(20),
              GestureText(
                text: "blue",
                primaryColor: Colors.blue,
                onPressListener: onPressListener,
              ),
              paddingLeft(20),
              GestureText(
                text: "red",
                primaryColor: Colors.red,
                onPressListener: onPressListener,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class GestureText extends StatefulWidget {
  final String text;
  final Color primaryColor;
  final OnPressListener onPressListener;

  const GestureText({
    Key? key,
    required this.text,
    required this.primaryColor,
    required this.onPressListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GestureTextState();
}

class GestureTextState extends State<GestureText> {
  var pressing = false;

  void onPressChange(bool pressing) {
    setState(() {
      this.pressing = pressing;
      widget.onPressListener(pressing, widget.primaryColor);
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (details) {
      onPressChange(true);
    },
    onTapUp: (details) {
      onPressChange(false);
    },
    onTapCancel: () {
      onPressChange(false);
    },
    child: SizedBox(
      height: 80,
      width: 80,
      child: Container(
        color: pressing ? widget.primaryColor : Colors.grey,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "${widget.text.toUpperCase()}\n${pressing ? "Pressed" : "Not Pressed"}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: pressing ? FontWeight.w700 : FontWeight.w400,
              fontSize: pressing ? 14 : 10,
            ),
          ),
        ),
      ),
    ),
  );
}


// =================================== 4. 全局Widget状态管理（自定义总线并监听 or 三方组件） ==========================================
// 1️⃣. 自定义全局总线并监听

// 2️⃣. Provider
//
// 适用于：
// ✔ 小型 & 中型 Flutter 项目
// ✔ 需要简单的状态管理（例如：主题、登录状态、购物车）
// ✔ 需要 高性能 和 最少代码量

// 3️⃣. Redux
//
// 适用于：
// ✔ 大型项目，有复杂数据流 & 业务逻辑
// ✔ 需要可预测的状态管理（如多人协作、大型应用）
// ✔ 需要调试工具（Redux DevTools）