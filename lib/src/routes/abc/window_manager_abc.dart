import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

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
        AppLifecycleStateMixin,
        WindowListener,
        WindowListenerMixin,
        TileMixin,
        TrayListener,
        TrayListenerStateMixin {
  final _wmInfoSignal = $signal();
  double _progress = 0.0;
  double _opacity = 0.0;

  //--

  bool dark = true;
  Color color = Colors.purpleAccent.withHoverAlphaColor;

  //--

  final _resultSignal = $signal();

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

  void _updateWindowInfo() async {
    _wmInfoSignal.value = "鼠标位置:${await $wm.cursorScreenPoint}\n"
        "窗口边界:${await $wm.getBounds()}\n"
        "窗口大小:${await $wm.getSize()} 位置:${await $wm.getPosition()}"
        "焦点:${(await $wm.isFocused()).dc} 是否最大化:${(await $wm.isMaximized()).dc} 是否全屏:${(await $wm.isFullScreen()).dc} 置顶:${(await $wm.isAlwaysOnTop()).dc}"
        "\n\n主屏幕:${await $wm.primaryDisplay}\n\n"
        "屏幕列表:\n${(await $wm.allDisplay).connect("\n")}\n";
  }

  @override
  Widget buildAbc(BuildContext context) {
    return super.buildAbc(context).platformMenuBar([
      _buildPlatformMenu(),
      //--
      PlatformMenuItemGroup(members: [
        _buildPlatformMenu(),
      ]),
      PlatformMenuItemGroup(members: [
        _buildPlatformMenu(),
      ]),
    ]);
  }

  @override
  WidgetList buildBodyList(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      _wmInfoSignal
          .buildFn(() => "${_wmInfoSignal.value ?? ""}".text().click(() {
                "${_wmInfoSignal.value ?? ""}".copy();
                _updateWindowInfo();
              })),
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
      //--
      [
        /*SwitchListTile(
          value: dark,
          title: "dark".text(),
          onChanged: (value) {
            dark = value;
            updateState();
          },
        ),*/
        LabelSwitchTile(
          label: "dark",
          value: dark,
          onValueChanged: (value) {
            dark = value;
          },
        ).size(width: 140, height: 50),
        GradientButton.normal(
          () {
            Window.setEffect(
              effect: WindowEffect.transparent,
              color: color,
              dark: dark,
            );
          },
          child: "transparent".text(),
        ),
        GradientButton.normal(
          () {
            Window.setEffect(
              effect: WindowEffect.solid,
              color: color,
              dark: dark,
            );
          },
          child: "solid".text(),
        ),
        GradientButton.normal(
          () {
            Window.setEffect(
              effect: WindowEffect.aero,
              color: color,
              dark: dark,
            );
          },
          child: "aero".text(),
        ),
        GradientButton.normal(
          () {
            Window.setEffect(
              effect: WindowEffect.acrylic,
              color: color,
              dark: dark,
            );
          },
          child: "acrylic".text(),
        ),
        GradientButton.normal(
          () {
            Window.setEffect(
              effect: WindowEffect.mica,
              color: color,
              dark: dark,
            );
          },
          child: "mica".text(),
        ),
        GradientButton.normal(
          () {
            Window.setEffect(
              effect: WindowEffect.tabbed,
              color: color,
              dark: dark,
            );
          },
          child: "tabbed".text(),
        ),
      ].flowLayout(padding: kXInsets, childGap: kX)!,
      //--
      [
        GradientButton.normal(
          () async {
            final image = await captureScreenImage();
            writeClipboardImage(image);
          },
          child: "复制图片".text(),
        ),
        GradientButton.normal(
          () async {
            writeClipboardText("<br>${nowTimeString()}");
          },
          child: "复制文本".text(),
        ),
        GradientButton.normal(
          () async {
            writeClipboardHtmlText("<br>${nowTimeString()}");
          },
          child: "复制文本(html)".text(),
        ),
        GradientButton.normal(
          () async {
            final image = await readClipboardImage();
            _resultSignal.value = image;
          },
          child: "粘贴图片".text(),
        ),
        GradientButton.normal(
          () async {
            final text = await readClipboardText();
            _resultSignal.value = text;
          },
          child: "粘贴文本".text(),
        ),
        GradientButton.normal(
          () async {
            final uri = await readClipboardUri();
            _resultSignal.value = uri;
          },
          child: "粘贴Uri".text(),
        ),
        //--
        GradientButton.normal(
          () {
            toastInfo("click");
          },
          child: "本机上下文菜单".text(),
        ).contextMenu(actions: [
          MenuAction(
            title: "Title 1",
            image: MenuImage.icon(Icons.access_alarm),
            callback: () {
              toastInfo("Title 1");
            },
          ),
          MenuAction(
            title: "Title 2",
            state: MenuActionState.checkOn,
            activator: SingleActivator(
              LogicalKeyboardKey.keyA,
              control: true,
            ),
            callback: () {
              toastInfo("Title 2");
            },
          ),
          MenuAction(
            title: "Title 3",
            state: MenuActionState.checkMixed,
            attributes: MenuActionAttributes(destructive: true, disabled: true),
            callback: () {
              toastInfo("Title 3");
            },
          ),
          MenuAction(
            title: "Title 4",
            state: MenuActionState.radioOn,
            activator: SingleActivator(
              LogicalKeyboardKey.keyB,
              control: true,
              meta: true,
              shift: true,
              alt: true,
            ),
            callback: () {
              toastInfo("Title 4");
            },
          ),
          Menu(
            title: "Sub Menu",
            image: MenuImage.icon(Icons.search),
            children: [
              MenuAction(
                title: "Sub Title 1",
                state: MenuActionState.radioOn,
                activator: SingleActivator(
                  LogicalKeyboardKey.keyB,
                  control: true,
                  meta: true,
                  shift: true,
                  alt: true,
                ),
                callback: () {
                  toastInfo("Sub Title 4");
                },
              ),
            ],
          ),
        ]),
        GradientButton.normal(
          () {
            setSystemTray(
              isWindows ? 'assets/ico/app_icon.ico' : 'assets/ico/app_icon.png',
              title: "Title",
              tooltip: "Tooltip",
              menus: [
                MenuInfo(
                  label: "Label 1",
                  onClick: () {
                    toastInfo("Label 1");
                  },
                ),
                MenuInfo(
                  menuType: MenuInfoType.separator,
                  label: "Label 2",
                  onClick: () {
                    toastInfo("Label 2");
                  },
                ),
                MenuInfo(
                  menuType: MenuInfoType.checkbox,
                  label: "Label 3",
                  onClick: () {
                    toastInfo("Label 3");
                  },
                ),
              ],
            );
          },
          child: "设置系统托盘".text(),
        ),
        GradientButton.normal(
          () {
            setSystemTray(null);
          },
          child: "清除系统托盘".text(),
        ),
      ].flowLayout(padding: kXInsets, childGap: kX)!,
      //--
      _resultSignal.buildFn(() {
        final value = _resultSignal.value;
        return value == null
            ? empty
            : "${value.runtimeType}->$value"
                .text(style: globalTheme.textDesStyle);
      }),
      _resultSignal.buildFn(() {
        final value = _resultSignal.value;
        return value == null
            ? empty
            : value is UiImage
                ? value.toImageWidget()
                : value is String
                    ? value.text()
                    : value.toString().text();
      }),
    ];
  }

  //--

  /// [PlatformMenuItem]
  /// [PlatformMenu]
  /// [PlatformMenuItemGroup]
  PlatformMenuItem _buildPlatformMenu({
    String label = "Menu Label",
    bool isSubMenu = false,
  }) {
    return PlatformMenu(
      label: label,
      onOpen: () {
        l.d("$label ...on open");
      },
      onClose: () {
        l.d("$label ...on close");
      },
      menus: [
        PlatformMenuItem(
          label: "$label 1-1",
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyB,
          ),
          onSelected: () {
            toastInfo("$label 1-1");
          },
        ),
        //--
        PlatformMenuItemGroup(members: [
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.servicesSubmenu),
          PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hideOtherApplications),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.showAllApplications),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.startSpeaking),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.stopSpeaking),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow),
          PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.arrangeWindowsInFront),
        ]),
        //--
        if (!isSubMenu)
          _buildPlatformMenu(label: "Sub $label 1-2", isSubMenu: true),
      ],
    );
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
