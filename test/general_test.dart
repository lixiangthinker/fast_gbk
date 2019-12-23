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
      testEncode('春', [0xB4, 0xBA]);
      //590F:CFC4
      testEncode('夏', [0xCF, 0xC4]);
      //79CB：C7EF
      testEncode('秋', [0xC7, 0xEF]);
      //51AC:B6AC
      testEncode('冬', [0xB6, 0xAC]);
      //E7B3:A7F6 GBK error character
      testEncode('', [0xA7, 0xF6]);
      //3010:A1BE
      testEncode('【', [0xA1, 0xBE]);
    });

    test('encoder test, only print values for test purpose.', () async {
      var testString = 'A';
      print('$testString ${testString.codeUnits.length.toString()}');
      testString.codeUnits.forEach((codeUnit) {
        print(codeUnit.toRadixString(16));
      });
      var encoded = gbk.encode(testString);
      print('\tGBK = [${codeUnitsToString(encoded)}');
    }, skip: true);

    test('simple decoder test', () async {
      testDecode([0xB4, 0xBA], '春');
      testDecode([0xCF, 0xC4], '夏');
      testDecode([0xC7, 0xEF], '秋');
      testDecode([0xB6, 0xAC], '冬');
      testDecode([0xA7, 0xF6], '');
      testDecode([0xA1, 0xBE], '【');
    });

// need to add to map, following link not complete.
// https://ssl.icu-project.org/repos/icu/data/trunk/charset/source/gb18030/gbkuni30.txt
//
//    FE ０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ
//    ４ 兀 嗀 﨎 﨏 﨑 﨓 﨔 礼 﨟 蘒 﨡 﨣 﨤 﨧 﨨 﨩
//    ５                
//    ６                
//    ７               
//    ８                
//    ９                
//    Ａ 

//    FE ０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ
//    ４ 兀 嗀 﨎 﨏 﨑 﨓 﨔 礼 﨟 蘒 﨡 﨣 﨤 﨧 﨨 﨩
//    ５                
//    ６                
//    ７               
//    ８                
//    ９                
//    Ａ 

    test('encoder test, only print values for test purpose.', () async {
//    FE ０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ
//    ５                
//    ５                
      printUtf16GbkPair('', 'FE50');
      printUtf16GbkPair('', 'FE54');
      printUtf16GbkPair('', 'FE55');
      printUtf16GbkPair('', 'FE56');
      printUtf16GbkPair('', 'FE57');
      printUtf16GbkPair('', 'FE58');
      printUtf16GbkPair('', 'FE5A');
      printUtf16GbkPair('', 'FE5B');
      printUtf16GbkPair('', 'FE5C');
      printUtf16GbkPair('', 'FE5D');
      printUtf16GbkPair('', 'FE5E');
      printUtf16GbkPair('', 'FE5F');

//    FE ０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ
//    ６                
//    ６                
      printUtf16GbkPair('', 'FE60');
      printUtf16GbkPair('', 'FE62');
      printUtf16GbkPair('', 'FE63');
      printUtf16GbkPair('', 'FE64');
      printUtf16GbkPair('', 'FE65');
      printUtf16GbkPair('', 'FE68');
      printUtf16GbkPair('', 'FE69');
      printUtf16GbkPair('', 'FE6A');
      printUtf16GbkPair('', 'FE6B');
      printUtf16GbkPair('', 'FE6E');
      printUtf16GbkPair('', 'FE6F');
//    FE ０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ
//    ７               
//    ７               
      printUtf16GbkPair('', 'FE70');
      printUtf16GbkPair('', 'FE71');
      printUtf16GbkPair('', 'FE72');
      printUtf16GbkPair('', 'FE73');
      printUtf16GbkPair('', 'FE74');
      printUtf16GbkPair('', 'FE75');
      printUtf16GbkPair('', 'FE77');
      printUtf16GbkPair('', 'FE78');
      printUtf16GbkPair('', 'FE79');
      printUtf16GbkPair('', 'FE7A');
      printUtf16GbkPair('', 'FE7B');
      printUtf16GbkPair('', 'FE7C');
      printUtf16GbkPair('', 'FE7D');

//    FE ０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ
//    ８                
//    ８                
      printUtf16GbkPair('', 'FE80');
      printUtf16GbkPair('', 'FE81');
      printUtf16GbkPair('', 'FE82');
      printUtf16GbkPair('', 'FE83');
      printUtf16GbkPair('', 'FE84');
      printUtf16GbkPair('', 'FE85');
      printUtf16GbkPair('', 'FE86');
      printUtf16GbkPair('', 'FE87');
      printUtf16GbkPair('', 'FE88');
      printUtf16GbkPair('', 'FE89');
      printUtf16GbkPair('', 'FE8A');
      printUtf16GbkPair('', 'FE8B');
      printUtf16GbkPair('', 'FE8C');
      printUtf16GbkPair('', 'FE8D');
      printUtf16GbkPair('', 'FE8E');
      printUtf16GbkPair('', 'FE8F');

//    FE ０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ
//    ９                
//    ９                
      printUtf16GbkPair('', 'FE92');
      printUtf16GbkPair('', 'FE93');
      printUtf16GbkPair('', 'FE94');
      printUtf16GbkPair('', 'FE95');
      printUtf16GbkPair('', 'FE96');
      printUtf16GbkPair('', 'FE97');
      printUtf16GbkPair('', 'FE98');
      printUtf16GbkPair('', 'FE99');
      printUtf16GbkPair('', 'FE9A');
      printUtf16GbkPair('', 'FE9B');
      printUtf16GbkPair('', 'FE9C');
      printUtf16GbkPair('', 'FE9D');
      printUtf16GbkPair('', 'FE9E');
      printUtf16GbkPair('', 'FE9F');
    });

    test('simple decoder test', () async {
      print(String.fromCharCode(11905));
      print(String.fromCharCode(59413));

      print(String.fromCharCode(11908));
      print(String.fromCharCode(59417));
    });

    test('UTF-16 have same GBK char', () async {
      // some 'UTF-16 have same GBK char', here's the list:
    });
