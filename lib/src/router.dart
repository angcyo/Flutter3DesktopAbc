import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

import 'routes/abc/canvas_desktop_abc.dart';
import 'routes/abc/drop_file_abc.dart';
import 'routes/abc/go_router_abc.dart';
import 'routes/abc/start_abc.dart';
import 'routes/abc/test_abc.dart';
import 'routes/abc/window_manager_abc.dart';
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
/// abc页面路由
final flutter3DesktopAbcRoutes = <AbcRouteConfig>[
  ("/", null, (context) => const StartAbc()),
  ...flutter3AbcRoutes,
  (
    "/windowManager",
    "WindowManagerAbc $kGo",
    (context) => const WindowManagerAbc()
  ),
  (
    "/canvasDesktop",
    'CanvasDesktopAbc ',
    (context) => const CanvasDesktopAbc()
  ),
  ("/go_router", "GoRouterAbc", (context) => const GoRouterAbc()),
  ("/dragFile", "DragFileAbc", (context) => const DropFileAbc()),
  ("/test", "TestAbc", (context) => const TestAbc()),
];

/// 路由配置
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
          abcRouteList: flutter3DesktopAbcRoutes, //abcRouteList,
          body: child,
        ).material();
      },
      routes: flutter3DesktopAbcRoutes
          .map((e) => GoRoute(
                path: e.$1,
                name: e.$2,
                pageBuilder: (context, state) {
                  //debugger();
                  final child = e.$3(context);
                  final route = child.toRoute(type: TranslationType.zoom);
                  return CustomTransitionPage(
                      key: state.pageKey,
                      child: child,
                      transitionsBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child,
                      ) {
                        //l.d("[${child.hash()}]animation:$animation");
                        //l.v("[${child.hash()}]secondaryAnimation:$secondaryAnimation");
                        return route.buildTransitions(
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        );
                        /*return ZoomPageTransitionsBuilder().buildTransitions(
                          context.pageRoute!,
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        );*/
                      });
                },
              ))
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

/// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
final GlobalKey<NavigatorState> rootGoRouterNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'GoRouter_root');
final GlobalKey<NavigatorState> shellGoRouterNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'GoRouter_shell');

/// 是否执行第一个/否则执行最后一个
const goFirst = false;
