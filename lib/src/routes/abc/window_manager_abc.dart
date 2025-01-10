import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/10
///
class WindowManagerAbc extends StatefulWidget {
  const WindowManagerAbc({super.key});

  @override
  State<WindowManagerAbc> createState() => _WindowManagerAbcState();
}

class _WindowManagerAbcState extends State<WindowManagerAbc>
    with
        BaseAbcStateMixin,
        AppLifecycleMixin,
        WindowListener,
        WindowListenerMixin,
        TileMixin {
  final _wmInfoSignal = $signal();
  double _progress = 0.0;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _updateWindowInfo();
  }

  @override
  void reassemble() {
    super.reassemble();
    _updateWindowInfo();
  }

  _updateWindowInfo() async {
    _wmInfoSignal.value = "窗口边界:${await $wm.getBounds()}\n"
        "窗口大小:${await $wm.getSize()} 位置:${await $wm.getPosition()}"
        "焦点:${(await $wm.isFocused()).dc} 是否全屏:${(await $wm.isFullScreen()).dc} 置顶:${(await $wm.isAlwaysOnTop()).dc}";
  }

  @override
  WidgetList buildBodyList(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      _wmInfoSignal.buildFn(() => "${_wmInfoSignal.value ?? ""}".text()),
      [
        "physicalSize:${flutterView.physicalSize} sw:$screenWidth sh:$screenHeight"
            .text(),
        GradientButton.normal(
          () {
            $wm.setFullScreen(true);
          },
          child: "全屏".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setFullScreen(false);
          },
          child: "退出全屏".text(),
        ),
        GradientButton.normal(
          () {
            $wm.center(animate: true);
          },
          child: "居中显示".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setAlwaysOnTop(true);
            _updateWindowInfo();
          },
          child: "置顶".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setAlwaysOnTop(false);
            _updateWindowInfo();
          },
          child: "取消置顶".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setTitle("新标题->${nowTimeString()}");
          },
          child: "设置标题".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setTitleBarStyle(TitleBarStyle.hidden);
          },
          child: "设置标题样式(hidden)".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setTitleBarStyle(TitleBarStyle.normal);
          },
          child: "设置标题样式(normal)".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setTitleBarStyle(TitleBarStyle.normal,
                windowButtonVisibility: false);
          },
          child: "隐藏标题按钮".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setTitleBarStyle(TitleBarStyle.normal,
                windowButtonVisibility: true);
          },
          child: "显示标题按钮".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setSkipTaskbar(true);
          },
          child: "隐藏任务栏按钮".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setSkipTaskbar(false);
          },
          child: "显示任务栏按钮".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setBrightness(Brightness.dark);
          },
          child: "dark".text(),
        ),
        GradientButton.normal(
          () {
            $wm.setBrightness(Brightness.light);
          },
          child: "light".text(),
        ),
      ].flowLayout(padding: kXInsets, childGap: kX)!,
      SliderTile(
        leadingWidget: "任务栏进度".text(),
        value: _progress,
        onChanged: (value) {
          //任务栏进度条
          _progress = value;
          $wm.setProgressBar(value);
          updateState();
        },
      ),
      SliderTile(
        leadingWidget: "窗口透明度".text(),
        value: _opacity,
        onChanged: (value) {
          //任务栏进度条
          _opacity = value;
          $wm.setOpacity(1 - value);
          updateState();
        },
      ),
    ];
  }

  //--

  @override
  void onAppChangeMetrics() {
    super.onAppChangeMetrics();
    _updateWindowInfo();
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();
    _updateWindowInfo();
  }

  @override
  void onWindowMove() {
    super.onWindowMove();
    _updateWindowInfo();
  }

  @override
  void onWindowBlur() {
    super.onWindowBlur();
    _updateWindowInfo();
  }
}
