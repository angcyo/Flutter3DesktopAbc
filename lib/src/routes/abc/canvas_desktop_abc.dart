import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_module/lp_module.dart';

import 'tiles/canvas_desktop_design_layout_widget.dart';
import 'tiles/canvas_desktop_menu_layout_widget.dart';
import 'tiles/canvas_desktop_property_layout_widget.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/30
///
class CanvasDesktopAbc extends StatefulWidget {
  const CanvasDesktopAbc({super.key});

  @override
  State<CanvasDesktopAbc> createState() => _CanvasDesktopAbcState();
}

class _CanvasDesktopAbcState extends State<CanvasDesktopAbc>
    with
        DropStateMixin,
        KeyEventMixin,
        KeyEventStateMixin,
        TickerProviderStateMixin {
  //--
  final CanvasDelegate canvasDelegate = CanvasDelegate();
  late final CanvasListener canvasListener =
      CanvasListener(onBuildCanvasMenu: (delegate, manger, menus) {
    if (manger.isSelectedElement) {
      menus.add("导出Svg...".text().menuStyleItem().ink(() {
        exportSvg(manger);
      }).popMenu());
      menus.add("导出Svg(加工)...".text().menuStyleItem().ink(() {
        exportSvg(manger, byEngrave: true);
      }).popMenu());
    }
  });

  //--

  /// 画布设计属性控制
  late final CanvasDesignLayoutController layoutController =
      CanvasDesignLayoutController(vsync: this, canvasDelegate: canvasDelegate);

  /// 导出svg
  void exportSvg(CanvasMenuManager manger, {bool byEngrave = false}) async {
    //第一个元素的名称
    final firstName = manger.selectedElementList?.size() == 1
        ? manger.selectedElementList?.firstOrNull?.paintState.elementName
        : null;
    final svgXml = await manger.selectedElementList?.toSvgXml(
      byEngrave: byEngrave,
      useSvgTagData: isDebug,
    );
    final fileName = firstName == null ? "untitled.svg" : "$firstName.svg";
    svgXml
        ?.writeToFile(fileName: fileName, useCacheFolder: true)
        .getValue((file, error) async {
      if (isDesktop) {
        final saveFilePath = await saveFile(
          dialogTitle: "导出Svg...",
          fileName: fileName,
        );
        l.d("saveFilePath->$saveFilePath");
        if (saveFilePath != null) {
          //保存到本地
          svgXml.writeToFile(file: saveFilePath.file());
        }
      } else {
        file?.share();
      }
    });
  }

  @override
  void initState() {
    canvasDelegate.addCanvasListener(canvasListener);
    //粘贴
    registerKeyEvent([
      if (isMacOS) ...[
        [
          LogicalKeyboardKey.meta,
          LogicalKeyboardKey.keyV,
        ],
      ],
      if (!isMacOS) ...[
        [
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyV,
        ],
      ],
    ], (info) {
      () async {
        // 获取剪切板image
        final image = await readClipboardImage();
        if (image != null) {
          LpElementParser()
            ..image = image
            ..parse(
              autoAddToCanvas: true,
              canvasDelegate: canvasDelegate,
              context: buildContext,
            );
        }
        // 获取剪切板text
        final text = await readClipboardText();
        if (!isNil(text)) {
          LpElementParser()
            ..text = text
            ..parse(
              autoAddToCanvas: true,
              canvasDelegate: canvasDelegate,
              context: buildContext,
            );
        }
        // 获取剪切板Uri
        final uri = await readClipboardUri();
        if (uri != null) {
          LpElementParser()
            ..url = uri.filePath
            ..parse(
              autoAddToCanvas: true,
              canvasDelegate: canvasDelegate,
              context: buildContext,
            );
        }
      }();
      return true;
    });
    super.initState();
  }

  @override
  void dispose() {
    canvasDelegate.removeCanvasListener(canvasListener);
    super.dispose();
  }

  final _designLayoutWidth = 246.0;
  final _propertyLayoutWidth = 246.0;

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    final lineColor = globalTheme.lineColor;
    return [dropStateInfoSignal, layoutController.showPropertyTypeValue]
        .buildFn(() {
      return buildDropRegion(
        context,
        cLayout(() {
          //顶部菜单
          CanvasDesktopMenuLayoutWidget(
            canvasDelegate,
            key: ValueKey("CanvasDesktopMenuLayout"),
          ).alignParentConstraint(
            alignment: Alignment.topCenter,
            height: 60,
          );
          //左边导航
          _buildLeftNavigation(context).alignParentConstraint(
            top: sId(-1).bottom,
            width: 54,
          );
          Line(thickness: 1, color: lineColor, axis: Axis.vertical)
              .applyConstraint(
            left: sId(-1).right,
            top: sId(-1).top,
            bottom: parent.bottom,
            height: matchConstraint,
            width: 1,
          );
          if (layoutController.isShowPropertyLayout) {
            //左侧动态布局
            CanvasDesktopDesignLayoutWidget(
              canvasDelegate,
              layoutController,
              key: ValueKey("CanvasDesktopDesignLayout"),
            ).applyConstraint(
              left: sId(-1).right,
              width: _designLayoutWidth,
              top: sId(-1).top,
              bottom: sId(-1).bottom,
              height: matchConstraint,
            );
          }
          //右侧属性
          CanvasDesktopPropertyLayoutWidget(
            canvasDelegate,
            key: ValueKey("CanvasDesktopPropertyLayout"),
          ).alignParentConstraint(
            alignment: Alignment.centerRight,
            width: _propertyLayoutWidth,
            top: sId(-1).top,
          );
          //中间画布
          CanvasWidget(
            canvasDelegate,
            key: ValueKey("canvas"),
          ).alignParentConstraint(
            alignment: Alignment.centerRight,
            width: matchConstraint,
            left: sId(-2).right,
            right: sId(-1).left,
            top: sId(-1).top,
          );

          //拖拽文件覆盖层
          if (isDropOverMixin) {
            "放开这个文本"
                .text(textColor: Colors.white, fontSize: 40)
                .center()
                .backgroundColor(Colors.black12)
                .blur(sigma: 2)
                .matchParentConstraint();
          }
        }),
      );
    });
  }

  @override
  FutureOr onHandleDropDone(PerformDropEvent event) async {
    dropStateInfoSignal.value = null;
    final dropTextList = await event.session.texts;
    final dropUriList = await event.session.uris;

    for (final text in dropTextList) {
      LpElementParser()
        ..text = text
        ..parse(
          autoAddToCanvas: true,
          canvasDelegate: canvasDelegate,
          context: buildContext,
        );
    }
    for (final uri in dropUriList) {
      LpElementParser()
        ..url = uri.filePath
        ..parse(
          autoAddToCanvas: true,
          canvasDelegate: canvasDelegate,
          context: buildContext,
        );
    }

    if (dropTextList.isEmpty && dropUriList.isEmpty) {
      lpToast("不支持的数据类型".text());
    }
  }

  /// 键盘事件处理
  @override
  bool onHandleKeyEventMixin(KeyEvent event) {
    return super.onHandleKeyEventMixin(event);
  }

  final double _navItemSize = 42;
  final double _decorationBorderRadius = kCanvasIcoItemRadiusSize;

  /// 画布覆盖层组件
  CanvasOverlayComponent? _overlayComponent;

  /// 安装画布覆盖层组件
  void _installOverlayComponent(CanvasOverlayComponent? component) {
    if (_overlayComponent != null) {
      //有旧的
    }
    component?.onOverlayDetachFromCanvasDelegate = (delegate, overlay) {
      if (overlay is CanvasPenOverlayComponent) {
        final svgPath = overlay.outputSvgPath;
        if (!isNil(svgPath)) {
          //添加svg元素
          //l.d("svgPath->$svgPath");
          LpElementParser()
            ..svgPath = svgPath
            ..useDataPosition = true
            ..tooLargeOverType = TooLargeOverType.origin
            ..parse(
              autoAddToCanvas: true,
              canvasDelegate: canvasDelegate,
              context: buildContext,
            );
        }
      }
      updateState();
    };
    if (component is CanvasPenOverlayComponent) {
      component.onSvgPathAction = (svgPath) {
        _overlayComponent = null;
        canvasDelegate.attachOverlay(null);
      };
    } else if (component is CanvasPointerOverlayComponent) {
      //触发添加文本
      component.cursorStyle = SystemMouseCursors.text;
      component.onPointerAction = (event) {
        if (event.isPointerUp) {
          @dp
          @sceneCoordinate
          final position =
              canvasDelegate.canvasViewBox.toScenePoint(event.localPosition);
          LpElementParser()
            ..text = "HELLO"
            ..textFontSize = 10
            ..onCreateElementBeanAction = (type) {
              return ElementBean()
                ..left = position.dx.toMmFromDp()
                ..top = position.dy.toMmFromDp();
            }
            ..parse(
              autoAddToCanvas: true,
              canvasDelegate: canvasDelegate,
              context: buildContext,
            );
          _overlayComponent = null;
          canvasDelegate.attachOverlay(null);
        }
        return true;
      };
    }
    _overlayComponent = component;
    canvasDelegate.attachOverlay(component);
  }

  /// 构建导航
  /// [CanvasIconWidget]
  /// [IconStateWidget]
  Widget _buildLeftNavigation(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    final selectedDecoration = lineaGradientDecoration(
      listOf(globalTheme.primaryColorDark, globalTheme.primaryColor),
      borderRadius: _decorationBorderRadius,
    );
    return [
      loadAbcSvgWidget(Assets.svg.addImage)
          .icon(() async {
            //选择图片/添加图片
            final file = await pickFile();
            if (file == null) {
              return;
            }
            wrapLoadingTimeout(() async {
              final parser = LpElementParser()..assignElementPosition = true;
              return await parser.parse(
                url: file.path,
                autoAddToCanvas: true,
                context: context,
                canvasDelegate: canvasDelegate,
              );
            }());
          })
          .size(size: _navItemSize)
          .paddingOnly(top: kL),
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.addPen),
        selectedDecoration: _overlayComponent is CanvasPenOverlayComponent
            ? selectedDecoration
            : null,
        onTap: () {
          if (_overlayComponent is CanvasPenOverlayComponent) {
            _installOverlayComponent(null);
          } else {
            _installOverlayComponent(CanvasPenOverlayComponent());
          }
          updateState();
        },
      ).size(size: _navItemSize),
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.addText),
        selectedDecoration: _overlayComponent is CanvasPointerOverlayComponent
            ? selectedDecoration
            : null,
        onTap: () {
          if (_overlayComponent is CanvasPointerOverlayComponent) {
            _installOverlayComponent(null);
          } else {
            _installOverlayComponent(CanvasPointerOverlayComponent());
          }
          updateState();
        },
      ).size(size: _navItemSize),
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.addMaterial),
        selectedDecoration: layoutController.showPropertyTypeValue.value ==
                DesignShowPropertyType.shape
            ? selectedDecoration
            : null,
        onTap: () {
          layoutController.toggleShowPropertyType(
            DesignShowPropertyType.shape,
            true,
          );
        },
      ).size(size: _navItemSize),
      loadAbcSvgWidget(Assets.svg.addApps).icon(() {
        lpToast("click1".text());
      }).size(size: _navItemSize),
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.iconLayer),
        selectedDecoration: layoutController.showPropertyTypeValue.value ==
                DesignShowPropertyType.layer
            ? selectedDecoration
            : null,
        onTap: () {
          layoutController.toggleShowPropertyType(
            DesignShowPropertyType.layer,
            true,
          );
        },
      ).size(size: _navItemSize),
      /*HoverAnchorLayout(
        anchor: lpAbcSvgWidget(Assets.svg.addShape).icon(() {
          lpToast("click1".text());
        }).size(size: _navItemSize),
        content: [
          ArrowWidget().size(size: 20),
          lpAbcSvgWidget(Assets.svg.addShape),
          lpAbcSvgWidget(Assets.svg.addImage).icon(() {
            lpToast("click2".text());
          }),
        ].column(),
      ),*/
    ].scroll(
      axis: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: kX,
      key: ValueKey("LeftNavigation"),
    )!;
  }
}
