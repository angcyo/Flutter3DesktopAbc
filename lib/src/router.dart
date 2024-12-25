import 'dart:developer';

import 'package:flutter3_desktop_abc/src/routes/home_page.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:go_router/go_router.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/25
///
/// 路由
/// GoRouter configuration
///
/// https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html
///
/// [RouterConfig]
final router = GoRouter(
  //初始化的路由
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        debugger();
        return HomePage(title: 'Flutter Desktop Demo Home Page');
      },
    ),
  ],
  //--
  //路由重定向
  redirect: (context, state) {
    state.uri;
    state.matchedLocation;
    debugger();
    return null;
  },
  //异常, 比如没有找到指定的路由
  onException: (context, state, router) {
    debugger();
  },
  errorBuilder: (context, state){
    return empty;
  }
);
