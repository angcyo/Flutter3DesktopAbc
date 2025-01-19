import 'package:flutter/material.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/lp_canvas.dart';

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
    hookCanvasListener(CanvasListener(onCanvasElementSelectChangedAction:
        (elementSelect, from, to, selectType) {
      assert(() {
        //debugger();
        l.v('重新选中元素[$selectType]->$to');
        return true;
      }());
      if (selectType != ElementSelectType.ignore) {
        updateState();
      }
    }));
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
          ?.backgroundColor(globalTheme.whiteColor)
          .expanded(),
    ].column()!;
  }

  /// 构建内容
  WidgetNullList _buildPropertyList(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    if (isSelectedElement) {
      return [];
    }
    return [
      "请先选择元素"
          .text()
          .center()
          .backgroundColor(globalTheme.warnColor)
          .sliverExpand(),
    ];
  }
}
