import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter3_desktop_abc/src/app/go_router_ex.dart';
import 'package:flutter3_desktop_abc/src/routes/abc/basics_abc.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:go_router/go_router.dart';

import '../../router.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/26
///
class GoRouterAbc extends StatefulWidget {
  const GoRouterAbc({super.key});

  @override
  State<GoRouterAbc> createState() => _GoRouterAbcState();
}

class _GoRouterAbcState extends State<GoRouterAbc> {
  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    debugger();
    final goRouter = context.goRouter;
    final goRouterState = context.goRouterState;
    final currentConfiguration = goRouter.routerDelegate.currentConfiguration;
    return [
      textSpanBuilder((builder) {
        builder.addText(
            "当前路由->${goRouterState.uri} topRoute:${goRouterState.topRoute}");
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
          child: "go route".text(),
          onTap: () {
            debugger();
            buildContext?.go("/basics");
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
            rootGoRouterNavigatorKey.currentState
                ?.push(GoRouterAbc().toRoute());
          },
        ),
        GradientButton(
          child: "push route(shell)".text(),
          onTap: () {
            shellGoRouterNavigatorKey.currentState
                ?.push(GoRouterAbc().toRoute());
          },
        ),
      ]
          .flowLayout(padding: edgeOnly(all: kX), childGap: kX)
          ?.matchParentWidth(),
    ].scroll(axis: Axis.vertical)!;
  }
}
