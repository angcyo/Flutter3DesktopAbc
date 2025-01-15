import 'package:flutter/material.dart';
import 'package:flutter3_code/flutter3_code.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

import '../core/ImagePixelPainter.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/14
///
/// 图片像素属性信息, 以及导出控制
class ImagePixelPropertyControlWidget extends StatefulWidget {
  final ImagePixelPainter imagePixelPainter;

  const ImagePixelPropertyControlWidget(this.imagePixelPainter, {super.key});

  @override
  State<ImagePixelPropertyControlWidget> createState() =>
      _ImagePixelPropertyControlWidgetState();
}

class _ImagePixelPropertyControlWidgetState
    extends State<ImagePixelPropertyControlWidget> {
  /// 整体图片的信息
  ImagePixelInfo? get imagePixelInfo => widget.imagePixelPainter.imagePixelInfo;

  /// 图片中某个cell的信息
  ImagePixelCellValue? get tapCellValue =>
      widget.imagePixelPainter.tapCellValue;

  /// 需要保存的图片格式
  LImageFormat? saveFormat = LImageFormat.png;

  @override
  void initState() {
    widget.imagePixelPainter.onTapCellAction = (value) {
      updateState();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final info = imagePixelInfo;
    if (info == null) {
      return "支持以下格式图片:\n"
              "- JPG \n"
              "- PNG / Animated APNG \n"
              "- GIF / Animated GIF \n"
              "- BMP \n"
              "- TIFF \n"
              "- TGA \n"
              "- PVR \n"
              "- ICO \n"
              "- WebP / Animated WebP \n"
              "- PSD \n"
              "- EXR \n"
              "- PNM (PBM, PGM, PPM) \n"
          .text()
          .paddingOnly(all: kH)
          .center();
    }
    return [
      "图片宽高:(${info.image.width}*${info.image.height})"
              "\n颜色通道:${info.image.numChannels}/${info.image.numFrames}"
              "\n${info.imageFormat}"
          .text()
          .paddingOnly(all: kX),
      if (tapCellValue != null)
        "命中的像素:(${tapCellValue!.x}, ${tapCellValue!.y})"
                "\n$tapCellValue"
            .text()
            .paddingOnly(all: kX),
      //--
      DropdownButton<LImageFormat>(
        items: [
          for (final format in imageEncodeFormatList)
            DropdownMenuItem(
              value: format,
              child: format.name.text(),
            ),
        ],
        value: saveFormat,
        isExpanded: true,
        onChanged: (value) {
          saveFormat = value;
          updateState();
        },
      ).matchParentWidth().paddingOnly(horizontal: kX),
      GradientButton.normal(
        () async {
          final fileName = nowTimeFileName(saveFormat?.name);
          final filePath =
              await saveFile(dialogTitle: "另存为...", fileName: fileName);
          if (!isNil(filePath)) {
            info.image.encode(saveFormat).writeToFile(filePath: filePath);
          }
        },
        child: "另存为".text(),
      ).paddingOnly(horizontal: kX),
    ].scrollVertical()!;
  }
}
