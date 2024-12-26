import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:go_router/go_router.dart';

import 'routes/abc/go_router_abc.dart';
import 'routes/abc/start_abc.dart';
import 'routes/main_page.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/25
///
/// 路由
///
/// # GoRouter configuration
/// https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html
///
/// # ShellRoute sample
/// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
/// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/shell_route.dart
///
///
/// [_CustomNavigatorState._updatePages]
///
/// [_CustomNavigatorState._buildPage]
/// [_CustomNavigatorState._buildPageForGoRoute]
/// [_CustomNavigatorState._buildErrorPage]
///
/// [RouterConfig]
/// [GoRouterState]
///
/// [GoRouterHelper]

/// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
final GlobalKey<NavigatorState> rootGoRouterNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'GoRouter_root');
final GlobalKey<NavigatorState> shellGoRouterNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'GoRouter_shell');

/// 标识需要执行的abc
const kGo = '√';

/// 是否执行第一个/否则执行最后一个
const goFirst = false;

typedef AbcRouteConfig = (String, String?, WidgetBuilder);

/// abc页面路由
final flutter3AbcRoutes = <AbcRouteConfig>[
  ("/", null, (context) => const StartAbc()),
  ("/go_router", "GoRouterAbc", (context) => const GoRouterAbc()),
  ("/basics", "BasicsAbc", (context) => const Text("abc")),
];

final router = GoRouter(
  //初始化的路由
  initialLocation: "/",
  navigatorKey: rootGoRouterNavigatorKey,
  //路由列表
  routes: [
    ShellRoute(
      navigatorKey: shellGoRouterNavigatorKey,
      builder: (context, state, child) {
        return MainPage(
          abcRouteList: flutter3AbcRoutes, //abcRouteList,
          body: child,
        ).material();
      },
      routes: flutter3AbcRoutes
          .map((e) => GoRoute(
              path: e.$1,
              name: e.$2,
              builder: (context, state) => e.$3(context)))
          .toList(),
    )
  ],
  //--
  //路由重定向
  redirect: (context, state) {
    state.uri;
    state.matchedLocation;
    //debugger();
    l.d("路由->${state.uri}");
    return null;
  },
  //异常, 比如没有找到指定的路由
  /*onException: (context, state, router) {
    debugger();
  },*/

  /// [_CustomNavigatorState._buildPlatformAdapterPage]
  /// [MaterialErrorScreen]
  /*errorBuilder: (context, state) {
    debugger();
    return state.error.toString().text().center().material();
  },*/
  /*errorPageBuilder:(context, state)=>pageBuilderForMaterialApp(),*/

  /// [RouteConfiguration._debugFullPathsFor]
  debugLogDiagnostics: isDebug,
);
