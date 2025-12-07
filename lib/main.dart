import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_module/lp_module.dart';

import 'src/desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @since 2024-12-25
///
@pragma("vm:entry-point", "call")
void main([List<String>? args]) async {
  //await initWindow(size: Size(1280, 720));
  //runApp(const DesktopApp());
  runGlobalApp(
    const DesktopApp().wrapAboutDialog(),
    beforeAction: () async {
      /*GlobalConfig.def.openUrlFn = (context, url, meta) {
      context?.openSingleWebView(url);
      return Future.value(true);
    };*/

      await initDesktopApp();
      await initWindow(size: Size(1280, 720));
      //lp
      await initLpModule();
      //--
      SvgBuilder.customSvgHeaderAnnotation = null;
    },
  );
}
