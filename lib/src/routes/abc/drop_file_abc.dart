import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter3_desktop_app/flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/06
///
class DropFileAbc extends StatefulWidget {
  const DropFileAbc({super.key});

  @override
  State<DropFileAbc> createState() => _DropFileAbcState();
}

class _DropFileAbcState extends State<DropFileAbc> with DropStateMixin {
  String _dropStateText = "拖动文件到此区域";
  bool _isPerformDrop = false;

  @override
  Widget build(BuildContext context) {
    //return _buildDropTest(context);
    return _buildDragDropTest(context);
  }

  /// super_drag_and_drop
  Widget _buildDragDropTest(BuildContext context) {
    return DropRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      formats: Formats.standardFormats,
      onDropEnter: (event) {
        _isPerformDrop = false;
        l.d("onDropEnter->$event");
        _dropStateText = "放手吧...";
        updateState();
      },
      onDropLeave: (event) {
        l.d("onDropLeave->$event");
        if (!_isPerformDrop) {
          _dropStateText = "拖动文件到此区域";
        }
        updateState();
      },
      onDropEnded: (event) {
        l.d("onDropEnded->$event");
        if (!_isPerformDrop) {
          _dropStateText = "拖动文件到此区域";
        }
        updateState();
      },
      onPerformDrop: (details) async {
        //debugger();
        _isPerformDrop = true;
        l.d("onPerformDrop->$details");
        final texts = await details.session.texts;
        final uris = await details.session.uris;

        for (final uri in uris) {
          l.d("uri filePath->${uri.filePath.decodeUri()}");
        }

        _dropStateText =
            "${max(uris.size(), texts.size())}↓ \n${uris.join("\n")}${texts.join("\n")}\n${details.position.local}\n${details.position.global}}";
        //debugger();
        updateState();

        // Called when user dropped the item. You can now request the data.
        // Note that data must be requested before the performDrop callback
        // is over.
        final item = details.session.items.first;

        // data reader is available now
        final reader = item.dataReader!;

        if (reader.canProvide(Formats.png)) {
          reader.getFile(Formats.png, (file) {
            debugger();
            // Binary files may be too large to be loaded in memory and thus
            // are exposed as stream.
            final stream = file.getStream();

            // Alternatively, if you know that that the value is small enough,
            // you can read the entire value into memory:
            // (note that readAll is mutually exclusive with getStream(), you
            // can only use one of them)
            // final data = file.readAll();

            debugger();
          }, onError: (error) {
            print('Error reading value $error');
          });
        }
      },
      onDropOver: (event) {
        _isPerformDrop = false;
        _dropStateText =
            "放手吧...\n${event.session.toLogString()}\n${event.position.local}\n${event.position.global}";
        updateState();
        //l.d("onDropOver->$event");
        // You can inspect local data here, as well as formats of each item.
        // However on certain platforms (mobile / web) the actual data is
        // only available when the drop is accepted (onPerformDrop).
        final item = event.session.items.first;
        if (item.localData is Map) {
          // This is a drag within the app and has custom local data set.
        }
        if (item.canProvide(Formats.plainText)) {
          // this item contains plain text.
        }
        // This drop region only supports copy operation.
        if (event.session.allowedOperations.contains(DropOperation.copy)) {
          return DropOperation.copy;
        } else {
          return DropOperation.none;
        }
      },
      child: Center(child: Text(_dropStateText)),
    );
  }

  /// desktop_drop
/*Widget _buildDropTest(BuildContext context) {
    return DropTarget(
      onDragEntered: (event) {
        _dropStateText = "放手吧...";
        updateState();
      },
      onDragExited: (event) {
        _dropStateText = "拖动文件到此区域";
        updateState();
      },
      onDragDone: (details) {
        _dropStateText =
            "${details.files.size()}↓\n${details.files.connect("\n", (e) => e.toLogString())}\n${details.localPosition}\n${details.globalPosition}";
        updateState();
      },
      onDragUpdated: (event) {
        _dropStateText =
            "放手吧...\n${event.localPosition}\n${event.globalPosition}";
        updateState();
      },
      child: Center(child: Text(_dropStateText)),
    );
  }*/
}
