import 'package:flutter/material.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:lp_canvas/lp_canvas.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/02/16
///
/// 文本元素编辑tile
class CanvasTextElementEditTile extends StatefulWidget {
  final ElementPainter textElement;

  const CanvasTextElementEditTile(
    this.textElement, {
    super.key,
  });

  @override
  State<CanvasTextElementEditTile> createState() =>
      _CanvasTextElementEditTileState();
}

class _CanvasTextElementEditTileState extends State<CanvasTextElementEditTile> {
  /// 输入配置信息
  final inputConfig = TextFieldConfig();

  ElementStateStack? _undoState;

  @override
  void initState() {
    inputConfig.text = widget.textElement.elementBean?.text;
    _undoState = widget.textElement.createStateStack();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CanvasTextElementEditTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    inputConfig.updateText(widget.textElement.elementBean?.text);
    _undoState = widget.textElement.createStateStack();
  }

  @override
  Widget build(BuildContext context) {
    return SingleInputWidget(
      config: inputConfig,
      hintText: "请输入文本",
      maxLines: 3,
      maxLength: LpConstants.kTextInputMaxLength,
      autoSubmitOnUnFocus: true,
      onChanged: (value) {
        final element = widget.textElement;
        //debugger();
        /*if (element is LpElementMixin) {
          element.wrapChangeElementBeanAction(
            () {
              element.elementBean?.text = value;
            },
            parseOriginData: true,
            undoType: UndoType.none,
          );
        }*/
      },
      onSubmitted: (value) {
        final element = widget.textElement;
        //debugger();
        if (element is LpElementMixin) {
          element.wrapChangeElementBeanAction(
            () {
              element.elementBean?.text = value;
            },
            parseOriginData: true,
            undoState: _undoState,
          );
        }
      },
    ).paddingOnly(
      horizontal: kL,
      vertical: kM,
    );
  }
}
