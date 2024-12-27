import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// Email:angcyo@126.com
/// @author angcyo
/// @date 2024/12/27
///
class TestAbc extends StatefulWidget {
  const TestAbc({super.key});

  @override
  State<TestAbc> createState() => _TestAbcState();
}

class _TestAbcState extends State<TestAbc> {
  dynamic mouseEvent;

  @override
  Widget build(BuildContext context) {
    return "$mouseEvent".text().center().mouse(
      onEnter: (event) {
        //debugger();
        l.d(event);
        mouseEvent = event;
        updateState();
      },
      onExit: (event) {
        l.d(event);
        mouseEvent = event;
        updateState();
      },
      onHover: (event) {
        l.d(event);
        mouseEvent = event;
        updateState();
      },
    );
  }
}
