import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:test/test.dart';

void main() {
  group('A group of decoding and encoding file tests', () {
    setUp(() {
    });

    test('decoder test, Get GBK file', () async {
      var begin = DateTime.now().millisecondsSinceEpoch;

      File testFile1 = File("./test/GbkFile/gbk_test_file_1.txt");
      String result1 = testFile1.readAsStringSync(encoding: gbk);
      print(result1);

      File testFile2 = File("./test/GbkFile/gbk_test_file_2.txt");
      String result2 = testFile2.readAsStringSync(encoding: gbk);
      print(result2);

      var end = DateTime.now().millisecondsSinceEpoch;
      print("gbk.decode cost ${end - begin}ms, responseLength = ${result1.length + result2.length}");
      expect((end - begin) < 100, true);
    }, skip: false);

    test('encoder test, Get GBK file and encode again.', () async {
      File testFile2 = File("./test/GbkFile/gbk_test_file_2.txt");
      String content = testFile2.readAsStringSync(encoding: gbk);

      var begin = DateTime.now().millisecondsSinceEpoch;
      Uint8List encoded = gbk.encode(content);
      var end = DateTime.now().millisecondsSinceEpoch;
      print("gbk.encode cost ${end - begin}ms, string length = ${content.length}");

      String finalContent = gbk.decode(encoded);
      print("final = ${finalContent.length} original = ${content.length}");
      expect(finalContent.length == content.length, true);
    }, skip: false);

    tearDown((){

    });
  });
}
