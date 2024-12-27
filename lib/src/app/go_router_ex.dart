import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/27
///
/// [GoRouterHelper]
extension GoRouterEx on BuildContext {
  /// 整体路由的控制
  /// [RouterConfig]->[GoRouter]
  /// [GoRouter.routerDelegate]
  /// [GoRouter.go]
  GoRouter get goRouter => GoRouter.of(this);

  /// 当路由的状态
  /// [GoRouterState]
  GoRouterState get goRouterState => GoRouterState.of(this);
}
