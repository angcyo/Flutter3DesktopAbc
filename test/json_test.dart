import 'dart:convert';
import 'dart:io';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2026/01/14
///
void main() async {
  final jsonFilePath = "/Users/angcyo/Downloads/Untitled-1.json";
  final file = File(jsonFilePath);
  final text = await file.readAsString();
  final json = jsonDecode(text);

  final list = json["data"] as List;

  //--
  final cnResultMap = <String, dynamic>{};
  final enResultMap = <String, dynamic>{};
  for (final obj in list) {
    cnResultMap[obj["materialKey"]] = obj["nameCn"];
    enResultMap[obj["materialKey"]] = obj["nameEn"];
  }
  //--
  final cnBuilder = StringBuffer();
  final enBuilder = StringBuffer();
  for (final key in cnResultMap.keys) {
    cnBuilder.writeln('<string name="$key">${cnResultMap[key]}</string>');
  }

  for (final key in enResultMap.keys) {
    enBuilder.writeln('<string name="$key">${enResultMap[key]}</string>');
  }

  print(cnBuilder);
  print("\n\n");
  print(enBuilder);
}
