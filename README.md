A GBK codec library for Dart developers.

GBK 编解码器，支持 File 和 HttpClient 的 Stream interface。用法和 utf8 codec完全一致。

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

- A simple usage example:

```dart
import 'package:fast_gbk/fast_gbk.dart';
void main() async {
  var encoded = gbk.encode("白日依山尽，黄河入海流");
  var decoded = gbk.decode([176, 215, 200, 213, 210, 192, 201, 189, 190, 161, 163,
                            172, 187, 198, 186, 211, 200, 235, 186, 163, 193, 247]);
}
```

- Example: read a GBK file.

```dart
import 'dart:convert';
import 'dart:io';
import 'package:fast_gbk/fast_gbk.dart';
void main() {
  File gbkFile = File("gbkFile.txt");
  var stream = gbkFile.openRead();
  stream.transform(gbk.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    stdout.writeln(line);
  });
}

```

- Example: write a GBK file.
```dart
import 'dart:io';
import 'package:fast_gbk/fast_gbk.dart';
void main() async {
  File output = File("gbk.txt");
  var stream = output.openWrite(encoding: gbk);
  stream.write("123");
  stream.writeln("456");
  stream.writeCharCode(0x41);
  await stream.close();
}
```

- Example: decode HttpClient response
```dart
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
```
## Features and bugs

Please feel free to post issue or PR to this github link.
