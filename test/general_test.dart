import 'package:fast_gbk/fast_gbk.dart';
import 'package:test/test.dart';

void main() {
  group('A group of general tests', () {
    setUp(() {});

    test('encoder test, Get GBK file and encode again.', () async {
      //6625:B4BA
      String testString = "春";
      print(testString + " " + testString.codeUnits.length.toString());
      testString.codeUnits.forEach((codeUnit) {
        print(codeUnit.toRadixString(16));
      });

      gbk.encode(testString).forEach((codeUnit) {
        print(codeUnit.toRadixString(16));
      });

      testString = "【";
      print(testString + " " + testString.codeUnits.length.toString());
      testString.codeUnits.forEach((codeUnit) {
        print(codeUnit.toRadixString(16));
      });

      gbk.encode(testString).forEach((codeUnit) {
        print(codeUnit.toRadixString(16));
      });
    });
  });
}
