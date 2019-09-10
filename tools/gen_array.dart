import 'dart:io';

///
/// Generate map for gbk encoder and decoder.
///
void main() async {
  File unicode2GBK = File("gbkuni30.txt");
  List<String> charsetGBK = unicode2GBK.readAsLinesSync();

  //String class is using utf-16 (1 bytes, 2 bytes or 3 bytes),
  //GBK is 2 bytes in general, only ASCII using 1 bytes.

  Map<int, int> utf16ToGBKMap = {};
  Map<int, int> gbkToUtf16Map = {};

  charsetGBK.forEach((line) {
    //print(line);
    if (line.startsWith("//")) {
      //comment line;
    } else {
      List<String> segments = line.split(":");
      var key = int.parse(segments[0], radix: 16);
      var value = int.parse(segments[1], radix: 16);
      if (value < 0x80) return;
      utf16ToGBKMap[key] = value;
      gbkToUtf16Map[value] = key;
    }
  });

  print("utf16ToGBKMap.length = ${utf16ToGBKMap.length}");
  print("gbkToUtf16Map.length = ${gbkToUtf16Map.length}");

  //gbk_decoder_map.dart
  File decodeMap = File("gbk_decoder_map.dart");
  if (await decodeMap.exists()) await decodeMap.delete();
  decodeMap.writeAsStringSync("Map<int, int> gbkToUtf16Map = \n", mode: FileMode.append);
  decodeMap.writeAsStringSync("{ \n", mode: FileMode.append);
  gbkToUtf16Map.forEach((key, value) {
    decodeMap.writeAsStringSync("  $key:$value, \n", mode: FileMode.append);
  });
  decodeMap.writeAsStringSync("};", mode: FileMode.append);

  //gbk_encoder_map.dart
  File encoderMap = File("gbk_encoder_map.dart");
  if (await encoderMap.exists()) await encoderMap.delete();
  encoderMap.writeAsStringSync("Map<int, int> utf16ToGBKMap = \n", mode: FileMode.append);
  encoderMap.writeAsStringSync("{ \n", mode: FileMode.append);

  utf16ToGBKMap.forEach((key, value) {
    encoderMap.writeAsStringSync("  $key:$value, \n", mode: FileMode.append);
  });
  encoderMap.writeAsStringSync("};", mode: FileMode.append);
}