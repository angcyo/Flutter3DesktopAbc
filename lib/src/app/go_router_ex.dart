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
  ///
  /// [GoRouterStateRegistryScope]
  GoRouterState get goRouterState => GoRouterState.of(this);

  /// 当前路由下, 是否可以返回[GoRouter.pop]
  /// [GoRouter.of(context).pop]
  bool get goRouterCanPop {
    final RouteMatchList currentConfiguration =
        goRouter.routerDelegate.currentConfiguration;
    final RouteMatch lastMatch = currentConfiguration.last;
    final Uri location = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches.uri
        : currentConfiguration.uri;
    final bool canPop = location.pathSegments.length > 1;
    return canPop;
  }
}
