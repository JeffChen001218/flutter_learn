import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ============================ 异常捕获 =====================================

class Page5_capture_error extends StatefulWidget {
  const Page5_capture_error({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage5();
}

class StatePage5 extends State<Page5_capture_error> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // 全局异常上报（同步/异步任务 里面抛出的异常 都能被捕获）
              PlatformDispatcher.instance.onError = (err, stack) {
                _reportErr(err, stack); // 开始上报
                return true;
              };
            },
            child: Text("启动全局异常捕获"),
          ),
          ElevatedButton(
            onPressed: () {
              Future(() {
                throw Exception("==同步异常==");
              });
            },
            child: Text("抛出同步异常"),
          ),
          ElevatedButton(
            onPressed: () {
              Future(() async {
                throw Exception("==异步异常==");
              });
            },
            child: Text("抛出异步异常"),
          ),
        ],
      ),
    ),
  );
}

void _reportErr(dynamic err, StackTrace stackTrace) {
  Fluttertoast.showToast(msg: "捕获到异常：${err.message}");
}
