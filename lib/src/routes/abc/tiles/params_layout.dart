import 'package:flutter/cupertino.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/assets_generated/assets.gen.dart';
import 'package:lp_canvas/lp_canvas.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/20
///
/// 参数相关布局
WidgetNullList buildParamsLayout(
  BuildContext context,
  Iterable<ElementBean>? beans, {
  bool showFeed = false,
  int minFeed = 1,
  int maxFeed = 800,
}) {
  final double _iconSize = 20;
  final bean = beans?.firstOrNull;
  return [
    LabelNumberSliderTile(
      labelWidget: [
        lpCanvasSvgWidget(Assets.svg.optionPower, size: _iconSize)
            .darkColorFiltered(),
        "功率(%)".text(),
      ].row(gap: kL)?.paddingOnly(horizontal: kX),
      value: bean?.printPower ?? 1,
      minValue: 1,
      maxValue: 100,
      inactiveTrackGradientColors: EngraveTileMixin.sActiveTrackGradientColors,
      onValueChanged: (value) {
        final printPower = value.toInt();
        bean?.printPower = printPower;
        //_updateElementLaserOption();
      },
    ).paddingOnly(top: kX),
    if (!showFeed)
      LabelNumberSliderTile(
        labelWidget: [
          lpCanvasSvgWidget(Assets.svg.optionDepth, size: _iconSize)
              .darkColorFiltered(),
          "深度(%)".text(),
        ].row(gap: kL)?.paddingOnly(horizontal: kX),
        value: bean?.printDepth ?? 1,
        minValue: 1,
        maxValue: 100,
        inactiveTrackGradientColors:
            EngraveTileMixin.sActiveTrackGradientColors,
        onValueChanged: (value) {
          final printDepth = value.toInt();
          bean?.printDepth = printDepth;
          //_updateElementLaserOption();
        },
      ).paddingOnly(top: kX),
    if (showFeed)
      LabelNumberSliderTile(
        labelWidget: [
          lpCanvasSvgWidget(Assets.svg.optionSpeed, size: _iconSize)
              .darkColorFiltered(),
          "速度(mm/s)".text(),
        ].row(gap: kL)?.paddingOnly(horizontal: kX),
        value: bean?.feed ?? minFeed,
        minValue: minFeed,
        maxValue: maxFeed,
        inactiveTrackGradientColors:
            EngraveTileMixin.sActiveTrackGradientColors.reversed.toList(),
        onValueChanged: (value) {
          final feed = value.toInt();
          bean?.feed = feed;
          //_updateElementLaserOption();
        },
      ).paddingOnly(top: kX),
    LabelNumberTile(
      labelWidget: [
        lpCanvasSvgWidget(Assets.svg.optionCount, size: _iconSize)
            .darkColorFiltered(),
        "加工次数".text(),
      ].row(gap: kL)?.paddingOnly(horizontal: kX),
      value: bean?.printCount ?? 1,
      onValueChanged: (value) {
        final printCount = value.toInt();
        bean?.printCount = printCount;
        //_updateElementLaserOption();
      },
    ),
  ];
}
