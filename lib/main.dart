import 'package:base_project_flutter/Page10_scrollable_widget.dart';
import 'package:base_project_flutter/Page1_widget.dart';
import 'package:base_project_flutter/Page2_state.dart';
import 'package:base_project_flutter/Page3_route.dart';
import 'package:base_project_flutter/Page4_assets.dart';
import 'package:base_project_flutter/Page5_capture_error.dart';
import 'package:base_project_flutter/Page6_basic_widget.dart';
import 'package:base_project_flutter/Page7_layout_widget.dart';
import 'package:base_project_flutter/Page8_container_widget.dart';
import 'package:base_project_flutter/Page9_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // 注册 路由表 来进行页面跳转（其实就是Map<String, WidgetBuilder>映射表）
      // routes:  Page3_route.routes,
      // home: const Page3_route(), // routes中设置了'/'路由，就不需要再设置home参数指定主页了，只能二选一，否则会报错

      // 路由钩子 进行路由的拦截和生成
      // onGenerateRoute: Page3_route.onGenerateRoute,// 在 通过pushNamed跳转 & 未注册路由 的情况下回调
      // onUnknownRoute: Page3_route.onUnknownRoute,// 在 通过pushNamed跳转 & 未注册路由 & onGenerateRoute返回null 的情况下回调
      home: Scaffold(
        body: SingleChildScrollView(
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
                  routeButton("Widget", Page1_widget(title: 'Flutter Demo')),
                  routeButton("State", Page2_state()),
                  routeButton("Route", Page3_route()),
                  routeButton("Assets", Page4_assets()),
                  routeButton("Capture error", Page5_capture_error()),
                  routeButton("Basic widget", Page6_basic_widget()),
                  routeButton("Layout Widget", Page7_layout_widget()),
                  routeButton("Container Widget", Page8_container_widget()),
                  routeButton("Scaffold", Page9_scaffold()),
                  routeButton("Scrollable widget", Page10_scrollable_widget()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget routeButton(String text, Widget target) => Builder(
  builder:
      (context) => ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => target),
          );
        },
        child: Text(text, textAlign: TextAlign.center),
      ),
);

class InfoText extends Text {
  InfoText(String text) : super(text, style: TextStyle(fontSize: 12));
}
