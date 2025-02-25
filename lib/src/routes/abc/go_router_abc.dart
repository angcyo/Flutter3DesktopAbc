import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:go_router/go_router.dart';

import '../../router.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/26
///
/// https://pub.dev/packages/go_router
///
/// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
///
/// # 获取路径参数
/// ```
/// GoRoute(
///   path: '/users/:userId',
///   builder: (context, state) => const UserScreen(id: state.pathParameters['userId']),
/// ),
/// ```
///
/// # 获取查询参数
/// `/users?filter=admins`
/// ```
/// GoRoute(
///   path: '/users',
///   builder: (context, state) => const UsersScreen(filter: state.uri.queryParameters['filter']),
/// ),
/// ```
///
class GoRouterAbc extends StatefulWidget {
  const GoRouterAbc({super.key});

  @override
  State<GoRouterAbc> createState() => _GoRouterAbcState();
}

class _GoRouterAbcState extends State<GoRouterAbc> {
  int buildCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    //debugger();
    final goRouter = context.goRouter;
    final goRouterStateOrNull = context.goRouterStateOrNull;
    final currentConfiguration = goRouter.routerDelegate.currentConfiguration;

    //获取路径参数:
    //currentConfiguration.pathParameters

    //获取查询参数:
    //currentConfiguration.uri.queryParameters

    return [
      textSpanBuilder((builder) {
        builder.addText("${nowTimeString()}->${buildCount++}");
        builder.newLine();
        builder.addText("当Modal前路由->${parentRoute?.settings} :$parentRoute");
        builder.newLine();
        builder.addText(
            "当前Go路由->${goRouterStateOrNull?.uri} topRoute:${goRouterStateOrNull?.topRoute}");
        builder.newLine();
        builder.newLine();
        builder.addText("currentConfiguration->$currentConfiguration");
        builder.newLine();
        builder.newLine();
        builder.addText(
            "currentConfiguration.matches->${currentConfiguration.matches}");
        builder.newLine();

        for (final match in currentConfiguration.matches) {
          builder.addText("match->${match.matchedLocation} :$match");
          builder.newLine();
          if (match is ShellRouteMatch) {
            final route = match.route;
            /*builder.addText(" ShellRoute->$route");
            builder.newLine();*/
            if (route is ShellRoute) {
              for (final route in route.routes) {
                if (route is GoRoute) {
                  builder.addText(" GoRoute->${route.path} :$route");
                  builder.newLine();
                }
              }
            }
          } else if (match is RouteMatch) {
            final route = match.route;
            builder.addText(" GoRoute->${route.path} :$route");
            builder.newLine();
          }
        }
      }),
      /*_buildLeadingButton(context),*/
      [
        GradientButton(
          child: "go".text(),
          onTap: () {
            buildContext?.go("/basics");
          },
        ),
        GradientButton(
          child: "go this".text(),
          onTap: () {
            buildContext?.go("/go_router");
          },
        ),
        GradientButton(
          child: "push route".text(),
          onTap: () {
            buildContext?.pushWidget(GoRouterAbc());
          },
        ),
        GradientButton(
          child: "push route with root".text(),
          onTap: () {
            buildContext?.pushWidget(BasicsAbc(), rootNavigator: true);
          },
        ),
        GradientButton(
          child: "push route(root)".text(),
          onTap: () {
            rootGoRouterNavigatorKey.currentState?.push(BasicsAbc().toRoute());
          },
        ),
        GradientButton(
          child: "push route(shell)".text(),
          onTap: () {
            shellGoRouterNavigatorKey.currentState?.push(BasicsAbc().toRoute());
          },
        ),
      ]
          .flowLayout(padding: edgeOnly(all: kX), childGap: kX)
          ?.matchParentWidth(),
    ].scroll(axis: Axis.vertical)!;
  }
}
