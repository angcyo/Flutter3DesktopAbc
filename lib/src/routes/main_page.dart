import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:go_router/go_router.dart';

import '../router.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/25
///
/// 主要的页面
class MainPage extends StatefulWidget {
  final List<AbcRouteConfig> abcRouteList;
  final Widget? body;

  const MainPage({
    super.key,
    required this.abcRouteList,
    this.body,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final kNavigationWidth = 300.0;

  List<AbcRouteConfig> get abcRouteList => widget.abcRouteList;

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final globalTheme = GlobalTheme.of(context);
    //debugger();
    return constrainLayout(() {
      _buildNavigationWidget(context).applyConstraint(
        left: parent.left,
        top: parent.top,
        bottom: parent.bottom,
        width: kNavigationWidth,
        height: matchConstraint,
      );
      _buildContentWidget(context, widget.body).applyConstraint(
        left: sId(-1).right,
        top: parent.top,
        right: parent.right,
        bottom: parent.bottom,
        width: matchConstraint,
        height: matchConstraint,
      );
    }).backgroundColor(globalTheme.themeWhiteColor);
  }

  //--

  /// 构建导航小部件
  Widget _buildNavigationWidget(BuildContext context) {
    final routeList = abcRouteList.filter((e) => !isNil(e.$2));
    return CustomScrollView(
      slivers: [
        SliverList.builder(itemBuilder: (context, index) {
          final abcConfig = routeList.getOrNull(index);
          if (abcConfig == null) {
            return null;
          }
          l.d("build abc item[$index]:${abcConfig.$1}");
          const size = 24.0;
          Widget? result = ListTile(
              leading: SizedBox(
                  width: size,
                  height: size,
                  child: loadAssetImageWidget("assets/png/flutter.png")),
              title: Text('${index + 1}.${abcConfig.$2}'),
              onTap: () {
                //l.d("...$index");
                //Navigator.pushNamed(context, '/abc/$index');
                //Navigator.push(context, '/abc/$index');
                _jumpToTarget(abcConfig.$1);
              });
          result = Column(
            children: [
              result,
              const Divider(
                height: 0.5,
                thickness: 0.5,
              ),
            ],
          );
          return result;
        })
      ],
    );
  }

  /// 上一次跳转的路由路径
  String? _lastJumpPath;

  /// 跳转到目标页面
  void _jumpToTarget([String? targetPath]) {
    String? goKey = targetPath;
    if (goKey != null) {
      //指定跳转
    } else if (_lastJumpPath != null) {
      goKey = _lastJumpPath;
    } else {
      for (AbcRouteConfig config in abcRouteList) {
        if (config.$2?.contains(kGo) == true) {
          goKey = config.$1;
          if (goFirst) {
            break;
          }
        }
      }
    }
    //goKey ??= _abcKeyList.lastOrNull;
    if (goKey?.isNotEmpty == true) {
      _lastJumpPath = goKey;
      postDelayCallback(() {
        context.go(goKey!);
      });
    }
  }

  //--

  /// 构建内容小部件
  Widget _buildContentWidget(BuildContext context, Widget? body) {
    final globalTheme = GlobalTheme.of(context);
    return DecoratedBox(
      decoration: strokeDecoration(color: globalTheme.accentColor),
      child: body,
    );
  }
}
