import 'dart:async';

import 'package:base_project_flutter/widget/dev.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// ============================ 列表组件示例 =====================================
/**
    ListView
 */

class Page10_scrollable_widget extends StatefulWidget {
  const Page10_scrollable_widget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage10();
}

class StatePage10 extends State<Page10_scrollable_widget> {
  @override
  void initState() {
    super.initState();
    // do nothing ...
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
              routeButton(
                "ListView.builder\n通过itemExtent指定每个item高度",
                ListViewFixedItemHeightDemo1(),
              ),
              routeButton(
                "ListView.builder\n通过prototypeItem(item模板)计算每个item高度",
                ListViewFixedItemHeightDemo2(),
              ),
              routeButton("ListView.separated\n实现分割线", ListViewDemo3()),
              routeButton(
                "ListView.separated\n实现加载更多",
                ListViewLoadMoreDemo4(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ListViewFixedItemHeightDemo1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView.builder(
      itemCount: 100,
      // 通过固定值指定item的高度（实际开发中可以使用LayoutLogPrint(child:...)在控制台打印来自父组件的高度约束信息，用于确定最终的固定高度值）
      itemExtent: 50.0,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("${index}"));
      },
    ),
  );
}

class ListViewFixedItemHeightDemo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView.builder(
      itemCount: 100,
      // 通过item模板，计算每个item的高度
      prototypeItem: ListTile(title: Text("0")),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("${index}"));
      },
    ),
  );
}

class ListViewDemo3 extends StatelessWidget {
  // 奇数索引 item 分割线
  final Widget oddIndexSeparatorLine = Expanded(
    child: Container(height: 2, color: Colors.blue),
  );

  // 偶数索引 item 分割线
  final Widget evenIndexSeparatorLine = Expanded(
    child: Container(height: 2, color: Colors.red),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView.separated(
      itemCount: 100,
      itemBuilder: (BuildContext context, int index) {
        return LayoutLogPrint(
          tag: index,
          child: ListTile(title: Text("$index")),
        );
      },
      separatorBuilder: (context, index) {
        var isOdd = index % 2 != 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isOdd ? oddIndexSeparatorLine : evenIndexSeparatorLine,
            Text(" ${isOdd ? "奇数索引 分割线" : "偶数索引 分割线"} "),
            isOdd ? oddIndexSeparatorLine : evenIndexSeparatorLine,
          ],
        );
      },
    ),
  );
}

class ListViewLoadMoreDemo4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListViewLoadMoreDemo4State();
}

class ListViewLoadMoreDemo4State extends State<ListViewLoadMoreDemo4> {
  final ScrollController scrollController = ScrollController();

  final String LAST_ITEM_TAG_DATA = "**load_more**";
  List<Object> datas = [];

  var isLoading = false;
  var hasNoMore = false;

  var loadingRotateRate = 0.0;
  Timer? loadingRotateTimer;

  void startLoadingMore() {
    if (hasNoMore) return;
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      // 追加假数据
      setState(() {
        datas.insertAll(datas.length - 1, List.generate(20, (index) => "商品"));
      });

      // 判断是否还有更多
      if (datas.length >= 60) {
        hasNoMore = true;
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        // 滑动到底部了
        startLoadingMore();
      }
    });

    Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        loadingRotateRate = loadingRotateRate + 0.02;
        if (loadingRotateRate > 1.0) {
          loadingRotateRate = 0;
        }
      });
    });

    datas.add(LAST_ITEM_TAG_DATA);
    startLoadingMore();
  }

  @override
  void dispose() {
    scrollController.dispose();
    loadingRotateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        ListTile(title: Text("商品列表")),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: datas.length,
            itemExtent: 50.0,
            itemBuilder: (BuildContext context, int index) {
              var isNormalData = datas[index] != LAST_ITEM_TAG_DATA;
              if (isNormalData) {
                return ListTile(
                  title: InfoText(
                    "${datas[index]} - ${datas[index].hashCode}(index:${index})",
                  ),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      hasNoMore
                          ? [Text("No more data")]
                          : ((isLoading && index != 0)
                              ? [
                                SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                ),
                                // Transform.rotate(
                                //   angle: 2 * pi * loadingRotateRate,
                                //   child: SvgPicture.asset("assets/image/loading.svg"),
                                // ),
                                Text(" Loading..."),
                              ]
                              : []),
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}
