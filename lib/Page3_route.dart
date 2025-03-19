import 'dart:math';

import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ============================ 路由 =====================================
// 通过MaterialApp(..)的参数进行控制
// 1️⃣ 通过home指定主页
// 2️⃣ 通过routes指定路由注册表（Map<String, WidgetBuilder>）
// 3️⃣ 通过onGenerateRoute生成 routes中未注册 的路由
// 4️⃣ 通过onUnknownRoute处理 routes中未注册 且 onGenerateRoute未生成 的路由
// 5️⃣ 通过navigatorObservers监听页面打打开和关闭

class Page3_route extends StatefulWidget {
  static Map<String, WidgetBuilder> routes = {
    "/": (context) => Page3_route(),
    "new_page":
        (context) => NewRoutePage(
          /** 这里可以 同时适配：
           *       通过注册的路由名称 跳转时，argument的参数
           *    和 通过构造函数直接传递参数*/
          paramFromRoute: ModalRoute.of(context)?.settings.arguments,
        ),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (!["/", "new_page"].contains(settings.name)) {
      return null;
    }
    return MaterialPageRoute(
      builder: (context) {
        switch (settings.name) {
          case "/":
            return Page3_route();
          case "new_page":
            return NewRoutePage(
              // 可以在这提前获取参数传入构造函数，或者这届到目标组件的build函数中获取
              paramFromRoute: ModalRoute.of(context)?.settings.arguments,
            );
          default:
            throw Exception("Wrong route name");
        }
      },
      settings: settings,
    );
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    /** 路由找不到时，可以可以跳转到默认页面*/
    return MaterialPageRoute(builder: (context) => Page404());
  }

  const Page3_route({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage3();
}

class StatePage3 extends State<Page3_route> {
  var btnClickCount = 0;

  void routeByWidgetInstance() async {
    int pageResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          /**
           * 传参方式 1. 直接指定目标页面时：
           *        可以通向 构造函数 添加参数 的方式，向新页面传递路由数据
           *        受限于 构造函数的参数，每传一个都需要提前定义好
           */
          return NewRoutePage(paramFromRoute: "==这是通过“构造函数”传入的参数==");
        },
      ),
    );
    Fluttertoast.showToast(msg: "收到页面返回的数据:${pageResult}");
  }

  void routeByRegisterName() async {
    var pageResult = await Navigator.pushNamed(
      context,
      "new_page",
      /**
       * 传参方式 2. 通过在MaterialApp中注册的路由名称跳转时：
       *        可以直接通过 Navigator.pushNamed(...) 的 arguments参数传递路由参数
       *        不受 目标路由组件的构造函数的参数 限制
       */
      arguments: "==这是通过“Navigator.pushNamed(...) arguments”传入的参数==",
    );
    Fluttertoast.showToast(msg: "收到页面返回的数据:${pageResult}");
  }

  void routeUnknownRouter() async {
    Navigator.pushNamed(context, "any_err_route_name");
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
              // 开始跳转
              routeByWidgetInstance();
            },
            child: Text("直接指定目标组件进行跳转(Navigator.push(..))"),
          ),
          ElevatedButton(
            onPressed: () {
              // 开始跳转
              routeByRegisterName();
            },
            child: Text("通过注册的路由名称进行跳转(Navigator.pushName(..))"),
          ),
          ElevatedButton(
            onPressed: () {
              // 开始跳转
              routeUnknownRouter();
            },
            child: Text("跳转到未知路由（未注册&onGenerateRoute未指定）"),
          ),
        ],
      ),
    ),
  );
}

class NewRoutePage extends StatelessWidget {
  var paramFromRoute = null;

  NewRoutePage({Key? key, this.paramFromRoute}) : super(key: key);

  getPageResult() => Random(DateTime.now().millisecond).nextInt(10);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SizedBox.expand(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This is new page",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                "收到的参数：${paramFromRoute}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              paddingTop(20),
              ElevatedButton(
                onPressed: () {
                  /** 回传页面结果 */
                  Navigator.pop(context, getPageResult());
                },
                child: Text("主动回传数据给上一个页面"),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        /** 监听页面关闭并返回数据 */
        /** 回传页面结果 */
        Navigator.pop(context, getPageResult());
        return false; // 阻止默认返回行为
      },
    );
  }
}

class Page404 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: Center(
      child: Text(
        "404: oops~, page not found.",
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
    ),
  );
}
