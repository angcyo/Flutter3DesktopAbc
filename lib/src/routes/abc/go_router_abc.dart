import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter3_desktop_abc/src/app/go_router_ex.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:go_router/go_router.dart';

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
    final goRouter = context.goRouter;
    final goRouterState = context.goRouterState;
    goRouter.routerDelegate.currentConfiguration;

    return [
      textSpanBuilder((builder) {
        builder.addText("当前路由Uri->${goRouterState.uri}");
        builder.newLine();
        builder.addText(
            "currentConfiguration->${goRouter.routerDelegate.currentConfiguration}");
      }),
      /*_buildLeadingButton(context),*/
    ].scroll(axis: Axis.vertical)!;
  }
}
