import 'dart:io';

import 'package:fast_gbk/fast_gbk.dart' as fastgbk;
import 'package:dio/dio.dart';
import 'package:gbk_codec/gbk_codec.dart';


final String baseUrl = "http://www.newsmth.net";
final String defaultAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) "
    "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.101 Safari/537.36";
const int secondsUnit = 1000;
final int connectTimeOut = 10 * secondsUnit;
final int receiveTimeOut = 15 * secondsUnit;
const String defaultCookieDays = "2";

main() async {
  String result = await getHttp(
      "http://www.newsmth.net/nForum/#!article/OurEstate/2611032",
      fastGbkDecoder
  );

  String result2 = await getHttp(
      "http://www.newsmth.net/nForum/#!article/OurEstate/2611032",
      gbkDecoder
  );
}

Future<String> getHttp(String url, ResponseDecoder decoder) async {
  try {
    BaseOptions options = BaseOptions();
    options.connectTimeout = connectTimeOut;
    options.receiveTimeout = receiveTimeOut;
    options.baseUrl = baseUrl;
    options.headers.addAll({
      HttpHeaders.userAgentHeader: defaultAgent,
    });
    options.responseDecoder = decoder;

    Dio _client = Dio(options);
    Response response = await _client.get(url);
    return response.toString();
  } catch (e) {
    print(e);
    return "";
  }
}

String fastGbkDecoder (List<int> responseBytes, RequestOptions options,
    ResponseBody responseBody) {
  var begin = DateTime.now().millisecondsSinceEpoch;
  String result = fastgbk.gbk.decode(responseBytes);
  var end = DateTime.now().millisecondsSinceEpoch;
  print("fastgbk.gbk.decode cost ${end - begin}ms");
  return result;
}

String gbkDecoder (List<int> responseBytes, RequestOptions options,
    ResponseBody responseBody) {
  var begin = DateTime.now().millisecondsSinceEpoch;
  String result =  gbk_bytes.decode(responseBytes);
  var end = DateTime.now().millisecondsSinceEpoch;
  print("gbk.decode cost ${end - begin}ms");
  return result;
}
