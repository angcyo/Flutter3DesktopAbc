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

class _CanvasDesktopDesignLayoutWidgetState
    extends State<CanvasDesktopDesignLayoutWidget>
    with CanvasDelegateMixin, CanvasListenerMixin {
  final double _iconSize = 36;

  /// 当前显示的属性类型
  DesignShowPropertyType get showPropertyType =>
      widget.layoutController.showPropertyTypeValue.value;

  /// 待显示的属性类型
  DesignShowPropertyType get pendingPropertyType =>
      widget.layoutController.pendingPropertyType;

  @override
  void initState() {
    hookCanvasListener(CanvasListener(
      onCanvasElementListChangedAction: (from, to, op, changeType, undoType) {
        if (showPropertyType == DesignShowPropertyType.layer) {
          updateState();
        }
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return [
      if (showPropertyType == DesignShowPropertyType.shape)
        ..._buildShapeLayout(context),
      if (showPropertyType == DesignShowPropertyType.layer)
        ..._buildLayerLayout(context),
    ].scroll(axis: Axis.vertical)!;
  }

  /// 基础图形布局
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

  final _elementSize = 30.0;

  /// 图层布局
  WidgetList _buildLayerLayout(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    final elements = canvasDelegate?.allElementList ?? <ElementPainter>[];
    return [
      "对象列表(${elements.size()})"
          .text(bold: true, style: globalTheme.textTitleStyle)
          .paddingOnly(vertical: kH, horizontal: kX)
          .matchParentWidth(),
      hLine(context),
      if (isNil(elements)) "暂无数据".text().center().sliverExpand(),
      for (final element in elements)
        [
          CanvasElementWidget(element).size(size: _elementSize),
          element.paintState.elementName
              ?.text(maxLines: 1)
              .paddingAll(kX)
              .expanded(),
        ].row()!.ink(() {
          canvasDelegate?.selectElement(element);
        }).material(),
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
