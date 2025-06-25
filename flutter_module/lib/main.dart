import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print("receive a flutter error. data = $details");
  };

  ///这里的CustomFlutterBinding调用务必不可缺少，用于控制Boost状态的resume和pause
  CustomFlutterBinding();
  runApp(const MyApp());
}

///创建一个自定义的Binding，继承和with的关系如下，里面什么都不用写
class CustomFlutterBinding extends WidgetsFlutterBinding with BoostFlutterBinding {}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 由于很多同学说没有跳转动画，这里是因为之前exmaple里面用的是 [PageRouteBuilder]，
  /// 其实这里是可以自定义的，和Boost没太多关系，比如我想用类似iOS平台的动画，
  /// 那么只需要像下面这样写成 [CupertinoPageRoute] 即可
  /// (这里全写成[MaterialPageRoute]也行，这里只不过用[CupertinoPageRoute]举例子)
  ///
  /// 注意，如果需要push的时候，两个页面都需要动的话，
  /// （就是像iOS native那样，在push的时候，前面一个页面也会向左推一段距离）
  /// 那么前后两个页面都必须是遵循CupertinoRouteTransitionMixin的路由
  /// 简单来说，就两个页面都是CupertinoPageRoute就好
  /// 如果用MaterialPageRoute的话同理

  Map<String, FlutterBoostRouteFactory> routerMap = {
    'mainPage': (settings, isContainerPage, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
            String data = map['data'] as String;
            return MainPage(
              data: data,
            );
          });
    },
    'simplePage': (settings, isContainerPage, uniqueId) {
      return CupertinoPageRoute(
          settings: settings,
          builder: (_) {
            Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
            String data = map['data'] as String;
            return SimplePage(
              data: data,
            );
          });
    },
  };

  Route<dynamic>? routeFactory(RouteSettings settings, bool isContainerPage, String? uniqueId) {
    FlutterBoostRouteFactory? factory = routerMap[settings.name];
    if (factory == null) {
      //调用 BoostNavigator.instance.push() 从Flutter启动原生 activity时，此时 factory 为 null，需要返回 null
      return null;
    }
    return factory(settings, isContainerPage, uniqueId);
  }

  Widget appBuilder(Widget home) {
    return MaterialApp(
      home: home,
      debugShowCheckedModeBanner: true,

      ///必须加上builder参数，否则showDialog等会出问题
      builder: (_, __) {
        return home;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
    );
  }
}

class MainPage extends StatelessWidget {
  final Object data;

  const MainPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Main Page: $data'),
          const SizedBox(height: 80),
          GestureDetector(
            onTap: () {
              BoostNavigator.instance.pop({"data": "Flutter result callback..."});
            },
            child: const Text(
              '返回上一个原生页面并携带数据',
              style: TextStyle(backgroundColor: Colors.green),
            ),
          )
        ],
      )),
    );
  }
}

class SimplePage extends StatefulWidget {
  final Object data;

  const SimplePage({super.key, required this.data});

  @override
  State createState() {
    return _SimplePageState(data: data);
  }
}

class _SimplePageState extends State<SimplePage> {
  final Object data;
  String content = "空";
  VoidCallback? removeListener;

  _SimplePageState({required this.data});

  @override
  void initState() {
    super.initState();

    // ///添加事件响应者,监听native发往flutter端的事件
    // removeListener = BoostChannel.instance.addEventListener("eventToFlutter", (key, arguments) {
    //   Logger.error("我是测试的log.....接收 eventToFlutter 事件...... arguments = $arguments");
    //   setState(() {
    //     content = arguments.toString();
    //   });
    //   return Future.value(true);
    // });
  }

  @override
  void dispose() {
    super.dispose();

    ///然后在退出的时候（比如dispose中）移除监听者
    removeListener?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'SimplePage, $data',
          style: const TextStyle(fontSize: 15),
        )),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Text('跳转至原生界面', style: TextStyle(backgroundColor: Colors.red)),
              onTap: () {
                BoostNavigator.instance
                    .push("native_test", arguments: {"data": "我是Flutter层的数据"}).then((value) {
                  Logger.error("我是测试的log........... value = $value");
                  setState(() {
                    content = value.toString();
                  });
                });
              },
            ),
            const SizedBox(height: 80),
            Text(
              '上一个原生页面返回的数据：$content',
              style: const TextStyle(color: Colors.blue),
            )
          ],
        )));
  }
}
