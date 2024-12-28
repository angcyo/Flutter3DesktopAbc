import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_res/lp_res.dart';

import 'router.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/25
///
/// 入口小部件
class DesktopApp extends StatelessWidget {
  const DesktopApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final title = 'Flutter Desktop Demo';
    final themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      fontFamily: "menlo", //默认字体
    );

    GlobalConfig.def.globalThemeData = themeData;
    /*GlobalConfig.def.globalTheme = appColor;*/

    /*return MaterialApp(
      title: title,
      theme: themeData,
      home: const MyHomePage(title: 'Flutter Desktop Demo Home Page'),
    );*/

    //路由
    return MaterialApp.router(
      title: title,
      theme: themeData,
      routerConfig: router,
      //--
      localizationsDelegates: const [
        LPRes.delegate, // 必须
        LibRes.delegate, // 必须
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      //http://www.lingoes.net/en/translator/langcode.htm
      supportedLocales: [
        /*...LibRes.delegate.supportedLocales,*/ //可以不需要
        const Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      ],
    );
  }
}