//    gbkToUtf16Map original [65104, 11905]
//    gbkToUtf16Map new [65104, 59413]
//    gbkToUtf16Map original [65108, 11908]
//    gbkToUtf16Map new [65108, 59417]
//    gbkToUtf16Map original [65109, 13427]
//    gbkToUtf16Map new [65109, 59418]
//    gbkToUtf16Map original [65110, 13383]
//    gbkToUtf16Map new [65110, 59419]
//    gbkToUtf16Map original [65111, 11912]
//    gbkToUtf16Map new [65111, 59420]
//    gbkToUtf16Map original [65112, 11915]
//    gbkToUtf16Map new [65112, 59421]
//    gbkToUtf16Map original [65114, 13726]
//    gbkToUtf16Map new [65114, 59423]
//    gbkToUtf16Map original [65115, 13850]
//    gbkToUtf16Map new [65115, 59424]
//    gbkToUtf16Map original [65116, 13838]
//    gbkToUtf16Map new [65116, 59425]
//    gbkToUtf16Map original [65117, 11916]
//    gbkToUtf16Map new [65117, 59426]
//    gbkToUtf16Map original [65118, 11927]
//    gbkToUtf16Map new [65118, 59427]
//    gbkToUtf16Map original [65119, 14702]
//    gbkToUtf16Map new [65119, 59428]
//    gbkToUtf16Map original [65120, 14616]
//    gbkToUtf16Map new [65120, 59429]
//    gbkToUtf16Map original [65122, 14799]
//    gbkToUtf16Map new [65122, 59431]
//    gbkToUtf16Map original [65123, 14815]
//    gbkToUtf16Map new [65123, 59432]
//    gbkToUtf16Map original [65124, 14963]
//    gbkToUtf16Map new [65124, 59433]
//    gbkToUtf16Map original [65125, 14800]
//    gbkToUtf16Map new [65125, 59434]
//    gbkToUtf16Map original [65128, 15182]
//    gbkToUtf16Map new [65128, 59437]
//    gbkToUtf16Map original [65129, 15470]
//    gbkToUtf16Map new [65129, 59438]
//    gbkToUtf16Map original [65130, 15584]
//    gbkToUtf16Map new [65130, 59439]
//    gbkToUtf16Map original [65131, 11943]
//    gbkToUtf16Map new [65131, 59440]
//    gbkToUtf16Map original [65134, 11946]
//    gbkToUtf16Map new [65134, 59443]
//    gbkToUtf16Map original [65135, 16470]
//    gbkToUtf16Map new [65135, 59444]
//    gbkToUtf16Map original [65136, 16735]
//    gbkToUtf16Map new [65136, 59445]
//    gbkToUtf16Map original [65137, 11950]
//    gbkToUtf16Map new [65137, 59446]
//    gbkToUtf16Map original [65138, 17207]
//    gbkToUtf16Map new [65138, 59447]
//    gbkToUtf16Map original [65139, 11955]
//    gbkToUtf16Map new [65139, 59448]
//    gbkToUtf16Map original [65140, 11958]
//    gbkToUtf16Map new [65140, 59449]
//    gbkToUtf16Map original [65141, 11959]
//    gbkToUtf16Map new [65141, 59450]
//    gbkToUtf16Map original [65143, 17329]
//    gbkToUtf16Map new [65143, 59452]
//    gbkToUtf16Map original [65144, 17324]
//    gbkToUtf16Map new [65144, 59453]
//    gbkToUtf16Map original [65145, 11963]
//    gbkToUtf16Map new [65145, 59454]
//    gbkToUtf16Map original [65146, 17373]
//    gbkToUtf16Map new [65146, 59455]
//    gbkToUtf16Map original [65147, 17622]
//    gbkToUtf16Map new [65147, 59456]
//    gbkToUtf16Map original [65148, 18017]
//    gbkToUtf16Map new [65148, 59457]
//    gbkToUtf16Map original [65149, 17996]
//    gbkToUtf16Map new [65149, 59458]
//    gbkToUtf16Map original [65152, 18211]
//    gbkToUtf16Map new [65152, 59460]
//    gbkToUtf16Map original [65153, 18217]
//    gbkToUtf16Map new [65153, 59461]
//    gbkToUtf16Map original [65154, 18300]
//    gbkToUtf16Map new [65154, 59462]
//    gbkToUtf16Map original [65155, 18317]
//    gbkToUtf16Map new [65155, 59463]
//    gbkToUtf16Map original [65156, 11978]
//    gbkToUtf16Map new [65156, 59464]
//    gbkToUtf16Map original [65157, 18759]
//    gbkToUtf16Map new [65157, 59465]
//    gbkToUtf16Map original [65158, 18810]
//    gbkToUtf16Map new [65158, 59466]
//    gbkToUtf16Map original [65159, 18813]
//    gbkToUtf16Map new [65159, 59467]
//    gbkToUtf16Map original [65160, 18818]
//    gbkToUtf16Map new [65160, 59468]
//    gbkToUtf16Map original [65161, 18819]
//    gbkToUtf16Map new [65161, 59469]
//    gbkToUtf16Map original [65162, 18821]
//    gbkToUtf16Map new [65162, 59470]
//    gbkToUtf16Map original [65163, 18822]
//    gbkToUtf16Map new [65163, 59471]
//    gbkToUtf16Map original [65164, 18847]
//    gbkToUtf16Map new [65164, 59472]
//    gbkToUtf16Map original [65165, 18843]
//    gbkToUtf16Map new [65165, 59473]
//    gbkToUtf16Map original [65166, 18871]
//    gbkToUtf16Map new [65166, 59474]
//    gbkToUtf16Map original [65167, 18870]
//    gbkToUtf16Map new [65167, 59475]
//    gbkToUtf16Map original [65170, 19619]
//    gbkToUtf16Map new [65170, 59478]
//    gbkToUtf16Map original [65171, 19615]
//    gbkToUtf16Map new [65171, 59479]
//    gbkToUtf16Map original [65172, 19616]
//    gbkToUtf16Map new [65172, 59480]
//    gbkToUtf16Map original [65173, 19617]
//    gbkToUtf16Map new [65173, 59481]
//    gbkToUtf16Map original [65174, 19575]
//    gbkToUtf16Map new [65174, 59482]
//    gbkToUtf16Map original [65175, 19618]
//    gbkToUtf16Map new [65175, 59483]
//    gbkToUtf16Map original [65176, 19731]
//    gbkToUtf16Map new [65176, 59484]
//    gbkToUtf16Map original [65177, 19732]
//    gbkToUtf16Map new [65177, 59485]
//    gbkToUtf16Map original [65178, 19733]
//    gbkToUtf16Map new [65178, 59486]
//    gbkToUtf16Map original [65179, 19734]
//    gbkToUtf16Map new [65179, 59487]
//    gbkToUtf16Map original [65180, 19735]
//    gbkToUtf16Map new [65180, 59488]
//    gbkToUtf16Map original [65181, 19736]
//    gbkToUtf16Map new [65181, 59489]
//    gbkToUtf16Map original [65182, 19737]
//    gbkToUtf16Map new [65182, 59490]
//    gbkToUtf16Map original [65183, 19886]
//    gbkToUtf16Map new [65183, 59491]
  });
}

