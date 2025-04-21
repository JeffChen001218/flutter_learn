import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:base_project_flutter/widget/Paddings.dart';
import 'package:base_project_flutter/widget/Sliver.dart';
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
 *
 *  子页面缓存：（本例全部不生效，暂未找到原因:(）
 *     方法1：PageView 构造函数 设置allowImplicitScrolling参数为true：实现作前后各缓存一个页面
 *     方法2：PageView 子项 继承AutomaticKeepAliveClientMixin：覆写wantKeepAlive方法，当的返回值为true，可以实现子页面的缓存
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
              routeButton("GridView\n宫格布局", GridListDemo7()),
              routeButton(
                "TabBar和PageView\n实现页面切换（其实使用TabBar和TabBarView组合更简单，可以共用同一个controller，不需要两者互相监听同步自己的索引变化）",
                PageViewDemo8(),
              ),
              routeButton(
                "CustomScrollView\n实现相邻两个列表滑动到末尾后，手势衔接（原理：使用公共的Scrollable和Viewport组合多个sliver）",
                CustomScrollViewDemo9(),
              ),
              routeButton(
                "吸顶Sliver示例（SliverAppBar和自定义SliverPersistentHeaderDelegate）",
                SliverDemo10(),
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

class GridListDemo7 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GridListDemo7State();
}

class GridListDemo7State extends State<GridListDemo7> {
  final _children = [
    Container(color: Colors.blue, child: Icon(Icons.ac_unit)),
    Container(color: Colors.blue, child: Icon(Icons.airport_shuttle)),
    Container(color: Colors.blue, child: Icon(Icons.all_inclusive)),
    Container(color: Colors.blue, child: Icon(Icons.beach_access)),
    Container(color: Colors.blue, child: Icon(Icons.cake)),
    Container(color: Colors.blue, child: Icon(Icons.free_breakfast)),
    Container(color: Colors.blue, child: Icon(Icons.abc_sharp)),
    Container(color: Colors.blue, child: Icon(Icons.access_alarm)),
  ];

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        paddingTop(24),
        InfoText("=============== 固定数量 ==============="),
        InfoText(
          "GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: ...), ...)\n"
          "或 GridView.count(crossAxisCount: ...)",
        ),
        Container(
          color: Colors.amber,
          child: GridView(
            // 自适应高度
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            children: _children,
          ),
        ),
        InfoText("========== 设置item最大主轴方向长度，自动计算 =========="),
        InfoText(
          "GridView(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: ...), ...)\n"
          "或 GridView.extend(maxCrossAxisExtent: ...)",
        ),
        Container(
          color: Colors.amber,
          child: GridView(
            // 自适应高度
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            children: _children,
          ),
        ),
        InfoText("========== 构造器实现item（GridView.builder） =========="),
        InfoText(
          "通过 MediaQuery.removePadding(removeTop: true, ...)移除 GridView顶部的默认padding",
        ),
        Container(
          color: Colors.amber,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              // 自适应高度
              shrinkWrap: true,
              itemCount: 11,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 3 / 1,
              ),
              itemBuilder: (context, index) {
                return SizedBox.shrink(child: InfoText("index-${index}"));
              },
            ),
          ),
        ),
      ],
    ),
  );
}

class PageViewDemo8 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageViewDemo8State();
}

class PageViewDemo8State extends State<PageViewDemo8>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(
    // keepPage: true,
    initialPage: 0,
  );
  TabController? tabController = null;
  int _currentPage = 0;

  final List<PageData> _pages = [
    PageData(color: Colors.blue, icon: Icons.star, title: '第一页'),
    PageData(color: Colors.green, icon: Icons.favorite, title: '第二页'),
    PageData(color: Colors.orange, icon: Icons.thumb_up, title: '第三页'),
  ];

  @override
  void initState() {
    tabController = TabController(length: _pages.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int index) {
    tabController?.animateTo(
      index,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    if (_currentPage != index) {
      setState(() => _currentPage = index);
    }
  }

  @override
  Widget build(BuildContext context) => Material(
    child: Column(
      children: [
        paddingTop(30),
        TabBar(
          controller: tabController,
          tabs: [Tab(text: "Tab1"), Tab(text: "Tab2"), Tab(text: "Tab3")],
          onTap:
              (index) => {
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                ),
              },
        ),
        Expanded(
          // 此处，其实使用TabBarView更合适，可以直接服用controller，不需要两个controller同步切换索引
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _handlePageChanged,
            // allowImplicitScrolling: true,
            itemCount: _pages.length,
            itemBuilder: (context, index) => ItemPage(index, _pages[index]),
          ),
        ),
      ],
    ),
  );
}

class ItemPage extends StatefulWidget {
  int index;
  PageData pageData;

  ItemPage(this.index, this.pageData);

  @override
  State<StatefulWidget> createState() => ItemPageState();
}

class ItemPageState extends State<ItemPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build page ${widget.index}");
    return Container(
      color: widget.pageData.color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.pageData.icon, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              widget.pageData.title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PageData {
  final Color color;
  final IconData icon;
  final String title;

  const PageData({
    required this.color,
    required this.icon,
    required this.title,
  });
}

class CustomScrollViewDemo9 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomScrollViewDemo9State();
}

class CustomScrollViewDemo9State extends State<CustomScrollViewDemo9> {
  @override
  Widget build(BuildContext context) => Scaffold(
    // body: Column(
    //   children: [
    //     Expanded(
    //       child: ListView(
    //         children: List.generate(30, (index) => InfoText("列表1 - ${index}")),
    //       ),
    //     ),
    //     Divider(color: Colors.grey),
    //     Expanded(
    //       child: ListView(
    //         children: List.generate(
    //           30,
    //           (index) => InfoText(
    //             "列表2 - ${String.fromCharCode('a'.codeUnitAt(0) + index)}",
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
    body: CustomScrollView(
      slivers: [
        SliverFixedExtentList(
          itemExtent: 56,
          delegate: SliverChildBuilderDelegate(
            (context, index) => Text("列表1 - ${index}"),
            childCount: 20,
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 56,
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                Text("列表2 - ${String.fromCharCode('a'.codeUnitAt(0) + index)}"),
            childCount: 20,
          ),
        ),
      ],
    ),
  );
}

class SliverDemo10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
    child: CustomScrollView(
      slivers: <Widget>[
        // AppBar，包含一个导航栏.
        SliverAppBar(
          pinned: true, // 滑动到顶端时会固定住
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Demo'),
            background: Image.network(
              "https://picsum.photos/1200/900",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            //Grid
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Grid按两列显示
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              //创建子widget
              return Container(
                alignment: Alignment.center,
                color: Colors.cyan[100 * (index % 9)],
                child: Text('grid item $index'),
              );
            }, childCount: 20),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate.builder(
            extentMax: 60,
            extentMin: 30,
            child: Container(
              color: Colors.red,
              child: Center(child: Text("SliverPersistentHeader实现滑动到顶部吸附")),
            ),
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            //创建列表项
            return Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: Text('list item $index'),
            );
          }, childCount: 20),
        ),
      ],
    ),
  );
}
