import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/lp_canvas.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/20
///
/// 画布顶部菜单布局
class CanvasDesktopMenuLayoutWidget extends StatefulWidget {
  final CanvasDelegate canvasDelegate;

  const CanvasDesktopMenuLayoutWidget(this.canvasDelegate, {super.key});

  @override
  State<CanvasDesktopMenuLayoutWidget> createState() =>
      _CanvasDesktopMenuLayoutWidgetState();
}

class _CanvasDesktopMenuLayoutWidgetState
    extends State<CanvasDesktopMenuLayoutWidget>
    with CanvasDelegateMixin, CanvasListenerMixin {
  @override
  void initState() {
    hookCanvasListener(CanvasListener(
      onCanvasUndoChangedAction: (_) {
        updateState();
      },
      onCanvasStyleModeChangedAction: (_, __, ___) {
        updateState();
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    /*const Color(0xff474747)*/
    final unitList = [IUnit.dp, IUnit.mm, IUnit.inch];
    return [
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.navMenu),
        text: textSpanBuilder((builder) {
          builder.addText("主菜单");
          builder.addWidget(loadAbcSvgWidget(Assets.svg.navArrowTip, size: 8));
        }),
        onTap: () {},
      ).paddingOnly(left: kH),
      vLine(context, color: globalTheme.borderColor).paddingOnly(vertical: kX),
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.navCanvas),
        text: textSpanBuilder((builder) {
          builder.addText("画布1");
        }),
        onTap: () {},
      ).paddingOnly(left: kH),
      CanvasIconWidget(
        icon: loadAbcSvgWidget(Assets.svg.navUndo),
        text: textSpanBuilder((builder) {
          builder.addText("撤销");
        }),
        color: globalTheme.whiteColor,
        disableColor: globalTheme.icoDisableColor,
        enable: canvasUndoManager?.canUndo() == true,
        onTap: () {
          canvasUndoManager?.undo();
        },
      ).paddingOnly(left: kH),
      CanvasIconWidget(
        icon: loadAbcSvgWidget(Assets.svg.navRedo),
        text: textSpanBuilder((builder) {
          builder.addText("重做");
        }),
        color: globalTheme.whiteColor,
        disableColor: globalTheme.icoDisableColor,
        enable: canvasUndoManager?.canRedo() == true,
        onTap: () {
          canvasUndoManager?.redo();
        },
      ).paddingOnly(left: kH),
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.navSelecter),
        selected: canvasDelegate?.isDragMode == false,
        selectedColor: globalTheme.blackColor,
        text: textSpanBuilder((builder) {
          builder.addText("选择");
        }),
        onTap: () {
          canvasDelegate
              ?.updateCanvasStyleModeChanged(CanvasStyleMode.defaultMode);
        },
      ).paddingOnly(left: kH),
      IconStateWidget(
        icon: loadAbcSvgWidget(Assets.svg.navMove),
        selected: canvasDelegate?.isDragMode == true,
        selectedColor: globalTheme.blackColor,
        text: textSpanBuilder((builder) {
          builder.addText("移动");
        }),
        onTap: () {
          canvasDelegate
              ?.updateCanvasStyleModeChanged(CanvasStyleMode.dragMode);
        },
      ).paddingOnly(left: kH),
      //--
      vLine(context, color: globalTheme.borderColor).paddingOnly(vertical: kX),
      SegmentTile(
        segments: unitList
            .map(
              (e) => e.suffix
                  .text(
                      textAlign: TextAlign.center,
                      textColor: globalTheme.whiteColor)
                  .paddingOnly(horizontal: kX, vertical: kH),
            )
            .toList(),
        selectedIndexList: [
          unitList.indexOf(canvasDelegate?.axisUnit ?? IUnit.mm)
        ],
        /*selectedTextStyle:
          globalTheme.textBodyStyle.copyWith(fontWeight: FontWeight.bold),*/
        /*tilePadding: edgeOnly(all: kM),*/
        selectedDecoration: null,
        onSelectedAction: (list) {
          canvasDelegate?.axisUnit =
              unitList.getOrNull(list.firstOrNull ?? 0) ?? IUnit.mm;
          updateState();
        },
        borderColor: globalTheme.itemWhiteBgColor,
      ).paddingOnly(left: kH),
    ]
        .scrollHorizontal()!
        .backgroundColor(globalTheme.themeBlackColor)
        .textStyle(globalTheme.textBodyStyle.copyWith(
          color: globalTheme.whiteColor,
        ));
  }
}
