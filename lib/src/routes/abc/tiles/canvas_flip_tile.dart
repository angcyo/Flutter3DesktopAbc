import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/20
///

/// 镜像窗口触发器
class CanvasFlipTrigger extends StatelessWidget {
  final CanvasDelegate canvasDelegate;

  const CanvasFlipTrigger(this.canvasDelegate, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      loadAbcSvgWidget(Assets.svg.flipHorizontal),
      loadAbcSvgWidget(Assets.svg.navArrowTip,
          tintColor: globalTheme.icoGrayColor),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .ink(() {})
        .hoverLayout(
          overlayBuilder: (ctx) => [
            CanvasFlipTile(canvasDelegate, flipX: true),
            CanvasFlipTile(canvasDelegate, flipY: true),
          ].scrollVertical(),
          arrowPosition: ArrowPosition.bottomCenter,
        )
        .center()
        .material();
  }
}

/// 镜像tile
class CanvasFlipTile extends StatelessWidget {
  final CanvasDelegate canvasDelegate;
  final bool? flipX;
  final bool? flipY;

  const CanvasFlipTile(
    this.canvasDelegate, {
    super.key,
    this.flipX,
    this.flipY,
  });

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      if (flipX == true) loadAbcSvgWidget(Assets.svg.flipHorizontal),
      if (flipY == true) loadAbcSvgWidget(Assets.svg.flipVertical),
      if (flipX == true) '水平翻转'.text().paddingOnly(horizontal: kL),
      if (flipY == true) '垂直翻转'.text().paddingOnly(horizontal: kL),
    ]
        .row(mainAxisSize: MainAxisSize.min)!
        .paddingOnly(all: kH)
        .constrained(width: 120)
        .ink(() {
      canvasDelegate.canvasElementManager.canvasElementControlManager
          .flipElementWithScale(
        canvasDelegate.canvasElementManager.elementSelectComponent,
        flipX: flipX,
        flipY: flipY,
      );
    }).material();
  }
}
