import 'dart:io';
import 'dart:convert';

import 'package:fast_gbk/fast_gbk.dart';

main() async {
  readGbkFileAndWriteToGbkFile();
  readUtf8FileAndWriteToGbkFile();
}

void readGbkFileAndWriteToGbkFile() async {
  File gbkFile = File("../test/GbkFile/gbk_test_file_2.txt");
  File outputGbkFile = File("../test/temp/gbk_test_file_2.txt");
  print(outputGbkFile.absolute.path);
  if (await outputGbkFile.exists()) {
    await outputGbkFile.delete();
  }
  await outputGbkFile.create();
  var sink = outputGbkFile.openWrite(encoding: gbk);

  var lineNumber = 1;
  var stream = gbkFile.openRead();
  stream.transform(gbk.decoder).transform(const LineSplitter()).listen((line) {
    stdout.write('${lineNumber++} ');
    stdout.writeln(line);

    sink.writeln(line);
  }, onDone: () {
    print("finished.");
    sink.close();
  }, onError: (e, s) {
    print("get error.");
  });
}

void readUtf8FileAndWriteToGbkFile() async {
  File utf8File = File("../test/Utf8File/utf8_test_file_1.txt");
  File outputGbkFile = File("../test/temp/gbk_utf8_test_file_1.txt");
  print(outputGbkFile.absolute.path);
  if (await outputGbkFile.exists()) {
    await outputGbkFile.delete();
  }
  await outputGbkFile.create();
  var sink = outputGbkFile.openWrite(encoding: gbk);

  var lineNumber = 1;
  var stream = utf8File.openRead();
  stream.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
    stdout.write('${lineNumber++} ');
    stdout.writeln(line);

    sink.writeln(line);
  }, onDone: () {
    print("finished.");
    sink.close();
  }, onError: (e, s) {
    print("get error.");
  });
}

void readUtf8FileAndWriteToGbkFile2() async {
  File utf8File = File("../test/Utf8File/utf8_test_file_2.txt");
  File outputGbkFile = File("../test/temp/gbk_utf8_test_file_2.txt");
  print(outputGbkFile.absolute.path);
  if (await outputGbkFile.exists()) {
    await outputGbkFile.delete();
  }
  await outputGbkFile.create();
  var sink = outputGbkFile.openWrite(encoding: gbk);

  var lineNumber = 1;
  var stream = utf8File.openRead();
  stream.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
    stdout.write('${lineNumber++} ');
    stdout.writeln(line);

    sink.writeln(line);
  }, onDone: () {
    print("finished.");
    sink.close();
  }, onError: (e, s) {
    print("get error.");
  });
}
