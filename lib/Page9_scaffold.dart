import 'package:flutter/material.dart';

import 'main.dart';

// ============================ Scaffold组件示例 =====================================

class Page9_scaffold extends StatefulWidget {
  const Page9_scaffold({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePage9();
}

class StatePage9 extends State<Page9_scaffold> {
  var pageIndex = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    // do nothing ...
  }

  void changePageIndex(index) {
    // 动画跳转
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );

    // 无动画跳转
    // pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      // =================== 标题 ====================
      title: Row(
        children: [
          InfoText("这是"),
          Icon(Icons.android),
          InfoText("appBar的title"),
        ],
      ),
      // =================== 左侧导航按钮 ====================
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(Icons.dashboard), //自定义图标
              onPressed: () {
                // 打开抽屉菜单
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      // =================== 右侧操作按钮（列表） ====================
      actions: [
        IconButton(icon: Icon(Icons.share), onPressed: () {}),
        // IconButton(icon: Icon(Icons.accessibility), onPressed: () {}),
        // IconButton(icon: Icon(Icons.add_a_photo), onPressed: () {}),
      ],
    ),
    // =================== 抽屉 ====================
    drawer: MyDrawer(),
    // =================== 底部导航栏 ====================
    bottomNavigationBar: BottomAppBar(
      notchMargin: 5,
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              changePageIndex(0);
            },
          ),
          SizedBox(), // 占位，让悬浮按钮在中间打洞
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              changePageIndex(2);
            },
          ),
        ],
      ),
    ),
    // =================== 悬浮按钮 ====================
    floatingActionButton: Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(1080)),
      ),
      child: IconButton(
        onPressed: () {
          changePageIndex(1);
        },
        icon: Icon(Icons.add),
        color: Colors.white,
      ),
    ),
    // =================== 悬浮按钮 在 底部导航栏上打洞的位置 ====================
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // =================== body 展示内容区域 用PageView实现左右滑动 ====================
    body: PageView(
      controller: pageController,
      // allowImplicitScrolling: true,
      onPageChanged: (index) {
        setState(() {
          pageIndex = index; // 监听滑动，更新 BottomNavigationBar
        });
      },
      children: [
        Center(child: Page(0, "🏠 首页")),
        Center(child: Page(1, "📜 添加")),
        Center(child: Page(2, "🔍 发现")),
        Center(child: Page(3, "⭐ 收藏")),
      ],
    ),
  );
}

class Page extends StatefulWidget {
  int index;
  String text;

  Page(this.index, this.text);

  @override
  State<StatefulWidget> createState() => _PageState();
}

class _PageState extends State<Page> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print("build ${widget.index}");
    return Text(widget.text, style: TextStyle(fontSize: 24));
  }

  @override
  bool get wantKeepAlive => true;
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(color: Colors.amber),
    ),
  );
}
