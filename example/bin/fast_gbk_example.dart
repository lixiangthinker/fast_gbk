import 'dart:io';
import 'dart:convert';

import 'package:fast_gbk/fast_gbk.dart';

main() async {
  //httpSample();
  commonSample();
}

commonSample() {
  List<int> encode = gbk.encode("¤§¨°±");
  String decode = gbk.decode([0xA1,0xE8,0xA1,0xEC,
    0xA1,0xA7,0xA1,0xE3,0xA1,0xC0]);
}

httpSample() async {
  var gbkWebUrl = "http://www.newsmth.net/nForum/#!mainpage";
  var httpClient = HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(gbkWebUrl));
  HttpClientResponse response = await request.close();

  //Unhandled exception:
  //Unsupported operation: This converter does not support chunked conversions: Instance of 'GbkDecoder'
  //#0      Converter.startChunkedConversion (dart:convert/gbk.dart:40:5)
  //#1      new _ConverterStreamEventSink (dart:convert/chunked_conversion.dart:69:34)
  //#2      Converter.bind.<anonymous closure> (dart:convert/gbk.dart:46:37)
  //#3      new _SinkTransformerStreamSubscription (dart:async/stream_transformers.dart:47:30)
  //#4      _BoundSinkStream.listen (dart:async/stream_transformers.dart:185:13)
  //#5      Stream.join (dart:async/stream.dart:826:25)
  //var responseBody = await response.transform(fastgbk.GbkDecoder()).join();
  var responseBody = await response.transform(Utf8Decoder()).join();

  print(responseBody);
  httpClient.close();
}