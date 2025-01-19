import 'package:flutter/material.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_module/lp_module.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/13
///
/// [CanvasDesktopAbc] 中用来控制布局显示不同界面的组件
class CanvasDesktopDesignLayoutWidget extends StatefulWidget {
  final CanvasDelegate canvasDelegate;
  final CanvasDesignLayoutController layoutController;

  const CanvasDesktopDesignLayoutWidget(
    this.canvasDelegate,
    this.layoutController, {
    super.key,
  });

  @override
  State<CanvasDesktopDesignLayoutWidget> createState() =>
      _CanvasDesktopDesignLayoutWidgetState();
}

class _CanvasDesktopDesignLayoutWidgetState extends State<CanvasDesktopDesignLayoutWidget> {
  final double _iconSize = 36;

  @override
  Widget build(BuildContext context) {
    final showPropertyType =
        widget.layoutController.showPropertyTypeValue.value;
    final pendingPropertyType = widget.layoutController.pendingPropertyType;
    return [
      if (showPropertyType == DesignShowPropertyType.shape)
        ..._buildShapeLayout(context),
    ].scroll(axis: Axis.vertical)!;
  }

  WidgetList _buildShapeLayout(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return [
      "素材"
          .text(bold: true, style: globalTheme.textTitleStyle)
          .paddingOnly(vertical: kH, horizontal: kX)
          .matchParentWidth(),
      hLine(context),
      "基础图形"
          .text(bold: true, style: globalTheme.textBodyStyle)
          .paddingOnly(vertical: kH, horizontal: kX)
          .matchParentWidth(),
      [
        lpCanvasSvgWidget(lpCanvasSvgAssets.shapeLine, size: _iconSize)
            .iconState(onTap: () {
          _addShapeElementPainter(LpConstants.dataTypeLine);
        }),
        lpCanvasSvgWidget(lpCanvasSvgAssets.shapeRect, size: _iconSize)
            .iconState(onTap: () {
          _addShapeElementPainter(LpConstants.dataTypeRect);
        }),
        lpCanvasSvgWidget(lpCanvasSvgAssets.shapeOval, size: _iconSize)
            .iconState(onTap: () {
          _addShapeElementPainter(LpConstants.dataTypeOval);
        }),
        lpCanvasSvgWidget(lpCanvasSvgAssets.shapePolygon, size: _iconSize)
            .iconState(onTap: () {
          _addShapeElementPainter(LpConstants.dataTypePolygon);
        }),
        lpCanvasSvgWidget(lpCanvasSvgAssets.shapePentagram, size: _iconSize)
            .iconState(onTap: () {
          _addShapeElementPainter(LpConstants.dataTypePentagram);
        }),
        lpCanvasSvgWidget(lpCanvasSvgAssets.shapeLove, size: _iconSize)
            .iconState(onTap: () {
          _addShapeElementPainter(LpConstants.dataTypeLove);
        }),
      ].flowLayout(padding: kXInsets, childGap: kX)!,
      hLine(context),
    ];
  }

  /// 添加基础形状到画布
  void _addShapeElementPainter(int mtype) async {
    //基础形状类型
    final element = await LpCanvasProject.createShapeElementPainter(
      mtype,
      assignElementPosition: true,
      canvasDelegate: widget.canvasDelegate,
    );
    widget.canvasDelegate.canvasElementManager.addElement(
      element,
      selected: true,
      followPainter: true,
      followContent: true,
      selectType: ElementSelectType.ignore /*为了支持连续添加*/,
    );
  }
}
