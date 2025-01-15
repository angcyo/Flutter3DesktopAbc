import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_code/flutter3_code.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

import 'core/ImagePixelPainter.dart';
import 'tiles/image_pixel_property_control_widget.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/14
///
class ImagePixelAbc extends StatefulWidget {
  const ImagePixelAbc({super.key});

  @override
  State<ImagePixelAbc> createState() => _ImagePixelAbcState();
}

class _ImagePixelAbcState extends State<ImagePixelAbc>
    with DropStateMixin, KeyEventMixin, KeyEventStateMixin {
  final CanvasDelegate canvasDelegate = CanvasDelegate();
  final ImagePixelPainter imagePixelPainter = ImagePixelPainter();

  @override
  void initState() {
    canvasDelegate.canvasStyle
      ..enableElementControl = false
      ..enableElementEvent = true
      ..enableElementKeyEvent = true
      ..showGrid = false;
    canvasDelegate.canvasElementManager.addElement(imagePixelPainter);
    super.initState();
    //粘贴
    registerKeyEvent([
      if (isMacOS) ...[
        [
          LogicalKeyboardKey.meta,
          LogicalKeyboardKey.keyV,
        ],
      ],
      if (!isMacOS) ...[
        [
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyV,
        ],
      ],
    ], (info) {
      () async {
        final imageBytes = await readClipboardImageBytes();
        if (imageBytes != null) {
          _handleImage(bytes: imageBytes);
        }
        // 获取剪切板Uri
        final uri = await readClipboardUri();
        if (uri != null) {
          _handleImage(uri: uri);
        }
      }();
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    final lineColor = globalTheme.lineColor;
    return [dropStateInfoSignal].buildFn(() {
      return buildDropRegion(context, cLayout(() {
        //中间画布
        CanvasWidget(
          canvasDelegate,
          key: ValueKey("canvas"),
        ).matchParentConstraint(
          right: sId(1).left,
        );

        //属性控制
        ImagePixelPropertyControlWidget(imagePixelPainter)
            .alignParentConstraint(
          alignment: Alignment.centerRight,
          width: 200,
        );
        Line(thickness: 1, color: lineColor, axis: Axis.vertical)
            .applyConstraint(
          right: sId(-1).left,
          top: sId(-1).top,
          bottom: parent.bottom,
          height: matchConstraint,
          width: 1,
        );

        //拖拽文件覆盖层
        if (isDropOverMixin) {
          "放开这个文本"
              .text(textColor: Colors.white, fontSize: 40)
              .center()
              .backgroundColor(Colors.black12)
              .blur(sigma: 2)
              .matchParentConstraint();
        }
      }));
    });
  }

  @override
  FutureOr onHandleDropDone(PerformDropEvent event) async {
    dropStateInfoSignal.value = null;
    final dropImageList = await event.session.images;
    final dropUriList = await event.session.uris;

    Uint8List? bytes;
    if (!isNil(dropImageList)) {
      bytes = dropImageList.first;
    } else if (!isNil(dropUriList)) {
      bytes = await dropUriList.first.getBytes();
    }

    _handleImage(bytes: bytes);
  }

  @callPoint
  void _handleImage({
    Uint8List? bytes,
    Uri? uri,
  }) async {
    bytes ??= await uri?.getBytes();
    //--
    if (bytes != null) {
      LImageFormat imageFormat = bytes.imageFormatForData;
      LImageDecoder? imageDecoder = bytes.imageDecoderForData;
      LImage? image = imageDecoder?.decode(bytes);

      if (image != null) {
        imagePixelPainter.imagePixelInfo = ImagePixelInfo(
          imageFormat: imageFormat,
          image: image,
        );
        canvasDelegate.canvasFollowManager
            .followCanvasContent(restoreDef: true);
      }
    }
  }
}
