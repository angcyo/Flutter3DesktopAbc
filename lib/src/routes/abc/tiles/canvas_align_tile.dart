import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/20
///

/// 对齐窗口触发器
class CanvasAlignTrigger extends StatelessWidget {
  final CanvasDelegate canvasDelegate;

  const CanvasAlignTrigger(this.canvasDelegate, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    final enable = canvasDelegate.selectedElementCount > 1;
    return [
      loadAbcSvgWidget(Assets.svg.alignLeft),
      loadAbcSvgWidget(Assets.svg.navArrowTip,
          tintColor: globalTheme.icoGrayColor),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .ink(() {})
        .hoverLayout(
          [
            CanvasAlignTile(canvasDelegate, CanvasAlignType.left),
            CanvasAlignTile(canvasDelegate, CanvasAlignType.right),
            CanvasAlignTile(canvasDelegate, CanvasAlignType.top),
            CanvasAlignTile(canvasDelegate, CanvasAlignType.bottom),
            CanvasAlignTile(canvasDelegate, CanvasAlignType.center),
            CanvasAlignTile(canvasDelegate, CanvasAlignType.verticalCenter),
            CanvasAlignTile(canvasDelegate, CanvasAlignType.horizontalCenter),
          ].scrollVertical(),
          arrowPosition: ArrowPosition.bottomCenter,
          enable: enable,
        )
        .center()
        .material()
        .disable(disable: !enable);
  }
}

/// 对齐tile
class CanvasAlignTile extends StatelessWidget {
  final CanvasDelegate canvasDelegate;
  final CanvasAlignType alignType;

  const CanvasAlignTile(this.canvasDelegate, this.alignType, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      switch (alignType) {
        CanvasAlignType.left => loadAbcSvgWidget(Assets.svg.alignLeft),
        CanvasAlignType.right => loadAbcSvgWidget(Assets.svg.alignRight),
        CanvasAlignType.top => loadAbcSvgWidget(Assets.svg.alignTop),
        CanvasAlignType.bottom => loadAbcSvgWidget(Assets.svg.alignBottom),
        CanvasAlignType.center => loadAbcSvgWidget(Assets.svg.alignCenter),
        CanvasAlignType.verticalCenter =>
          loadAbcSvgWidget(Assets.svg.alignVertical),
        CanvasAlignType.horizontalCenter =>
          loadAbcSvgWidget(Assets.svg.alignHorizontal),
      },
      switch (alignType) {
        CanvasAlignType.left => '左对齐'.text(),
        CanvasAlignType.right => '右对齐'.text(),
        CanvasAlignType.top => '顶对齐'.text(),
        CanvasAlignType.bottom => '底对齐'.text(),
        CanvasAlignType.center => '居中对齐'.text(),
        CanvasAlignType.verticalCenter => '垂直对齐'.text(),
        CanvasAlignType.horizontalCenter => '水平对齐'.text(),
      }
          .paddingOnly(horizontal: kL),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .constrained(width: 120)
        .ink(() {
      canvasDelegate.canvasElementManager.alignElement(
        canvasDelegate.canvasElementManager.elementSelectComponent,
        alignType,
      );
    }).material();
  }
}
