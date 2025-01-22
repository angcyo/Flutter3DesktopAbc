import 'package:flutter/material.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/lp_canvas.dart';

import 'canvas_align_tile.dart';
import 'canvas_average_tile.dart';
import 'canvas_flip_tile.dart';
import 'canvas_path_tile.dart';
import 'params_layout.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/19
///
/// 选中元素/未选中元素的属性布局
class CanvasDesktopPropertyLayoutWidget extends StatefulWidget {
  final CanvasDelegate canvasDelegate;

  const CanvasDesktopPropertyLayoutWidget(this.canvasDelegate, {super.key});

  @override
  State<CanvasDesktopPropertyLayoutWidget> createState() =>
      _CanvasDesktopPropertyLayoutWidgetState();
}

class _CanvasDesktopPropertyLayoutWidgetState
    extends State<CanvasDesktopPropertyLayoutWidget>
    with CanvasDelegateMixin, CanvasListenerMixin {
  @override
  void initState() {
    hookCanvasListener(CanvasListener(
      onCanvasElementSelectChangedAction:
          (elementSelect, from, to, selectType) {
        assert(() {
          //debugger();
          l.v('重新选中元素[$selectType]->$to');
          return true;
        }());
        if (selectType != ElementSelectType.ignore) {
          updateState();
        }
      },
      onCanvasElementPropertyChangedAction:
          (element, from, to, propertyType, fromObj, undoType) {
        if (propertyType == PainterPropertyType.paint) {
          updateState();
        }
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //#f6f6f6
    //itemWhiteBgColor
    final globalTheme = GlobalTheme.of(context);
    return [
      "对象"
          .text(style: globalTheme.textTitleStyle, bold: true)
          .paddingAll(kX)
          .backgroundColor(globalTheme.whiteColor)
          .align(Alignment.centerLeft)
          .backgroundColor(globalTheme.itemWhiteBgColor),
      _buildPropertyList(context)
          .scrollVertical()
          ?.matchParentWidth()
          .backgroundColor(globalTheme.whiteColor)
          .expanded(),
    ].column()!;
  }

  /// 构建内容
  WidgetNullList _buildPropertyList(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    if (isSelectedElement) {
      final canvasDelegate = widget.canvasDelegate;
      final selectedElement = canvasDelegate.selectedElement;
      final selectedElementBounds = canvasDelegate.selectedElementBounds;
      final unit = canvasDelegate.axisUnit;
      return [
        "设计".text(style: globalTheme.textDesStyle).paddingOnly(all: kH),
        //--
        [
          CanvasAlignTrigger(canvasDelegate),
          CanvasFlipTrigger(canvasDelegate),
          CanvasAverageTrigger(canvasDelegate),
          CanvasPathTrigger(canvasDelegate),
        ].flowLayout(equalWidthRange: "4~")?.matchParentWidth(),
        hLine(context, indent: kH).paddingOnly(vertical: kH),
        //--size
        [
          textSpanBuilder((builder) {
            builder.addText("X ", style: globalTheme.textDesStyle);
            builder.addText(
              unit.formatFromDp(selectedElementBounds?.left ?? 0),
              style: globalTheme.textBodyStyle,
            );
          }).paddingOnly(all: kL),
          textSpanBuilder((builder) {
            builder.addText("Y ", style: globalTheme.textDesStyle);
            builder.addText(
              unit.formatFromDp(selectedElementBounds?.top ?? 0),
              style: globalTheme.textBodyStyle,
            );
          }).paddingOnly(all: kL),
          textSpanBuilder((builder) {
            builder.addText("W ", style: globalTheme.textDesStyle);
            builder.addText(
              unit.formatFromDp(selectedElementBounds?.width ?? 0),
              style: globalTheme.textBodyStyle,
            );
          }).paddingOnly(all: kL),
          textSpanBuilder((builder) {
            builder.addText("H ", style: globalTheme.textDesStyle);
            builder.addText(
              unit.formatFromDp(selectedElementBounds?.height ?? 0),
              style: globalTheme.textBodyStyle,
            );
          }).paddingOnly(all: kL),
        ]
            .flowLayout(equalWidthRange: "2~", lineChildCount: 2)
            ?.matchParentWidth(),
        hLine(context, indent: kH).paddingOnly(vertical: kH),
        //--params
        ...buildParamsLayout(this, selectedEngraveSingleElements),
      ];
    }
    return [
      "请先选择元素".text().center().sliverExpand(),
    ];
  }
}
