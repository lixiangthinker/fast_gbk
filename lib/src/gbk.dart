import 'dart:convert';
import 'dart:typed_data';
import 'gbk_encoder_map.dart';
import 'gbk_decoder_map.dart';

/// The GBK Replacement character `U+E7B3` (). GBK 0xA7F6
const int replacementCharacterUnicode = 0xE7B3;
const int replacementCharacterGBK = 0xA7F6;

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

    var encoder = _GbkStreamEncoder.withBufferSize(stringLength * 2);
    int ending = encoder.encode(string, start, end);
    return encoder._buffer.sublist(0, ending);
  }

  /// Starts a chunked conversion.
  ///
  /// The converter works more efficiently if the given [sink] is a
  /// [ByteConversionSink].
  StringConversionSink startChunkedConversion(Sink<List<int>> sink) {
    return _GbkEncoderSink(
        (sink is ByteConversionSink) ? sink : ByteConversionSink.from(sink),
      _GbkStreamEncoder()
    );
  }

  // Override the base-classes bind, to provide a better type.
  Stream<List<int>> bind(Stream<String> stream) => super.bind(stream);
}

/// This class encodes Strings to UTF-8 code units (unsigned 8 bit integers).
class _GbkStreamEncoder {
  final Uint8List _buffer;

  static const _DEFAULT_BYTE_BUFFER_SIZE = 1024;

  _GbkStreamEncoder() : this.withBufferSize(_DEFAULT_BYTE_BUFFER_SIZE);

  _GbkStreamEncoder.withBufferSize(int bufferSize)
      : _buffer = _createBuffer(bufferSize);

  /// Allow an implementation to pick the most efficient way of storing bytes.
  static Uint8List _createBuffer(int size) => Uint8List(size);

  int encode(String input, int start, int end) {
    List<int> source = input.codeUnits;
    int srcIndex = 0;
    int targetIndex = 0;

    while (srcIndex < source.length) {
      var codeUnit = source[srcIndex];
      // ignore non-BMP String character
      if (_isLeadSurrogate(codeUnit) || _isTailSurrogate(codeUnit)) {
        _buffer[targetIndex++] = replacementCharacterGBK;
        srcIndex++;
        srcIndex++;
        continue;
      }

      if (_isAscii(codeUnit)) {
        _buffer[targetIndex++] = codeUnit;
        srcIndex++;
        continue;
      }

      int gbkCode = utf16ToGBKMap[codeUnit];
      if (gbkCode != null ) {
        _buffer[targetIndex++] = (gbkCode >> 8) & 0xff;
        _buffer[targetIndex++] = gbkCode & 0xff;
      } else {
        // unknown GBK code;
        _buffer[targetIndex++] = replacementCharacterGBK;
      }
      srcIndex++;
    }
    return targetIndex;
  }
}

/// This class encodes chunked strings to GBK code units (unsigned 8-bit
/// integers).
/// stateless, String input, 2Bytes GBK output.
class _GbkEncoderSink with StringConversionSinkMixin {
  final ByteConversionSink _sink;
  final _GbkStreamEncoder _encoder;

  _GbkEncoderSink(this._sink, this._encoder);

  @override
  void close() {
    _sink.close();
  }

  @override
  void addSlice(String input, int start, int end, bool isLast) {
    int index = _encoder.encode(input, start, end);
    _sink.addSlice(_encoder._buffer, 0, index, isLast);

    if (isLast) close();
  }
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

  /// Converts the GBK [codeUnits] (a list of unsigned 8-bit integers) to the
  /// corresponding string.
  ///
  /// Uses the code units from [start] to, but no including, [end].
  /// If [end] is omitted, it defaults to `codeUnits.length`.
  ///
  /// If the [codeUnits] start with the encoding of a
  /// [unicodeBomCharacterRune], that character is discarded.
  @override
  String convert(List<int> codeUnits, [int start = 0, int end]) {
    var length = codeUnits.length;
    end = RangeError.checkValidRange(start, end, length);

    // Fast case for ASCII strings avoids StringBuffer / decodeMap.
    int oneBytes = _scanOneByteCharacters(codeUnits, start, end);
    StringBuffer buffer;
    if (oneBytes > 0) {
      var firstPart = String.fromCharCodes(codeUnits, start, start + oneBytes);
      start += oneBytes;
      if (start == end) {
        return firstPart;
      }
      buffer = StringBuffer(firstPart);
    }

    buffer ??= StringBuffer();
    var decoder = _GbkStreamDecoder(buffer, _allowMalformed);
    decoder.convert(codeUnits, start, end);
    decoder.flush(codeUnits, end);
    return buffer.toString();
  }

  /// Starts a chunked conversion.
  ///
  /// The converter works more efficiently if the given [sink] is a
  /// [StringConversionSink].
  ByteConversionSink startChunkedConversion(Sink<String> sink) {
    StringConversionSink stringSink;
    if (sink is StringConversionSink) {
      stringSink = sink;
    } else {
      stringSink = StringConversionSink.from(sink);
    }

    return _GbkConversionSink(stringSink, _allowMalformed);
  }

  // Override the base-classes bind, to provide a better type.
  Stream<String> bind(Stream<List<int>> stream) {
    return super.bind(stream);
  }
}

/// Decodes GBK code units.
///
/// Forwards the decoded strings to the given [StringConversionSink].
class _GbkConversionSink extends ByteConversionSink {
  final _GbkStreamDecoder _decoder;
  final StringConversionSink _chunkedSink;
  final StringBuffer _buffer;
  _GbkConversionSink(StringConversionSink sink, bool allowMalformed)
      : this._(sink, StringBuffer(), allowMalformed);

