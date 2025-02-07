import 'package:flutter/material.dart';
import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_code/flutter3_code.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

import '../core/image_pixel_painter.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/14
///
/// 图片像素属性信息, 以及导出控制
class ImagePixelPropertyControlWidget extends StatefulWidget {
  final CanvasDelegate canvasDelegate;

  final ImagePixelPainter imagePixelPainter;

  const ImagePixelPropertyControlWidget(
      this.canvasDelegate, this.imagePixelPainter,
      {super.key});

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

  //--

  Color get paintColor => widget.imagePixelPainter.cellPaintColor;

  set paintColor(Color value) {
    widget.imagePixelPainter.cellPaintColor = value;
    updateState();
  }

  bool get editColor => widget.imagePixelPainter.enableCellColorEdit;

  set editColor(bool value) {
    widget.imagePixelPainter.enableCellColorEdit = value;
    updateState();
  }

  //--

  /// 需要保存的图片格式
  LImageFormat? saveFormat = LImageFormat.png;

  final TextFieldConfig outputWidthConfig = TextFieldConfig(
    text: "_lastOutputWidthConfig".hiveGet(),
    inputFormatters: [
      integerTextInputFormatter,
    ],
    onChanged: (value) {
      "_lastOutputWidthConfig".hivePut(value);
    },
  );
  final TextFieldConfig outputHeightConfig = TextFieldConfig(
    text: "_lastOutputHeightConfig".hiveGet(),
    inputFormatters: [
      integerTextInputFormatter,
    ],
    onChanged: (value) {
      "_lastOutputHeightConfig".hivePut(value);
    },
  );

  @override
  void initState() {
    widget.imagePixelPainter.onTapCellAction = (value) {
      updateState();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
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
      "图片信息"
          .text(style: globalTheme.textTitleStyle, bold: true)
          .paddingOnly(horizontal: kX, top: kH),
      "${info.imageFormat}"
              "\n图片宽高:(${info.image.width}*${info.image.height})"
              "\n颜色通道:${info.image.numChannels}/${info.image.numFrames}"
          .text()
          .paddingOnly(all: kX),
      if (tapCellValue != null)
        "命中的像素:(${tapCellValue!.x}, ${tapCellValue!.y})"
                "\n$tapCellValue"
            .text()
            .paddingOnly(horizontal: kX),
      //--
      "编辑信息"
          .text(style: globalTheme.textTitleStyle, bold: true)
          .paddingOnly(horizontal: kX, top: kH * 10),
      SwitchTile(
        text: "编辑颜色:",
        tilePadding: edgeOnly(horizontal: kX, vertical: kH),
        value: editColor,
        onValueChanged: (value) {
          editColor = value;
        },
      ),
      "画笔颜色: "
          .text()
          .rowOf(
              paintWidget((canvas, size) {
                //颜色提示
                PixelTransparentPainter(cellSize: 4).paint(canvas, size);
                canvas.drawRect(
                  Offset.zero & size,
                  Paint()
                    ..style = PaintingStyle.fill
                    ..color = paintColor,
                );
                canvas.drawRect(
                  Offset.zero & size,
                  Paint()
                    ..style = PaintingStyle.stroke
                    ..color = Colors.black,
                );
              }, size: Size(20, 20)),
              mainAxisAlignment: MainAxisAlignment.start)
          .paddingOnly(horizontal: kX, top: kH)
          .ink(() {
        context.pickColor(
          paintColor,
          onColorAction: (value) {
            paintColor = value;
          },
          hexInputBar: true,
        );
      }),
      [
        "输出宽度: ".text(),
        SingleInputWidget(config: outputWidthConfig).expanded(),
      ].row()!.paddingOnly(horizontal: kX, top: kH),
      [
        "输出高度: ".text(),
        SingleInputWidget(config: outputHeightConfig).expanded(),
      ].row()!.paddingOnly(horizontal: kX, top: kH),
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
      ).matchParentWidth().paddingOnly(horizontal: kX, bottom: kH),
      [
        GradientButton.normal(
          () async {
            if (editColor) {
              widget.imagePixelPainter.setAllColor();
            }
          },
          child: "一键设置".text(),
        ),
        GradientButton.normal(
          () async {
            final fileName = nowTimeFileName(saveFormat?.name);
            final filePath =
                await saveFile(dialogTitle: "另存为...", fileName: fileName);
            if (!isNil(filePath)) {
              final outputWidth = outputWidthConfig.text.toDoubleOrNull() ?? 0;
              final outputHeight =
                  outputHeightConfig.text.toDoubleOrNull() ?? 0;
              final resize = outputWidth > 0 && outputHeight > 0
                  ? Size(outputWidth, outputHeight)
                  : null;
              info.image
                  .encode(saveFormat, resize: resize)
                  .writeToFile(filePath: filePath);
            }
          },
          child: "另存为".text(),
        ),
        GradientButton.normal(
          () async {
            context.showWidgetDialog(
              CanvasFollowTestDialog(widget.canvasDelegate),
              barrierColor: Colors.transparent,
            );
          },
          child: "test".text(),
        ),
      ].flowLayout(padding: edgeOnly(horizontal: kX), childGap: kX),
    ].scrollVertical()!;
  }
}
