import 'package:flutter/cupertino.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/assets_generated/assets.gen.dart';
import 'package:lp_canvas/lp_canvas.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/20
///
/// 参数相关布局
///
/// [buildDesign2LabelNumberSliderTile]
/// [Design2Mixin]
///
/// 当前只能修改第一个元素的属性, 其余元素不会修改
@implementation
WidgetNullList buildParamsLayout(
  BuildContext context,
  Iterable<LpElementMixin>? elements, {
  bool showFeed = false,
  int minFeed = 1,
  int maxFeed = 800,
}) {
  //final beans = elements?.map((e) => e.elementBean);
  final globalTheme = GlobalTheme.of(context);
  final double iconSize = 20;
  final element = elements?.firstOrNull;
  final bean = element?.elementBean;
  final dataEngraveType = bean?.dataEngraveType;
  final hP = kL;
  final vP = kL;
  return [
    SegmentTile(
      segments: (dataEngraveType == null ||
              dataEngraveType == DataEngraveTypeEnum.image)
          ? [
              "雕刻"
                  .text(textAlign: TextAlign.center)
                  .paddingOnly(horizontal: hP, vertical: vP),
            ]
          : [
              "线条雕刻"
                  .text(textAlign: TextAlign.center)
                  .paddingOnly(horizontal: hP, vertical: vP),
              "填充雕刻"
                  .text(textAlign: TextAlign.center)
                  .paddingOnly(horizontal: hP, vertical: vP),
              "切割雕刻"
                  .text(textAlign: TextAlign.center)
                  .paddingOnly(horizontal: hP, vertical: vP),
            ],
      selectedIndexList: [
        switch (dataEngraveType) {
          DataEngraveTypeEnum.line => 0,
          DataEngraveTypeEnum.fill => 1,
          DataEngraveTypeEnum.cut => 2,
          _ => 0,
        },
      ],
      selectedTextStyle:
          globalTheme.textBodyStyle.copyWith(fontWeight: FontWeight.bold),
      tilePadding: edgeOnly(all: kM),
      equalWidthRange: "",
      onSelectedAction: (list) {
        bean?.dataEngraveType = switch (list.firstOrNull) {
          0 => DataEngraveTypeEnum.line,
          1 => DataEngraveTypeEnum.fill,
          2 => DataEngraveTypeEnum.cut,
          _ => DataEngraveTypeEnum.line,
        };
        element?.tryParseElementTextProperty();
      },
    ).paddingOnly(all: kH),
    //--
    //雕刻密度
    //图像模式
    //--
    LabelNumberSliderTile(
      labelWidget: [
        lpCanvasSvgWidget(Assets.svg.optionPower, size: iconSize)
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
          lpCanvasSvgWidget(Assets.svg.optionDepth, size: iconSize)
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
          lpCanvasSvgWidget(Assets.svg.optionSpeed, size: iconSize)
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
        lpCanvasSvgWidget(Assets.svg.optionCount, size: iconSize)
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
