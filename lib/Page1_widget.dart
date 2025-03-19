import 'package:flutter/material.dart';

class Page1_widget extends StatefulWidget {
  const Page1_widget({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Page1_widget> createState() => _Page1_widgetState();
}

class KeysHolder {
  static GlobalKey<ScaffoldState> scaffold = GlobalKey();
}

class _Page1_widgetState extends State<Page1_widget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // 对setState的调用告诉Flutter框架这个状态发生了变化，
      // 这会导致它重新运行下面的构建方法，以便显示可以反映更新的值。
      // 如果我们在不调用setState（）的情况下更改_counter，
      // 那么构建方法将不会被再次调用，因此不会发生任何事情。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 每次调用setState时都会重新运行这个方法，例如上面的_incrementCounter方法。
    // Flutter框架经过了优化，可以快速运行构建方法，这样您就可以重新构建任何需要更新的内容，而不必单独更改小部件的实例。
    return Scaffold(
      key: KeysHolder.scaffold,
      appBar: AppBar(
        // 试试这个：尝试将这里的颜色更改为特定的颜色（到Colors）。琥珀色)，并触发热重新加载，
        // 看到AppBar的颜色改变，而其他颜色保持不变。
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // 这里，我们从App.build方法创建的MyHomePage对象中获取值，并使用它来设置appbar标题。
        title: Text(widget.title /*注意这个title是个Widget组件，不是字符串*/),
      ),
      body: Center(
        // Center是一个布局小部件。它接受一个子元素，并将其放置在父元素的中间。
        child: Column(
          // Column也是一个布局小部件。它获取一个子列表并垂直排列它们。
          // 默认情况下，它调整自己的大小以水平地适合它的子元素，并尝试与父元素一样高。
          //
          // 列有各种属性来控制它如何调整自身大小以及如何定位其子元素。
          // 这里我们使用mainAxisAlignment来垂直居中子元素；这里的主轴是垂直轴，因为列是垂直的（交叉轴是水平的）。
          //
          // 试试这个：调用“调试绘画”（在IDE中选择“切换调试绘画”操作，或在控制台中按“p”），查看每个小部件的线框。
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Echo(text: "test: print text, successfully!"),
            FindAncestor<Scaffold>(),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            StatefulCounter(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // 末尾的逗号使构建方法的自动格式化更好。
      drawer: Drawer(),
    );
  }
}

// ===============================  无状态Widget（StatelessWidget） =====================================
class Echo extends StatelessWidget {
  final String text;
  final Color bgColor;

  const Echo({Key? key, required this.text, this.bgColor = Colors.transparent})
    : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Center(child: Container(color: bgColor, child: Text(text)));
}

// 查找父组件State的方式
class FindAncestor<T extends Widget> extends StatelessWidget {
  FindAncestor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      // 1. 通过findAncestorStateOfType
      // context.findAncestorStateOfType<ScaffoldState>()?.openDrawer();

      // 2. 通过自定义Key
      KeysHolder.scaffold.currentState?.openDrawer();

      // 3. 通过组件的 of 静态方法（常用。约定：有of方法表示组件本身愿意暴露State）
      // Scaffold.of(context).openDrawer();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("我是SnackBar")));
    },
    child: Text(
      "find ancestor ${context.findAncestorWidgetOfExactType<T>().runtimeType}",
    ),
  );
}

// ===============================  有状态Widget（StatefulWidget） =====================================
class StatefulCounter extends StatefulWidget {
  int initialCount;

  StatefulCounter({Key? key, this.initialCount = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatefulCounterState();
}

class StatefulCounterState extends State<StatefulCounter> {
  var count = 0;

  void changeCount(count) => setState(() {
    this.count = count;
  });

  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
    print("initState");
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text("count:${count}"),
      TextButton(
        onPressed: () {
          changeCount(count - 1);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text("-"),
        ),
      ),
      TextButton(
        onPressed: () {
          changeCount(count + 1);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text("+"),
        ),
      ),
    ],
  );

  @override
  void didUpdateWidget(covariant StatefulCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactivate");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}