  _GbkConversionSink._(
      this._chunkedSink, StringBuffer stringBuffer, bool allowMalformed)
      : _decoder = _GbkStreamDecoder(stringBuffer, allowMalformed),
        _buffer = stringBuffer;

  void close() {
    _decoder.close();
    if (_buffer.isNotEmpty) {
      var accumulated = _buffer.toString();
      _buffer.clear();
      _chunkedSink.addSlice(accumulated, 0, accumulated.length, true);
    } else {
      _chunkedSink.close();
    }
  }

  void add(List<int> chunk) {
    addSlice(chunk, 0, chunk.length, false);
  }

  void addSlice(List<int> chunk, int startIndex, int endIndex, bool isLast) {
    _decoder.convert(chunk, startIndex, endIndex);
    if (_buffer.isNotEmpty) {
      var accumulated = _buffer.toString();
      _chunkedSink.addSlice(accumulated, 0, accumulated.length, isLast);
      _buffer.clear();
      return;
    }
    if (isLast) close();
  }
}

/// Decodes GBK.
///
/// The decoder handles chunked input.
///
/// init() -> convert -> convert -> ... -> close() -> flush()
///
class _GbkStreamDecoder {
  // throw exception or not
  final bool _allowMalformed;
  // output of the Decoder
  final StringSink _stringSink;

  // GBK need 2 bytes, if only 1 byte received, store here.
  int _firstByte = -1;

  bool get hasPartialInput => _firstByte > -1;

  _GbkStreamDecoder(this._stringSink, this._allowMalformed);

  void close() {
    flush();
  }

  /// Flushes this decoder as if closed.
  ///
  /// This method throws if the input was partial and the decoder was
  /// constructed with `allowMalformed` set to `false`.
  ///
  /// The [source] and [offset] of the current position may be provided,
  /// and are included in the exception if one is thrown.
  void flush([List<int> source, int offset]) {
    if (hasPartialInput) {
      if (!_allowMalformed) {
        throw FormatException(
            "Unfinished GBK octet sequence", source, offset);
      }
      _stringSink.writeCharCode(unicodeReplacementCharacterRune);
      _firstByte = -1;
    }
  }

  void convert(List<int> codeUnits, int startIndex, int endIndex) {
    int begin = startIndex;
    // if _firstByte > 0, we need to finish last time's job first.
    if (hasPartialInput) {
      int code = ((_firstByte)<< 8) + (codeUnits[0] & 0xff);
      int char = gbkToUtf16Map[code];
      if (char == null && !_allowMalformed) {
        throw FormatException(
            "Bad GBK encoding 0x${code.toRadixString(16)}",
            code);
      }
      if (char != null) {
        _stringSink.write(String.fromCharCode(char));
      } else {
        _stringSink.write(String.fromCharCode(unicodeReplacementCharacterRune));
      }
      _firstByte = -1;
      begin += 1;
    }

    // handle new incoming data.
    for (int index = begin; index < endIndex; index++) {
      int code = codeUnits[index];
      if (_isAscii(codeUnits[index])) {
        _stringSink.writeCharCode(code);
      } else {
        index++;
        //GBK need 2 bytes. wait for more to come.
        if (index == endIndex) {
          _firstByte = code;
          return;
        }
        code = ((code)<< 8) + (codeUnits[index] & 0xff);
        int char = gbkToUtf16Map[code];
        if (char == null && !_allowMalformed) {
          throw FormatException(
              "Bad GBK encoding 0x${code.toRadixString(16)}",
              code);
        }

        if (char != null) {
          _stringSink.write(String.fromCharCode(char));
        } else {
          _stringSink.write(String.fromCharCode(unicodeReplacementCharacterRune));
        }
      }
    }
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

int _scanOneByteCharacters(List<int> units, int from, int endIndex) {
  final to = endIndex;
  for (var i = from; i < to; i++) {
    final unit = units[i];
    if ((unit & _ONE_BYTE_LIMIT) != unit) return i - from;
  }
  return to - from;
}

///
///  For a character outside the Basic Multilingual Plane (plane 0) that is
///  composed of a surrogate pair, [runes] combines the pair and returns a
///  single integer.  For example, the Unicode character for a
///  musical G-clef ('𝄞') with rune value 0x1D11E consists of a UTF-16 surrogate
///  pair: `0xD834` and `0xDD1E`. Using [codeUnits] returns the surrogate pair,
///  and using `runes` returns their combined value:
///
///      var clef = '\u{1D11E}';
///      clef.codeUnits;         // [0xD834, 0xDD1E]
///      clef.runes.toList();    // [0x1D11E]
///
/// UTF-16 constants.
/// https://zh.wikipedia.org/wiki/UTF-16
const int _SURROGATE_TAG_MASK = 0xFC00;
const int _SURROGATE_VALUE_MASK = 0x3FF;
const int _LEAD_SURROGATE_MIN = 0xD800;
const int _TAIL_SURROGATE_MIN = 0xDC00;

bool _isLeadSurrogate(int codeUnit) =>
    (codeUnit & _SURROGATE_TAG_MASK) == _LEAD_SURROGATE_MIN;
bool _isTailSurrogate(int codeUnit) =>
    (codeUnit & _SURROGATE_TAG_MASK) == _TAIL_SURROGATE_MIN;

const int _ONE_BYTE_LIMIT = 0x7f; // 7 bits
bool _isAscii(int codeUnit) =>
    (codeUnit <= _ONE_BYTE_LIMIT);
