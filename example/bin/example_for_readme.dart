import 'dart:io';

import 'package:fast_gbk/fast_gbk.dart';

void main() async {
  var gbkWebUrl = "http://www.newsmth.net/nForum/#!mainpage";
  var httpClient = HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(gbkWebUrl));
  HttpClientResponse response = await request.close();
  var responseBody = await response.transform(gbk.decoder).join();
  print(responseBody);
  httpClient.close();
}