import 'dart:ui';

import 'package:flutter3_canvas/flutter3_canvas.dart';
import 'package:flutter3_code/flutter3_code.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/14
///
/// 用来在[CanvasDelegate]中绘制的对象
class ImagePixelPainter extends ElementPainter {
  //--

  /// 每个像素需要绘制的大小
  @dp
  @sceneCoordinate
  @configProperty
  double pixelSize = 4;

  /// 每个像素之间的间距
  @dp
  @sceneCoordinate
  @configProperty
  double pixelGap = 1;

  //--

  ImagePixelInfo? _imagePixelInfo;

  int get imageWidth => _imagePixelInfo?.image.width ?? 0;

  int get imageHeight => _imagePixelInfo?.image.height ?? 0;

  /// 缓存绘制的图片
  Picture? _picture;

  //--

  set imagePixelInfo(ImagePixelInfo? value) {
    _imagePixelInfo = value;
    if (value != null) {
      initPaintProperty(
        width: imageWidth * pixelSize + (imageWidth - 1) * pixelGap,
        height: imageHeight * pixelSize + (imageHeight - 1) * pixelGap,
      );
    } else {
      initPaintProperty();
    }
    _picture = drawPicture((canvas) {
      final imagePixelInfo = _imagePixelInfo;
      if (imagePixelInfo != null) {
        var left = 0.0;
        var top = 0.0;
        var pixelIndex = 0;
        final paint = Paint()
          ..strokeWidth = 0
          ..style = PaintingStyle.fill;
        for (final pixel in imagePixelInfo.image) {
          paint.color = pixel.uiColor;
          canvas.drawRect(
              Rect.fromLTWH(left, top, pixelSize, pixelSize), paint);
          left += pixelSize + pixelGap;

          pixelIndex++;
          if (pixelIndex >= imageWidth) {
            left = 0;
            pixelIndex = 0;
            top += pixelSize + pixelGap;
          }
          /*debugger(when: pixelIndex++ == 0);*/
        }
      }
    });
    refresh();
  }

  void test() {
    //initPaintProperty()
  }

  ///
  @override
  void painting(Canvas canvas, PaintMeta paintMeta) {
    super.painting(canvas, paintMeta);
  }

  @override
  void onPaintingSelf(Canvas canvas, PaintMeta paintMeta) {
    //debugger();
    super.onPaintingSelf(canvas, paintMeta);
    if (_picture != null) {
      canvas.drawPicture(_picture!);
    }
    paintPropertyBounds(canvas, paintMeta, paint);
  }
}

/// 图片像素信息
class ImagePixelInfo {
  /// 图片格式
  final LImageFormat imageFormat;

  /// 图片数据
  final LImage image;

  ImagePixelInfo({
    required this.imageFormat,
    required this.image,
  });
}
