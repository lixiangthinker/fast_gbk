import 'package:fast_gbk/fast_gbk.dart';
import 'package:test/test.dart';
///
/// Simple encode and decode test, using gbk.encode / gbk.decode
///
void main() {
  group('A group of general tests', () {
    setUp(() {});

    test('simple encoder test', () async {
      //6625:B4BA
      testEncode("春", [0xB4, 0xBA]);
      //590F:CFC4
      testEncode("夏", [0xCF, 0xC4]);
      //79CB：C7EF
      testEncode("秋", [0xC7, 0xEF]);
      //51AC:B6AC
      testEncode("冬", [0xB6, 0xAC]);
      //E7B3:A7F6 GBK error character
      testEncode("", [0xA7, 0xF6]);
      //3010:A1BE
      testEncode("【", [0xA1, 0xBE]);
    });

    test('encoder test, only print values for test purpose.', () async {
      String testString = "A";
      print(testString + " " + testString.codeUnits.length.toString());
      testString.codeUnits.forEach((codeUnit) {
        print(codeUnit.toRadixString(16));
      });
      List<int> encoded = gbk.encode(testString);
      print("\tGBK = [${codeUnitsToString(encoded)}");
    }, skip: true);

    test('simple decoder test', () async {
      testDecode([0xB4, 0xBA], "春");
      testDecode([0xCF, 0xC4], "夏");
      testDecode([0xC7, 0xEF], "秋");
      testDecode([0xB6, 0xAC], "冬");
      testDecode([0xA7, 0xF6], "");
      testDecode([0xA1, 0xBE], "【");
    });
  });
}

void testEncode(String input, List<int> expectResult) {
  String testString = input;
  print("String = ${testString}\n\tUTF-16 = ${codeUnitsToString(testString.codeUnits)}");
  List<int> encoded = gbk.encode(testString);

  expect(encoded.length, 2);
  expect(encoded.length, expectResult.length);
  for (int i = 0; i < encoded.length; i++) {
    expect(encoded[i], expectResult[i]);
  }

  print("\tGBK = ${codeUnitsToString(encoded)}");
}

String codeUnitsToString(List<int> codeUnits) {
  StringBuffer sb = StringBuffer("[");
  codeUnits.forEach((codeUnit) {
    sb.write("0x" + codeUnit.toRadixString(16) + ",");
  });
  sb.write("]");
  return sb.toString();
}

void testDecode(List<int> inputList, String expectResult) {
  print("GBK = ${codeUnitsToString(inputList)}");
  String decoded = gbk.decode(inputList);
  expect(decoded, expectResult);
  print("\tString = $decoded");
}
