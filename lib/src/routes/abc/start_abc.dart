import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/26
///
class StartAbc extends StatefulWidget {
  const StartAbc({super.key});

  @override
  State<StartAbc> createState() => _StartAbcState();
}

class _StartAbcState extends State<StartAbc> {
  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return "${nowTimeString()}\n请点击左边的导航进入..."
        .text(textAlign: TextAlign.center, style: globalTheme.textGeneralStyle)
        .center();
  }
}
