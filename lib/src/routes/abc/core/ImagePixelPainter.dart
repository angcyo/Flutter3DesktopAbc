import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// 格子数据
  List<ImagePixelCellValue>? _cellValueList;

  /// 悬停的cell
  ImagePixelCellValue? _hoverCellValue;

  //--

  set imagePixelInfo(ImagePixelInfo? value) {
    _cellValueList = null;
    _imagePixelInfo = value;
    if (value != null) {
      initPaintProperty(
        width: imageWidth * pixelSize + (imageWidth - 1) * pixelGap,
        height: imageHeight * pixelSize + (imageHeight - 1) * pixelGap,
      );
    } else {
      initPaintProperty();
    }
    invalidate();
  }

  void test() {
    //initPaintProperty()
    //_imagePixelInfo?.image?.setPixelRgba(x, y, r, g, b, a)
  }

  ///
  @override
  void painting(Canvas canvas, PaintMeta paintMeta) {
    super.painting(canvas, paintMeta);
    if (_hoverCellValue != null) {
      if (_hoverPoint != null) {
        canvas.drawText("$_hoverCellValue",
            textColor: Colors.white,
            offset: _hoverPoint! + Offset(kMouseWidth, kMouseHeight),
            onBeforeAction: (painter, offset) {
          paint.withSavePaint(() {
            paint
              ..style = PaintingStyle.fill
              ..color = Colors.black87;
            canvas.drawRRect(
                (offset & painter.size).inflate(4).toRRect(kM), paint);
          });
        });
      }
    }
  }

  @override
  void onPaintingSelf(Canvas canvas, PaintMeta paintMeta) {
    //debugger();
    paintingSelfOnPicture((canvas) {
      final imagePixelInfo = _imagePixelInfo;
      if (imagePixelInfo != null) {
        PixelTransparentPainter(cellSize: pixelSize)
            .paint(canvas, elementsBounds?.size ?? Size.zero);

        _cellValueList = [];
        var left = 0.0;
        var top = 0.0;

        var x = 0 /*列*/;
        var y = 0 /*行*/;

        final paint = Paint()
          ..strokeWidth = 0
          ..style = PaintingStyle.fill;
        for (final pixel in imagePixelInfo.image) {
          //debugger();
          final cell = ImagePixelCellValue(
            x: x,
            y: y,
            pixel: pixel /*imagePixelInfo.image.getPixel(x, y)*/,
            bounds: Rect.fromLTWH(left, top, pixelSize, pixelSize),
          );
          _cellValueList?.add(cell);

          paint.color = cell.uiColor;
          canvas.drawRect(cell.bounds, paint);
          left += pixelSize + pixelGap;

          x++;
          if (x >= imageWidth) {
            left = 0;
            x = 0;
            y++;
            top += pixelSize + pixelGap;
          }
          /*debugger(when: pixelIndex++ == 0);*/
        }
      }
    });
    super.onPaintingSelf(canvas, paintMeta);
    if (_hoverCellValue != null) {
      paint.withSavePaint(() {
        paint
          ..style = PaintingStyle.stroke
          ..color = canvasStyle?.canvasAccentColor ?? Colors.purpleAccent;
        canvas.drawRect(_hoverCellValue!.bounds.inflate(0.5), paint);
      });
    }
    paintPropertyBounds(canvas, paintMeta, paint);
  }

  //--

  /// 鼠标悬停的位置
  @viewCoordinate
  Offset? _hoverPoint;

  @override
  bool handleEvent(PointerEvent event) {
    if (event.isPointerHover) {
      _hoverPoint = event.localPosition;
      _hoverCellValue = null;
      final point = canvasViewBox?.toScenePoint(event.localPosition);
      if (point != null) {
        _hoverCellValue = _cellValueList
            ?.findFirst((e) => e.bounds.inflate(pixelGap).contains(point));
      }
      //l.d("!!handleEvent->${event.localPosition} $point ${_hoverCellValue?.uiColor.toHexColor()}");
      refresh();
    }
    return super.handleEvent(event);
  }

  @override
  bool handleKeyEvent(KeyEvent event) {
    if (_hoverCellValue != null &&
        event.isKeyDown &&
        event.isKeyboardKey(LogicalKeyboardKey.keyC)) {
      _hoverCellValue?.toString().copy();
      //声音提示
      SystemSound.play(SystemSoundType.click);
      return true;
    }
    return super.handleKeyEvent(event);
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

/// 每个格子的数据
class ImagePixelCellValue {
  //--

  /// 第几列
  final int x;

  /// 第几行
  final int y;

  //--

  /// 在UI中的颜色
  Color uiColor;
  num r;
  num g;
  num b;
  num a;

  //--

  /// 在画布中的位置, 用来实现hit
  @dp
  @sceneCoordinate
  final Rect bounds;

  //--

  /*Color get uiColor => pixel.uiColor;*/

  ImagePixelCellValue({
    required this.x,
    required this.y,
    required LImagePixel pixel,
    required this.bounds,
  })  : uiColor = pixel.uiColor,
        r = pixel.r,
        g = pixel.g,
        b = pixel.b,
        a = pixel.a;

  /// 更新色值
  @api
  void updateColor(LImage image, Color color) {
    image.setPixelRgba(x, y, color.r, color.g, color.b, color.a);
    final pixel = image.getPixel(x, y);
    uiColor = pixel.uiColor;
    r = pixel.r;
    g = pixel.g;
    b = pixel.b;
    a = pixel.a;
  }

  @override
  String toString() {
    return "($a, $r, $g, $b)\n${uiColor.toHexColor()}";
  }
}
