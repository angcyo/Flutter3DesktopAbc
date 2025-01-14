import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_code/flutter3_code.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

import 'core/ImagePixelPainter.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/14
///
class ImagePixelAbc extends StatefulWidget {
  const ImagePixelAbc({super.key});

  @override
  State<ImagePixelAbc> createState() => _ImagePixelAbcState();
}

class _ImagePixelAbcState extends State<ImagePixelAbc> with DropStateMixin {
  final CanvasDelegate canvasDelegate = CanvasDelegate();
  final ImagePixelPainter imagePixelPainter = ImagePixelPainter();

  @override
  void initState() {
    canvasDelegate.canvasStyle
      ..enableElementControl = false
      ..showGrid = false;
    canvasDelegate.canvasElementManager.addElement(imagePixelPainter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //image
    return [dropStateInfoSignal].buildFn(() {
      return buildDropRegion(context, cLayout(() {
        //中间画布
        CanvasWidget(
          canvasDelegate,
          key: ValueKey("canvas"),
        ).matchParentConstraint();

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

    //uri.filePath

    Uint8List? bytes;
    if (!isNil(dropImageList)) {
      bytes = dropImageList.first;
    } else if (!isNil(dropUriList)) {
      bytes = await dropUriList.first.getBytes();
    }

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
      }
    }
  }
}
