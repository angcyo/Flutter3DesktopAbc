import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:vector_math/vector_math.dart' as vector_math;

///
/// Email:angcyo@126.com
/// @author angcyo
/// @date 2025/01/28
///
class GpuAbc extends StatefulWidget {
  const GpuAbc({super.key});

  @override
  State<GpuAbc> createState() => _GpuAbcState();
}

class _GpuAbcState extends State<GpuAbc> {
  @override
  Widget build(BuildContext context) {
    return paintWidget((canvas, size) {
      //https://medium.com/flutter/getting-started-with-flutter-gpu-f33d497b7c11

      // Attempt to access `gpu.gpuContext`.
      // If Flutter GPU isn't supported, an exception will be thrown.

      //Flutter GPU requires the Impeller rendering backend to be enabled.
      //flutter run -d macos --enable-impeller
      //Default color format: PixelFormat.b8g8r8a8UNormInt
      l.d('Default color format: ${gpu.gpuContext.defaultColorFormat}');

      try {
        final texture = gpu.gpuContext.createTexture(
            gpu.StorageMode.devicePrivate,
            (size.width / 2).toInt(),
            (size.height / 2).toInt())!;

        final renderTarget = gpu.RenderTarget.singleColor(gpu.ColorAttachment(
            texture: texture, clearValue: vector_math.Colors.lightBlue));

        final commandBuffer = gpu.gpuContext.createCommandBuffer();
        final renderPass = commandBuffer.createRenderPass(renderTarget);
        // ... draw calls will go here!

        /*final vert = gpu.shaderLibrary['SimpleVertex']!;
        final frag = gpu.shaderLibrary['SimpleFragment']!;
        final pipeline = gpu.gpuContext.createRenderPipeline(vert, frag);*/

        final vertices = Float32List.fromList([
          -0.5, -0.5, // First vertex
          0.5, -0.5, // Second vertex
          0.0, 0.5, // Third vertex
        ]);
        final verticesDeviceBuffer = gpu.gpuContext
            .createDeviceBufferWithCopy(ByteData.sublistView(vertices))!;
        //renderPass.bindPipeline(pipeline);

        final verticesView = gpu.BufferView(
          verticesDeviceBuffer,
          offsetInBytes: 0,
          lengthInBytes: verticesDeviceBuffer.sizeInBytes,
        );
        renderPass.bindVertexBuffer(verticesView, 3);

        //renderPass.draw();

        //
        commandBuffer.submit();
        final image = texture.asImage();
        canvas.drawImage(image, Offset.zero, Paint());
      } catch (e, s) {
        printError(e, s);
      }
    });
  }
}
