import 'package:flutter/cupertino.dart';

/// 用于开发阶段，打印来自父组件的 高宽 约束范围
class LayoutLogPrint<T> extends StatelessWidget {
  const LayoutLogPrint({Key? key, this.tag, required this.child})
    : super(key: key);

  final Widget child;
  final T? tag; //指定日志tag

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        // assert在编译release版本时会被去除
        assert(() {
          print('${tag ?? key ?? child}: $constraints');
          return true;
        }());
        return child;
      },
    );
  }
}
