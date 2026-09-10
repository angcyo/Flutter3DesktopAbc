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
        TileMixin,
        WindowListenerTypedef,
        WindowListenerMixin,
        TrayListenerTypedef,
        TrayListenerStateMixin /*NativeWindowEventStateMixin,
        TrayIconStateMixin*/ {
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
    /*final cw = $nativeCurrentWindow;
    _wmInfoSignal.value =
        "鼠标位置:${$nativeCursorPosition}\n"
        "窗口边界:${cw?.bounds}\n"
        "窗口大小:${cw?.size} 位置:${cw?.position}"
        "焦点:${cw?.isFocused.dc} 是否最大化:${cw?.isMaximized.dc} 是否全屏:${cw?.isFullScreen.dc} 置顶:${cw?.isAlwaysOnTop.dc}"
        "\n\n主屏幕:${$nativePrimaryDisplay}\n\n"
        "屏幕列表:\n${$nativeDisplays.connect("\n")}\n";*/
    _wmInfoSignal.value =
        "鼠标位置:${await $wm.cursorScreenPoint}\n"
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
      PlatformMenuItemGroup(members: [_buildPlatformMenu()]),
      PlatformMenuItemGroup(members: [_buildPlatformMenu()]),
    ]);
  }

  @override
  WidgetList buildBodyList(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    //final cw = $nativeCurrentWindow;
    final cw = $wm;
    return [
      _wmInfoSignal.buildFn(
        () => "${_wmInfoSignal.value ?? ""}".text().click(() {
          "${_wmInfoSignal.value ?? ""}".copy();
          _updateWindowInfo();
        }),
      ),
      [
        "physicalSize:${flutterView.physicalSize} sw:$screenWidth sh:$screenHeight"
            .text(),
        GradientButton.normal(() {
          cw.setFullScreen(true);
          //cw?.isFullScreen = true;
        }, child: "全屏".text()),
        GradientButton.normal(() {
          cw.setFullScreen(false);
          //cw?.isFullScreen = false;
        }, child: "退出全屏".text()),
        GradientButton.normal(() {
          cw?.center();
        }, child: "居中显示".text()),
        GradientButton.normal(() {
          cw.setAlwaysOnTop(true);
          //cw?.isAlwaysOnTop = true;
          _updateWindowInfo();
        }, child: "置顶".text()),
        GradientButton.normal(() {
          cw.setAlwaysOnTop(false);
          //cw?.isAlwaysOnTop = false;
          _updateWindowInfo();
        }, child: "取消置顶".text()),
        GradientButton.normal(() {
          final title = "新标题->${nowTimeString()}";
          cw.setTitle(title);
          //cw?.title = title;
        }, child: "设置标题".text()),
        GradientButton.normal(() {
          cw.setTitleBarStyle(.hidden);
          //cw?.titleBarStyle = .hidden;
        }, child: "设置标题样式(hidden)".text()),
        GradientButton.normal(() {
          cw.setTitleBarStyle(.normal);
          //cw?.titleBarStyle = .normal;
        }, child: "设置标题样式(normal)".text()),
        GradientButton.normal(() {
          cw.setTitleBarStyle(.normal, windowButtonVisibility: false);
          //cw?.isWindowControlButtonsVisible = false;
        }, child: "隐藏标题按钮".text()),
        GradientButton.normal(() {
          cw.setTitleBarStyle(.normal, windowButtonVisibility: true);
          //cw?.isWindowControlButtonsVisible = true;
        }, child: "显示标题按钮".text()),
        GradientButton.normal(() {
          cw.setSkipTaskbar(true);
          //cw?.isSkipTaskbar = true;
        }, child: "隐藏任务栏按钮".text()),
        GradientButton.normal(() {
          cw.setSkipTaskbar(false);
          //cw?.isSkipTaskbar = false;
        }, child: "显示任务栏按钮".text()),
        GradientButton.normal(() {
          cw?.setBrightness(.dark);
        }, child: "dark".text()),
        GradientButton.normal(() {
          cw?.setBrightness(.light);
        }, child: "light".text()),
      ].flowLayout(padding: kXInsets, childGap: kX)!,
      SliderTile(
        leadingWidget: "任务栏进度".text(),
        value: _progress,
        onChanged: (value) {
          //任务栏进度条
          _progress = value;
          cw?.setProgressBar(value);
          updateState();
        },
      ),
      SliderTile(
        leadingWidget: "窗口透明度".text(),
        value: _opacity,
        onChanged: (value) {
          //任务栏进度条
          _opacity = value;
          //cw?.opacity = 1 - value;
          cw.setOpacity(1 - value);
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
        GradientButton.normal(() {
          Window.setEffect(
            effect: WindowEffect.transparent,
            color: color,
            dark: dark,
          );
        }, child: "transparent".text()),
        GradientButton.normal(() {
          Window.setEffect(
            effect: WindowEffect.solid,
            color: color,
            dark: dark,
          );
        }, child: "solid".text()),
        GradientButton.normal(() {
          Window.setEffect(effect: WindowEffect.aero, color: color, dark: dark);
        }, child: "aero".text()),
        GradientButton.normal(() {
          Window.setEffect(
            effect: WindowEffect.acrylic,
            color: color,
            dark: dark,
          );
        }, child: "acrylic".text()),
        GradientButton.normal(() {
          Window.setEffect(effect: WindowEffect.mica, color: color, dark: dark);
        }, child: "mica".text()),
        GradientButton.normal(() {
          Window.setEffect(
            effect: WindowEffect.tabbed,
            color: color,
            dark: dark,
          );
        }, child: "tabbed".text()),
      ].flowLayout(padding: kXInsets, childGap: kX)!,
      //--
      [
        GradientButton.normal(() async {
          final image = await captureScreenImage();
          writeClipboardImage(image);
        }, child: "复制图片".text()),
        GradientButton.normal(() async {
          writeClipboardText("<br>${nowTimeString()}");
        }, child: "复制文本".text()),
        GradientButton.normal(() async {
          writeClipboardHtmlText("<br>${nowTimeString()}");
        }, child: "复制文本(html)".text()),
        GradientButton.normal(() async {
          final image = await readClipboardImage();
          _resultSignal.value = image;
        }, child: "粘贴图片".text()),
        GradientButton.normal(() async {
          final text = await readClipboardText();
          _resultSignal.value = text;
        }, child: "粘贴文本".text()),
        GradientButton.normal(() async {
          final uri = await readClipboardUri();
          _resultSignal.value = uri;
        }, child: "粘贴Uri".text()),
        //MARK : - Menu
        GradientButton.normal(() {
          toastInfo("click");
        }, child: "本机上下文菜单".text()).contextMenu(
          actions: [
            MenuActionTypedef(
              title: "Title 1",
              image: MenuImageTypedef.icon(Icons.access_alarm),
              callback: () {
                toastInfo("Title 1");
              },
            ),
            MenuActionTypedef(
              title: "Title 2",
              state: MenuActionStateTypedef.checkOn,
              activator: SingleActivator(
                LogicalKeyboardKey.keyA,
                control: true,
              ),
              callback: () {
                toastInfo("Title 2");
              },
            ),
            MenuActionTypedef(
              title: "Title 3",
              state: MenuActionStateTypedef.checkMixed,
              attributes: MenuActionAttributesTypedef(
                destructive: true,
                disabled: true,
              ),
              callback: () {
                toastInfo("Title 3");
              },
            ),
            MenuActionTypedef(
              title: "Title 4",
              state: MenuActionStateTypedef.radioOn,
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
            MenuTypedef(
              title: "Sub Menu",
              image: MenuImageTypedef.icon(Icons.search),
              children: [
                MenuActionTypedef(
                  title: "Sub Title 1",
                  state: MenuActionStateTypedef.radioOn,
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
          ],
        ),
        GradientButton.normal(() {
          //createTrayMixin
          setSystemTray(
            iconAssetKey: isWindows
                ? 'assets/ico/app_icon.ico'
                : 'assets/ico/app_icon.png',
            title: "Title",
            tooltip: "Tooltip",
          );
        }, child: "设置系统托盘".text()),
        GradientButton.normal(() {
          //createTrayMixin
          setSystemTray(
            iconAssetKey: isWindows
                ? 'assets/ico/app_icon.ico'
                : 'assets/ico/app_icon.png',
            title: "Title",
            tooltip: "Tooltip",
            /*menu: $buildNativeMenu(),*/
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
        }, child: "设置系统托盘(Menu)".text()),
        GradientButton.normal(() {
          //removeAllTrayMixin();
          setSystemTray();
        }, child: "清除系统托盘".text()),
      ].flowLayout(padding: kXInsets, childGap: kX)!,
      //--
      _resultSignal.buildFn(() {
        final value = _resultSignal.value;
        return value == null
            ? empty
            : "${value.runtimeType}->$value".text(
                style: globalTheme.textDesStyle,
              );
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
          shortcut: SingleActivator(LogicalKeyboardKey.keyB),
          onSelected: () {
            toastInfo("$label 1-1");
          },
        ),
        //--
        PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.servicesSubmenu,
            ),
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.hideOtherApplications,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.showAllApplications,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.startSpeaking,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.stopSpeaking,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.zoomWindow,
            ),
            PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.arrangeWindowsInFront,
            ),
          ],
        ),
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

  //MARK: - window event

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

  /*@override
  void onWindowEventMixin(Object event) {
    super.onWindowEventMixin(event);
    _updateWindowInfo();
  }*/
}