void printUtf16GbkPair(String string, String GbkCode) {
  var codeUnits = string.codeUnits;
  print('${codeUnits[0].toRadixString(16)}:$GbkCode');
}

void testOnlyPrint(String input) {
  var testString = input;
  print(
      'String = ${testString}\n\tUTF-16 = ${codeUnitsToString(testString.codeUnits)}');
  var encoded = gbk.encode(testString);
  print('\tGBK = [${codeUnitsToString(encoded)}');
}

void testEncode(String input, List<int> expectResult) {
  var testString = input;
  print(
      'String = ${testString}\n\tUTF-16 = ${codeUnitsToString(testString.codeUnits)}');
  var encoded = gbk.encode(testString);

  expect(encoded.length, 2);
  expect(encoded.length, expectResult.length);
  for (var i = 0; i < encoded.length; i++) {
    expect(encoded[i], expectResult[i]);
  }

  print('\tGBK = ${codeUnitsToString(encoded)}');
}

String codeUnitsToString(List<int> codeUnits) {
  var sb = StringBuffer('[');
  codeUnits.forEach((codeUnit) {
    sb.write('0x' + codeUnit.toRadixString(16) + ',');
  });
  sb.write(']');
  return sb.toString();
}

void testDecode(List<int> inputList, String expectResult) {
  print('GBK = ${codeUnitsToString(inputList)}');
  var decoded = gbk.decode(inputList);
  expect(decoded, expectResult);
  print('\tString = $decoded');
}
