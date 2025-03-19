import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:base_project_flutter/widget/dev.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

// ============================ 列表组件示例 =====================================
/**
 *  ListView：
 *    对于保存滚动位置：
 *      - 需要配置key和keepScrollOffset属性(在controller里)
 *      - ListView 需要写在StatefulWidget中，且在 PageView 或 IndexedStack 里 恢复时才生效
 *        如果通过Navigator.push加载（等于是重新加载），将不会保存滚动位置及状态
 *      - （可以查看Demo5中配置，单但因为本示例是通过Navigator.push加载，不会保存上次滚动状态。配置代码可做参考）
 *  AnimatedList：
 *    AnimatedList是StatefulWidget，可以通过key拿到其State，从而进行动画操作
 *
 *  动画：
 *    可以通过嵌套的方式，同时实现多个动画效果，如：
 *    ScaleTransition( // 缩放
 *      scale: [animationValue],
 *      child: FadeTransition( // 渐变
 *        opacity: [animationValue],
 *        child: MyWidget(),
 *      ),
 *    )
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
              routeButton("ListView\n回到顶部", ListViewBackToTopDemo5()),
              routeButton("AnimatedList\n实现item删除动画效果", AnimatedListDemo6()),
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

class ListViewBackToTopDemo5 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListViewBackToTopDemo5State();
}

class ListViewBackToTopDemo5State extends State<ListViewBackToTopDemo5>
    with AfterLayoutMixin<ListViewBackToTopDemo5> {
  final scrollController = ScrollController(keepScrollOffset: true);
  var showBackTopBtn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    scrollController.addListener(() {
      var showUpBtn =
          scrollController.offset > MediaQuery.of(context).size.height;
      if (showBackTopBtn != showUpBtn) {
        setState(() {
          showBackTopBtn = showUpBtn;
        });
      }
    });
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView.builder(
      // 注：本示例通过 Navigator.push 加载，这里的PageStorageKey不会生效（代码仅作参考）
      key: PageStorageKey('list_key_1'),
      controller: scrollController,
      itemBuilder: (context, index) {
        return ListTile(title: Text("index - ${index}"));
      },
    ),
    floatingActionButton:
        showBackTopBtn
            ? Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(1080)),
              ),
              child: IconButton(
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    showBackTopBtn = false;
                  });
                },
                icon: Icon(Icons.arrow_upward_sharp),
                color: Colors.white,
              ),
            )
            : null,
  );
}

class AnimatedListDemo6 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AnimatedListDemo6State();
}

class AnimatedListDemo6State extends State<AnimatedListDemo6> {
  final datas = <String>[];
  final animatedListKey = GlobalKey<AnimatedListState>();
  var itemId = 0;

  @override
  void initState() {
    setState(() {
      datas.addAll(List.generate(5, (index) => "${++itemId}"));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        Expanded(
          child: AnimatedList(
            key: animatedListKey,
            initialItemCount: datas.length,
            itemBuilder: (context, index, animation) {
              return buildItem(context, index, animation);
            },
          ),
        ),
        paddingBottom(
          20,
          child: FloatingActionButton(
            onPressed: () {
              onAdd(context);
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    ),
  );

  Widget buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    var itemWidget = ListTile(
      key: ValueKey(datas[index]),
      title: Text("itemId - ${datas[index]}"),
      trailing: IconButton(
        onPressed: () {
          onDelete(context, index);
        },
        icon: Icon(Icons.delete),
      ),
    );

    // 这里用嵌套的方式实现多个动画效果 （缩放 + 渐变）
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(opacity: animation, child: itemWidget),
    );
  }

  void onAdd(BuildContext context) {
    var insertIndex = (datas.length / 2).toInt();
    // // 先插入数据
    datas.insert(insertIndex, "${++itemId}");
    // // 使用 AnimatedList的state 去更新数据，而不是调用 setState((){...})
    animatedListKey.currentState!.insertItem(
      insertIndex,
      duration: Duration(milliseconds: 1000),
    );
    Fluttertoast.showToast(msg: "新增${insertIndex} - ${itemId}");
  }

  void onDelete(BuildContext context, int index) {
    animatedListKey.currentState!.removeItem(
      index,
      duration: Duration(milliseconds: 1000),
      (context, animation) => buildItem(context, index, animation),
    );
  }
}
