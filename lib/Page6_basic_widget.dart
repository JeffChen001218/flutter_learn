import 'dart:async';

import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ============================ 基础组件示例 =====================================

const IconData wechatIcon = IconData(
  0xf1d7,
  fontFamily: "CustomIconFont",
  matchTextDirection: true,
);

class Page6_basic_widget extends StatefulWidget {
  const Page6_basic_widget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage6();
}

class StatePage6 extends State<Page6_basic_widget> {
  var checkBoxState = false;
  var switchState = false;

  var textFieldFocusNode1 = FocusNode();
  var textFieldFocusNode2 = FocusNode();
  var isFocused1 = false;
  var isFocused2 = false;

  var progress = 0.0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    // 必须通过监听焦点节点的方式获取焦点状态
    // 在这个示例中，如果在widget中直接读取hasFocus状态，会导致布局刷新，焦点在两个输入框来回切换
    textFieldFocusNode1.addListener(() {
      setState(() {
        isFocused1 = textFieldFocusNode1.hasFocus;
      });
    });
    textFieldFocusNode2.addListener(() {
      setState(() {
        isFocused2 = textFieldFocusNode2.hasFocus;
      });
    });

    // 定时器：progress值从0.0~1.0循环
    timer = Timer.periodic(Duration(milliseconds: 10), (time) {
      setState(() {
        if (progress + 0.01 > 1.0) {
          progress = 0;
        } else {
          progress = progress + 0.01;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            paddingTop(30),
            // 图标文本
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Material Icons: "),
                Icon(Icons.accessible, color: Colors.yellow),
                Icon(Icons.error, color: Colors.red),
                Icon(Icons.fingerprint, color: Colors.blue),
              ],
            ),
            paddingTop(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Custom Icon Font: "),
                Icon(wechatIcon, color: Colors.green),
              ],
            ),

            // 复选框
            paddingTop(10),
            Checkbox(
              value: checkBoxState,
              onChanged: (checked) {
                setState(() {
                  checkBoxState = checked ?? false;
                });
              },
            ),

            // 开关
            paddingTop(10),
            Switch(
              value: switchState,
              onChanged: (checked) {
                setState(() {
                  switchState = checked ?? false;
                });
              },
            ),

            // 输入框
            paddingTop(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    focusNode: textFieldFocusNode1,
                    decoration: InputDecoration(
                      labelText: "提示标签",
                      hintText: "提示词1",
                      hintStyle: TextStyle(color: Colors.blue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green.withAlpha(128),
                          width: 3,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 3),
                      ),
                      prefixIcon: Icon(Icons.android),
                    ),
                  ),
                ),
                Text("Focused: ${isFocused1}"),
              ],
            ),
            paddingTop(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    focusNode: textFieldFocusNode2,
                    decoration: InputDecoration(
                      hintText: "提示词2",
                      hintStyle: TextStyle(color: Colors.red),
                      // 经测试enabledBorder才是正常无焦点状态下的border样式，而border样式不生效
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5),
                      ),
                      prefixIcon: Icon(Icons.adb_sharp),
                    ),
                  ),
                ),
                Text("Focused: ${isFocused2}"),
              ],
            ),
            paddingTop(5),
            MyForm(),
            paddingHorizontal(
              20,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // 知道确切的进度 & 动态颜色
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          color: Colors.blue.withAlpha(
                            (255 * progress).toInt(),
                          ),
                        ),
                        paddingTop(5),
                        CircularProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          color: Colors.blue.withAlpha(
                            (255 * progress).toInt(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  paddingLeft(10),
                  Expanded(
                    child: Column(
                      children: [
                        // 不知道进度(循环动画) & 固定颜色
                        LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          color: Colors.green,
                        ),
                        paddingTop(5),
                        SizedBox(
                          width: 50,
                          height: 25,
                          child: CircularProgressIndicator(
                            // value: progress,
                            backgroundColor: Colors.grey[200],
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            paddingTop(5),
            paddingTop(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 环形进度条 & 明确知道进度 & 动态颜色
                paddingLeft(5),
                // 环形进度条 & 不知道进度（一直循环动画） & 固定颜色
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  var formKey = GlobalKey<FormState>();
  var accountInputController = TextEditingController();
  var pwdInputController = TextEditingController();

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
      children: [
        Text("登录表单测试："),
        TextFormField(
          decoration: InputDecoration(hintText: "用户名"),
          controller: accountInputController,
          validator:
              (input) => ((input ?? "").trim().isEmpty ? "用户名不能为空" : null),
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "密码"),
          controller: pwdInputController,
          obscureText: true,
          validator:
              (input) => ((input ?? "").trim().length < 6 ? "密码不能小于6位" : null),
        ),
        paddingTop(
          10,
          child: Row(
            children: [
              Expanded(
                child: paddingHorizontal(
                  20,
                  child: ElevatedButton(
                    onPressed: () {
                      var a = formKey.currentState;
                      if (formKey.currentState?.validate() == true) {
                        Fluttertoast.showToast(msg: "表单数据检验 [成功] ~");
                      } else {
                        Fluttertoast.showToast(msg: "表单数据检验 [失败] ！");
                      }
                    },
                    child: Text("登录"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
