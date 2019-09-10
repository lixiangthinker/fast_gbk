import 'dart:convert';
import 'dart:typed_data';
import 'gbk_encoder_map.dart';
import 'gbk_decoder_map.dart';

/// The Unicode Replacement character `U+FFFD` (�).
const int unicodeReplacementCharacterRune = 0xFFFD;

/// The Unicode Byte Order Marker (BOM) character `U+FEFF`.
const int unicodeBomCharacterRune = 0xFEFF;

/// An instance of the default implementation of the [GbkCodec].
///
/// This instance provides a convenient access to the most common GBK
/// use cases.
///
/// Examples:
///
///     List<int> encoded = gbk.encode("¤§¨°±");
///     String decoded = gbk.decode([0xA1,0xE8,0xA1,0xEC,
///                                   0xA1,0xA7,0xA1,0xE3,0xA1,0xC0]);
GbkCodec gbk = GbkCodec();

/// A [GbkCodec] encodes strings to GBK code units (bytes) and decodes
/// GBK code units to strings.
class GbkCodec extends Encoding {
  final bool _allowMalformed;

  /// Instantiates a new [GbkCodec].
  ///
  /// The optional [allowMalformed] argument defines how [decoder] (and [decode])
  /// deal with invalid or unterminated character sequences.
  ///
  /// If it is `true` (and not overridden at the method invocation) [decode] and
  /// the [decoder] replace invalid (or unterminated) octet
  /// sequences with the Unicode Replacement character `U+FFFD` (�). Otherwise
  /// they throw a [FormatException].
  const GbkCodec({bool allowMalformed = false})
      : _allowMalformed = allowMalformed;

  /// The name of this codec, "gbk".
  @override
  String get name => "gbk";

  /// Decodes the UTF-8 [codeUnits] (a list of unsigned 8-bit integers) to the
  /// corresponding string.
  ///
  /// If the [codeUnits] start with the encoding of a
  /// [unicodeBomCharacterRune], that character is discarded.
  ///
  /// If [allowMalformed] is `true` the decoder replaces invalid (or
  /// unterminated) character sequences with the Unicode Replacement character
  /// `U+FFFD` (�). Otherwise it throws a [FormatException].
  ///
  /// If [allowMalformed] is not given, it defaults to the `allowMalformed` that
  /// was used to instantiate `this`.
  @override
  String decode(List<int> codeUnits, {bool allowMalformed}) {
    allowMalformed ??= _allowMalformed;
    return GbkDecoder(allowMalformed: allowMalformed).convert(codeUnits);
  }

  @override
  GbkDecoder get decoder {
    return GbkDecoder(allowMalformed: _allowMalformed);
  }

  @override
  GbkEncoder get encoder => const GbkEncoder();
}

/// This class converts strings to their GBK code units (a list of
/// unsigned 8-bit integers).
class GbkEncoder extends Converter<String, List<int>> {
  const GbkEncoder();

  /// Converts [string] to its GBK code units (a list of
  /// unsigned 8-bit integers).
  ///
  /// If [start] and [end] are provided, only the substring
  /// `string.substring(start, end)` is converted.
  @override
  Uint8List convert(String string, [int start = 0, int end]) {
    var stringLength = string.length;
    end = RangeError.checkValidRange(start, end, stringLength);
    var length = end - start;
    if (length == 0) return Uint8List(0);

    return _gbkEncode(string.substring(start, end));
  }
}

List<int> _gbkEncode(String input) {
  List<int> ret = List<int>();
  input.codeUnits.forEach( (charCode) {
    String char = String.fromCharCode(charCode);
    int gbkCode = utf16ToGBKMap[char];
    if (gbkCode != null ) {
      //split to two bytes
      int a =(gbkCode >> 8) & 0xff;
      int b = gbkCode & 0xff;
      ret.add(a);
      ret.add(b);
    } else {
      // charCode == ASCII
      ret.add(charCode);
    }
  });
  return ret;
}

/// This class converts GBK code units (lists of unsigned 8-bit integers)
/// to a string.
class GbkDecoder extends Converter<List<int>, String> {
  final bool _allowMalformed;

  /// Instantiates a new [GbkDecoder].
  ///
  /// The optional [allowMalformed] argument defines how [convert] deals
  /// with invalid or unterminated character sequences.
  ///
  /// If it is `true` [convert] replaces invalid (or unterminated) character
  /// sequences with the Unicode Replacement character `U+FFFD` (�). Otherwise
  /// it throws a [FormatException].
  const GbkDecoder({bool allowMalformed = false})
   : _allowMalformed = allowMalformed;

  @override
  String convert(List<int> input) {
    return _gbkDecode(input);
  }
}

///
/// GBK的编码范围
/// 范围	      第1字节	第2字节	      编码数	 字数
/// 水准GBK/1	A1–A9	  A1–FE	        846	   717
/// 水准GBK/2	B0–F7  	A1–FE	        6,768	 6,763
/// 水准GBK/3	81–A0	  40–FE (7F除外)	6,080	 6,080
/// 水准GBK/4	AA–FE	  40–A0 (7F除外)	8,160	 8,160
/// 水准GBK/5	A8–A9	  40–A0 (7F除外)	192	   166
/// 用户定义	  AA–AF	  A1–FE	        564
/// 用户定义	  F8–FE	  A1–FE	        658
/// 用户定义	  A1–A7  	40–A0 (7F除外)	672
/// 合计：			                      23,940 21,886
///
String _gbkDecode(List<int> input) {
  StringBuffer stringBuffer = StringBuffer();

  for (int index = 0; index < input.length; index++) {
    int codeUnits = input[index];
    if (input[index] < 0x80) {
      // ASCII,
      stringBuffer.writeCharCode(codeUnits);
    } else {
      index++;
      //GBK need 2 bytes.
      assert(index < input.length, "error index ${input[index - 1]}");
      codeUnits = ((codeUnits)<< 8) + (input[index] & 0xff);
      String char = gbkToUtf16Map[codeUnits];
      if (char == null) {
        throw FormatException(
            "Bad GBK encoding 0x${codeUnits.toRadixString(16)}",
            codeUnits);
      }
      stringBuffer.write(char);
    }
  }
  return stringBuffer.toString();
}