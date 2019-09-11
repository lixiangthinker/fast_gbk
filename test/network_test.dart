import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Dio testClient;

    setUp(() {
      String baseUrl = "http://www.newsmth.net";
      final String defaultAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) "
          "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.101 Safari/537.36";
      const int secondsUnit = 1000;
      final int connectTimeOut = 10 * secondsUnit;
      final int receiveTimeOut = 15 * secondsUnit;

      BaseOptions options = BaseOptions();
      options.connectTimeout = connectTimeOut;
      options.receiveTimeout = receiveTimeOut;
      options.baseUrl = baseUrl;
      options.headers.addAll({
        HttpHeaders.userAgentHeader: defaultAgent,
      });
      options.responseDecoder = gbkDecoder;
      Dio client = Dio(options);
      client.options.headers.addAll({
        "X-Requested-With": "XMLHttpRequest",
      });

      testClient = client;
    });

    test('Get GBK Html response by dio client', () async {
      //gbk.decode cost 86ms, responseLength = 41333
      String url = "/nForum/article/Tennis/1119045?ajax";
      //gbk.decode cost 88ms, responseLength = 46345
      //String url = "/nForum/article/Shopping/105645?ajax";
      var response = await testClient.get<String>(url);
      print(response.data);
    }, skip: false);
  });
}

String gbkDecoder (List<int> responseBytes, RequestOptions options,
    ResponseBody responseBody) {
  var begin = DateTime.now().millisecondsSinceEpoch;
  String result =  gbk.decode(responseBytes);
  var end = DateTime.now().millisecondsSinceEpoch;
  print("gbk.decode cost ${end - begin}ms, responseLength = ${responseBytes.length}");
  return result;
}
