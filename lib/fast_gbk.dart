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

library fast_gbk;

export 'src/gbk.dart' show gbk, GbkEncoder, GbkDecoder;
