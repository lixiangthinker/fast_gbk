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
      if (gbkToUtf16Map.containsKey(value)) {
        print("{GBK, UTF-16, UTF-16}  [0x${value.toRadixString(16)}, "
            "0x${gbkToUtf16Map[value].toRadixString(16)}, "
            "0x${key.toRadixString(16)}, ${String.fromCharCode(gbkToUtf16Map[value])}, ${String.fromCharCode(key)}]");
//        print("gbkToUtf16Map new [0x${value.toRadixString(16)}, 0x${key.toRadixString(16)}]");
      } else {
        gbkToUtf16Map[value] = key;
      }
    }
  });

  print("utf16ToGBKMap.length = ${utf16ToGBKMap.length}");
  print("gbkToUtf16Map.length = ${gbkToUtf16Map.length}");

  //gbk_decoder_map.dart
  File decodeMap = File("gbk_decoder_map.dart");
  if (await decodeMap.exists()) await decodeMap.delete();
  decodeMap.writeAsStringSync("Map<int, int> gbkToUtf16Map = \n",
      mode: FileMode.append);
  decodeMap.writeAsStringSync("{ \n", mode: FileMode.append);
  gbkToUtf16Map.forEach((key, value) {
    decodeMap.writeAsStringSync("  $key:$value, \n", mode: FileMode.append);
  });
  decodeMap.writeAsStringSync("};", mode: FileMode.append);

  //gbk_encoder_map.dart
  File encoderMap = File("gbk_encoder_map.dart");
  if (await encoderMap.exists()) await encoderMap.delete();
  encoderMap.writeAsStringSync("Map<int, int> utf16ToGBKMap = \n",
      mode: FileMode.append);
  encoderMap.writeAsStringSync("{ \n", mode: FileMode.append);

  utf16ToGBKMap.forEach((key, value) {
    encoderMap.writeAsStringSync("  $key:$value, \n", mode: FileMode.append);
  });
  encoderMap.writeAsStringSync("};", mode: FileMode.append);
}

///
/// The following GBK code has two UTF-16 word, for encoding, we point to
/// the first.
/// [GBK, UTF-16, UTF-16]
//  [0xfe50, 0x2e81, 0xe815, ⺁, ]
//  [0xfe54, 0x2e84, 0xe819, ⺄, ]
//  [0xfe55, 0x3473, 0xe81a, 㑳, ]
//  [0xfe56, 0x3447, 0xe81b, 㑇, ]
//  [0xfe57, 0x2e88, 0xe81c, ⺈, ]
//  [0xfe58, 0x2e8b, 0xe81d, ⺋, ]
//  [0xfe5a, 0x359e, 0xe81f, 㖞, ]
//  [0xfe5b, 0x361a, 0xe820, 㘚, ]
//  [0xfe5c, 0x360e, 0xe821, 㘎, ]
//  [0xfe5d, 0x2e8c, 0xe822, ⺌, ]
//  [0xfe5e, 0x2e97, 0xe823, ⺗, ]
//  [0xfe5f, 0x396e, 0xe824, 㥮, ]
//  [0xfe60, 0x3918, 0xe825, 㤘, ]
//  [0xfe62, 0x39cf, 0xe827, 㧏, ]
//  [0xfe63, 0x39df, 0xe828, 㧟, ]
//  [0xfe64, 0x3a73, 0xe829, 㩳, ]
//  [0xfe65, 0x39d0, 0xe82a, 㧐, ]
//  [0xfe68, 0x3b4e, 0xe82d, 㭎, ]
//  [0xfe69, 0x3c6e, 0xe82e, 㱮, ]
//  [0xfe6a, 0x3ce0, 0xe82f, 㳠, ]
//  [0xfe6b, 0x2ea7, 0xe830, ⺧, ]
//  [0xfe6e, 0x2eaa, 0xe833, ⺪, ]
//  [0xfe6f, 0x4056, 0xe834, 䁖, ]
//  [0xfe70, 0x415f, 0xe835, 䅟, ]
//  [0xfe71, 0x2eae, 0xe836, ⺮, ]
//  [0xfe72, 0x4337, 0xe837, 䌷, ]
//  [0xfe73, 0x2eb3, 0xe838, ⺳, ]
//  [0xfe74, 0x2eb6, 0xe839, ⺶, ]
//  [0xfe75, 0x2eb7, 0xe83a, ⺷, ]
//  [0xfe77, 0x43b1, 0xe83c, 䎱, ]
//  [0xfe78, 0x43ac, 0xe83d, 䎬, ]
//  [0xfe79, 0x2ebb, 0xe83e, ⺻, ]
//  [0xfe7a, 0x43dd, 0xe83f, 䏝, ]
//  [0xfe7b, 0x44d6, 0xe840, 䓖, ]
//  [0xfe7c, 0x4661, 0xe841, 䙡, ]
//  [0xfe7d, 0x464c, 0xe842, 䙌, ]
//  [0xfe80, 0x4723, 0xe844, 䜣, ]
//  [0xfe81, 0x4729, 0xe845, 䜩, ]
//  [0xfe82, 0x477c, 0xe846, 䝼, ]
//  [0xfe83, 0x478d, 0xe847, 䞍, ]
//  [0xfe84, 0x2eca, 0xe848, ⻊, ]
//  [0xfe85, 0x4947, 0xe849, 䥇, ]
//  [0xfe86, 0x497a, 0xe84a, 䥺, ]
//  [0xfe87, 0x497d, 0xe84b, 䥽, ]
//  [0xfe88, 0x4982, 0xe84c, 䦂, ]
//  [0xfe89, 0x4983, 0xe84d, 䦃, ]
//  [0xfe8a, 0x4985, 0xe84e, 䦅, ]
//  [0xfe8b, 0x4986, 0xe84f, 䦆, ]
//  [0xfe8c, 0x499f, 0xe850, 䦟, ]
//  [0xfe8d, 0x499b, 0xe851, 䦛, ]
//  [0xfe8e, 0x49b7, 0xe852, 䦷, ]
//  [0xfe8f, 0x49b6, 0xe853, 䦶, ]
//  [0xfe92, 0x4ca3, 0xe856, 䲣, ]
//  [0xfe93, 0x4c9f, 0xe857, 䲟, ]
//  [0xfe94, 0x4ca0, 0xe858, 䲠, ]
//  [0xfe95, 0x4ca1, 0xe859, 䲡, ]
//  [0xfe96, 0x4c77, 0xe85a, 䱷, ]
//  [0xfe97, 0x4ca2, 0xe85b, 䲢, ]
//  [0xfe98, 0x4d13, 0xe85c, 䴓, ]
//  [0xfe99, 0x4d14, 0xe85d, 䴔, ]
//  [0xfe9a, 0x4d15, 0xe85e, 䴕, ]
//  [0xfe9b, 0x4d16, 0xe85f, 䴖, ]
//  [0xfe9c, 0x4d17, 0xe860, 䴗, ]
//  [0xfe9d, 0x4d18, 0xe861, 䴘, ]
//  [0xfe9e, 0x4d19, 0xe862, 䴙, ]
//  [0xfe9f, 0x4dae, 0xe863, 䶮, ]
///
///
