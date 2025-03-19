import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:flutter/material.dart';

// ============================ assets资源文件 =====================================

class Page4_assets extends StatefulWidget {
  const Page4_assets({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage4();
}

class StatePage4 extends State<Page4_assets> {
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
          SizedBox(width: 200, child: Image.asset("assets/image/test_pic.jpg")),
          Text("[assets图片：assets/image/test_pic.jpg]"),
          paddingTop(10),
          Image.network("https://picsum.photos/1200/900",width: 200,height: 30,
            fit: BoxFit.cover,),
          Text("[网络图片：https://picsum.photos/1200/900]"),
        ],
      ),
    ),
  );
}
