import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/lp_canvas.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/20
///

/// 布尔运算窗口触发器
class CanvasPathTrigger extends StatelessWidget {
  final CanvasDelegate canvasDelegate;

  const CanvasPathTrigger(this.canvasDelegate, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);

    final enable =
        LpCanvasHelper.isAllPathElement(canvasDelegate: canvasDelegate) &&
            canvasDelegate.selectedElementCount > 1;

    return [
      loadAbcSvgWidget(Assets.svg.pathUnion),
      loadAbcSvgWidget(Assets.svg.navArrowTip,
          tintColor: globalTheme.icoGrayColor),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .ink(() {})
        .hoverLayout(
          [
            CanvasOperationTile(canvasDelegate, PathOperation.union),
            CanvasOperationTile(canvasDelegate, PathOperation.difference),
            CanvasOperationTile(canvasDelegate, PathOperation.intersect),
            CanvasOperationTile(canvasDelegate, PathOperation.xor),
            CanvasOperationTile(canvasDelegate, null),
          ].scrollVertical(),
          arrowPosition: ArrowPosition.leftStart /*ArrowPosition.bottomCenter*/,
          enable: enable,
        )
        .center()
        .material()
        .disable(disable: !enable);
  }
}

/// 布尔运算tile
class CanvasOperationTile extends StatelessWidget {
  final CanvasDelegate canvasDelegate;
  final PathOperation? opType;

  const CanvasOperationTile(this.canvasDelegate, this.opType, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      switch (opType) {
        PathOperation.union => loadAbcSvgWidget(Assets.svg.pathUnion),
        PathOperation.difference => loadAbcSvgWidget(Assets.svg.pathDifference),
        PathOperation.intersect => loadAbcSvgWidget(Assets.svg.pathIntersect),
        PathOperation.xor => loadAbcSvgWidget(Assets.svg.pathXor),
        _ => loadAbcSvgWidget(Assets.svg.pathMerge),
      },
      switch (opType) {
        PathOperation.union => '合并图形'.text(),
        PathOperation.difference => '排除顶层'.text(),
        PathOperation.intersect => '图形相交'.text(),
        PathOperation.xor => '排除相交'.text(),
        _ => '组合图形'.text(),
      }
          .paddingOnly(horizontal: kL),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .constrained(width: 120)
        .ink(() {
      LpCanvasHelper.handleElementPathOperation(
          canvasDelegate: canvasDelegate, operation: opType);
    }).material();
  }
}
