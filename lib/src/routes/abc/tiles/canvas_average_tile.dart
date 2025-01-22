import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/20
///

/// 均分窗口触发器
class CanvasAverageTrigger extends StatelessWidget {
  final CanvasDelegate canvasDelegate;

  const CanvasAverageTrigger(this.canvasDelegate, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    final enable = canvasDelegate.selectedElementCount > 1;
    return [
      loadAbcSvgWidget(Assets.svg.averageHorizontal),
      loadAbcSvgWidget(Assets.svg.navArrowTip,
          tintColor: globalTheme.icoGrayColor),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .ink(() {})
        .hoverLayout(
          overlayBuilder: (ctx) => [
            CanvasAverageTile(canvasDelegate, CanvasAverageType.horizontal),
            CanvasAverageTile(canvasDelegate, CanvasAverageType.vertical),
            CanvasAverageTile(canvasDelegate, CanvasAverageType.height),
            CanvasAverageTile(canvasDelegate, CanvasAverageType.width),
            CanvasAverageTile(canvasDelegate, CanvasAverageType.size),
          ].scrollVertical(),
          arrowPosition: ArrowPosition.bottomCenter,
          enable: enable,
        )
        .center()
        .material()
        .disable(!enable);
  }
}

/// 均分tile
class CanvasAverageTile extends StatelessWidget {
  final CanvasDelegate canvasDelegate;
  final CanvasAverageType averageType;

  const CanvasAverageTile(this.canvasDelegate, this.averageType, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      switch (averageType) {
        CanvasAverageType.horizontal =>
          loadAbcSvgWidget(Assets.svg.averageHorizontal),
        CanvasAverageType.vertical =>
          loadAbcSvgWidget(Assets.svg.averageVertical),
        CanvasAverageType.width => loadAbcSvgWidget(Assets.svg.averageWidth),
        CanvasAverageType.height => loadAbcSvgWidget(Assets.svg.averageHeight),
        CanvasAverageType.size => loadAbcSvgWidget(Assets.svg.averageSize),
      },
      switch (averageType) {
        CanvasAverageType.horizontal => '水平均分'.text(),
        CanvasAverageType.vertical => '垂直均分'.text(),
        CanvasAverageType.width => '等宽'.text(),
        CanvasAverageType.height => '等高'.text(),
        CanvasAverageType.size => '等大小'.text(),
      }
          .paddingOnly(horizontal: kL),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .constrained(width: 120)
        .ink(() {
      canvasDelegate.canvasElementManager.averageElement(
        canvasDelegate.canvasElementManager.elementSelectComponent,
        averageType,
      );
    }).material();
  }
}
