import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

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

class _MainPageState extends State<MainPage>
    with ScrollObserverMixin, WindowListener, WindowListenerMixin {
  /// 导航栏宽度
  double _navigationWidth = 300.0;
  final kTitleHeight = kMinInteractiveDimension;

  List<AbcRouteConfig> get abcRouteList => widget.abcRouteList;

  @override
  bool get enableConfirmClose => true;

  @override
  void initState() {
    super.initState();
    _jumpToTarget(null, true);
  }

  @override
  void onSelfWindowSizeChanged() {
    l.i("onSelfWindowSizeChanged->$windowSizeMixin");
    final wm = windowSizeMixin?.width ?? 0;
    if (wm >= 1200) {
      _navigationWidth = 400.0;
    } else {
      _navigationWidth = 300.0;
    }
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    //debugger();
    return constrainLayout(() {
      //顶部标题
      _buildTitleBarWidget(context).applyConstraint(
        left: parent.left,
        top: parent.top,
        right: parent.right,
        width: matchConstraint,
        height: kTitleHeight,
      );
      //左边导航
      _buildNavigationWidget(context).applyConstraint(
        left: parent.left,
        top: sId(-1).bottom,
        bottom: parent.bottom,
        width: _navigationWidth,
        height: matchConstraint,
      );
      //内容区域
      _buildContentWidget(context, widget.body).applyConstraint(
        left: sId(-1).right,
        top: sId(-1).top,
        right: parent.right,
        bottom: parent.bottom,
        width: matchConstraint,
        height: matchConstraint,
      );
    }).backgroundColor(globalTheme.surfaceBgColor);
  }

  //--

  /// 构建标题小部件
  Widget _buildTitleBarWidget(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    /*return DragToMoveArea(
      child: [
        "title".text(),
      ].row()!,
    );*/
    return WindowCaption(
      brightness: globalTheme.accentBrightness,
      title: [
        _buildLeadingButton(context),
        "Flutter3DesktopAbc - ${context.goRouterState.uri}".text()
      ].row(),
    );
  }

  /// Builds the app bar leading button using the current location [Uri].
  ///
  /// The [Scaffold]'s default back button cannot be used because it doesn't
  /// have the context of the current child.
  ///
  /// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/shell_route_top_route.dart
  Widget? _buildLeadingButton(BuildContext context) {
    final bool canPop = context.goRouterCanPop;
    return canPop ? BackButton(onPressed: GoRouter.of(context).pop) : null;
  }

  //--

  /// 构建导航小部件
  Widget _buildNavigationWidget(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    final routeList = abcRouteList.filter((e) => !isNil(e.$2));
    return buildObserverCustomScrollView(context, [
      buildObserverSliverListBuilder(context, (context, index) {
        final abcConfig = routeList.getOrNull(index);
        if (abcConfig == null) {
          return null;
        }
        l.d("build abc item[$index]:${abcConfig.$1}");
        //debugger();
        const size = 24.0;
        Widget? result = ListTile(
          leading: SizedBox(
              width: size,
              height: size,
              child: loadAssetImageWidget("assets/png/flutter.png"
                  .ensurePackagePrefix("flutter3_abc"))),
          title: Text('${index + 1}.${abcConfig.$2}'),
          hoverColor: globalTheme.accentColor.withHoverAlphaColor,
          selectedTileColor: globalTheme.accentColor,
          selected: "/${context.goRouterState.uri.pathSegments.firstOrNull}" ==
              abcConfig.$1,
          onTap: () {
            //l.d("...$index");
            //Navigator.pushNamed(context, '/abc/$index');
            //Navigator.push(context, '/abc/$index');
            _jumpToTarget(abcConfig.$1);
          },
        ).material();
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
      }),
      //底部显示
      SliverFillRemaining(
        hasScrollBody: false,
        fillOverscroll: false,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: AppTest.buildBottomWidget(context),
        ),
      ),
    ]);
  }

  /// 上一次跳转的路由路径
  String? _lastJumpPath;

  /// 跳转到目标页面
  void _jumpToTarget([String? targetPath, bool? scrollToIndex]) {
    String? goKey = targetPath;
    int? scrollIndex;
    if (goKey != null) {
      //指定跳转
    } else if (_lastJumpPath != null) {
      goKey = _lastJumpPath;
    } else {
      int index = -1;
      for (AbcRouteConfig config in abcRouteList) {
        if (config.$2?.contains(kGo) == true) {
          goKey = config.$1;
          scrollIndex = index;
          if (goFirst) {
            break;
          }
        }
        index++;
      }
    }
    //goKey ??= _abcKeyList.lastOrNull;
    if (goKey?.isNotEmpty == true) {
      _lastJumpPath = goKey;
      postDelayCallback(() {
        context.go(goKey!);
        if (scrollIndex != null && scrollToIndex == true) {
          scrollObserverTo(scrollIndex, duration: null);
        }
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
