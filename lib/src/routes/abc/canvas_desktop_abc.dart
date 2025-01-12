import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter3_abc/flutter3_abc.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_module/lp_module.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/30
///
class CanvasDesktopAbc extends StatefulWidget {
  const CanvasDesktopAbc({super.key});

  @override
  State<CanvasDesktopAbc> createState() => _CanvasDesktopAbcState();
}

class _CanvasDesktopAbcState extends State<CanvasDesktopAbc>
    with DropStateMixin {
  final CanvasDelegate canvasDelegate = CanvasDelegate();
  late final CanvasListener canvasListener =
      CanvasListener(onBuildCanvasMenu: (delegate, manger, menus) {
    if (manger.isSelectedElement) {
      menus.add("导出Svg...".text().menuStyleItem().ink(() {
        exportSvg(manger);
      }).popMenu());
      menus.add("导出Svg(加工)...".text().menuStyleItem().ink(() {
        exportSvg(manger, byEngrave: true);
      }).popMenu());
    }
  });

  /// 导出svg
  void exportSvg(CanvasMenuManager manger, {bool byEngrave = false}) async {
    //第一个元素的名称
    final firstName = manger.selectedElementList?.size() == 1
        ? manger.selectedElementList?.firstOrNull?.paintState.elementName
        : null;
    final svgXml =
        await manger.selectedElementList?.toSvgXml(byEngrave: byEngrave);
    final fileName = firstName == null ? "untitled.svg" : "$firstName.svg";
    svgXml
        ?.writeToFile(fileName: fileName, useCacheFolder: true)
        .getValue((file, error) async {
      file?.share();
      if (isDesktop) {
        final saveFilePath = await saveFile(
          dialogTitle: "导出Svg...",
          fileName: fileName,
        );
        l.d("saveFilePath->$saveFilePath");
        if (saveFilePath != null) {
          //保存到本地
          svgXml.writeToFile(file: saveFilePath.file());
        }
      }
    });
  }

  @override
  void initState() {
    canvasDelegate.addCanvasListener(canvasListener);
    super.initState();
  }

  @override
  void dispose() {
    canvasDelegate.removeCanvasListener(canvasListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return dropStateInfoSignal.buildFn(() {
      return buildDropRegion(
        context,
        cLayout(() {
          _buildLeftNavigation(context).alignParentConstraint(
            width: 54,
          );
          CanvasWidget(canvasDelegate).alignParentConstraint(
            alignment: Alignment.centerRight,
            width: matchConstraint,
            left: sId(-1).right,
          );

          //--
          if (dropStateInfoSignal.value?.state.isDropOver == true) {
            "放开这个文本"
                .text(textColor: Colors.white, fontSize: 40)
                .center()
                .backgroundColor(Colors.black12)
                .blur(sigma: 2)
                .matchParentConstraint();
          }
        }),
      );
    });
  }

  @override
  FutureOr onHandleDropDone(PerformDropEvent event) async {
    dropStateInfoSignal.value = null;
    final dropTextList = await event.session.texts;
    final dropUriList = await event.session.uris;

    for (final text in dropTextList) {
      LpElementParser()
        ..text = text
        ..parse(
          autoAddToCanvas: true,
          canvasDelegate: canvasDelegate,
          context: context,
        );
    }
    for (final uri in dropUriList) {
      LpElementParser()
        ..url = uri.filePath
        ..parse(
          autoAddToCanvas: true,
          canvasDelegate: canvasDelegate,
          context: context,
        );
    }

    if (dropTextList.isEmpty && dropUriList.isEmpty) {
      lpToast("不支持的数据类型".text());
    }
  }

  final double _navItemSize = 42;

  /// 构建导航
  Widget _buildLeftNavigation(BuildContext context) {
    return [
      Empty.height(kL),
      lpAbcSvgWidget(Assets.svg.addImage).icon(() {
        lpToast("click1".text());
      }).size(size: _navItemSize),
      HoverAnchorLayout(
        anchor: lpAbcSvgWidget(Assets.svg.addShape).icon(() {
          lpToast("click1".text());
        }).size(size: _navItemSize),
        content: [
          ArrowWidget().size(size: 20),
          lpAbcSvgWidget(Assets.svg.addShape),
          lpAbcSvgWidget(Assets.svg.addImage).icon(() {
            lpToast("click2".text());
          }),
        ].column(),
      ),
    ].scroll(axis: Axis.vertical, gap: kX)!;
  }
}
