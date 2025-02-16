import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/lp_canvas.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/02/14
///
/// Canvas Desktop 主菜单路由
class CanvasDesktopMainMenuRoute extends StatefulWidget {
  const CanvasDesktopMainMenuRoute({super.key});

  @override
  State<CanvasDesktopMainMenuRoute> createState() =>
      _CanvasDesktopMainMenuRouteState();
}

class _CanvasDesktopMainMenuRouteState
    extends State<CanvasDesktopMainMenuRoute> {
  @override
  Widget build(BuildContext context) {
    return [
      MenuItemButton(
        onPressed: () {
          toastInfo("设置...");
        },
        child: "设置...".text(),
      ).popMenu(),
      MenuItemButton(
        onPressed: () {
          toastInfo("关于${$appBuildVersionCache}...");
        },
        child: "关于 ${$appBuildVersionCache}...".text(),
      ).popMenu(),
      MenuItemButton(
        onPressed: () {
          toastInfo("测试...${test()}");
        },
        child: "测试...".text(),
      ).popMenu(),
    ].scrollVertical()!.constrained(minWidth: 240).iw();
  }
}
