import 'package:flutter/material.dart';
import 'package:flutter3_desktop_abc/src/desktop_app.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_module/lp_module.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @since 2024-12-25
///
@pragma("vm:entry-point", "call")
void main() async {
  //await initWindow(size: Size(1280, 720));
  //runApp(const DesktopApp());
  runGlobalApp(const DesktopApp(), beforeAction: () async {
    await initWindow(size: Size(1280, 720));

    initLpModule();
  });
}
