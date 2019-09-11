import 'dart:io';
import 'dart:convert';

import 'package:fast_gbk/fast_gbk.dart';

main() async {
  //httpSample();
  //utf8FileExample();
  gbkFileExample();
  //utf8StreamWriteFileExample();
  //gbkStreamWriteFileExample();
}

void httpSample() async {
  var gbkWebUrl = "http://www.newsmth.net/nForum/#!mainpage";
  var httpClient = HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(gbkWebUrl));
  HttpClientResponse response = await request.close();
  var responseBody = await response.transform(gbk.decoder).join();

  print(responseBody);
  httpClient.close();
}

void utf8FileExample() async {
  File testFile1 = File("./test/Utf8File/utf8_test_file_1.txt");
  var lineNumber = 1;
  var stream = testFile1.openRead();
  stream.transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    stdout.write('${lineNumber++} ');
    stdout.writeln(line);
  });
}

void gbkFileExample() async {
  File testFile1 = File("../test/GbkFile/gbk_test_file_1.txt");
  var lineNumber = 1;
  var stream = testFile1.openRead();
  stream.transform(gbk.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    stdout.write('${lineNumber++} ');
    stdout.writeln(line);
  });
}

void utf8StreamWriteFileExample() async {
  File testFile1 = File("./test/Utf8File/utf8_wirte_file_1.txt");

  var stream = testFile1.openWrite(encoding: utf8);
  stream.write("123");
  stream.write("456");
  stream.write("789");
  await stream.close();
}

void gbkStreamWriteFileExample() async {
  File testFile1 = File("./test/temp/gbk_wirte_file_1.txt");

  var stream = testFile1.openWrite(encoding: gbk);
  stream.write("123");
  stream.writeln();
  stream.write("456");
  stream.writeln();
  stream.write("789");
  stream.writeln();
  stream.writeCharCode(0x41);
  await stream.close();
}

void gbkStreamReadAndWriteExample() async {

}