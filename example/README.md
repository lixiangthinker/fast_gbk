##example.dart

a simple String encode and decode use-case.

```dart
import 'package:fast_gbk/fast_gbk.dart';
void main() async {
  // normal usage
  var encoded = gbk.encode("白日依山尽，黄河入海流");
  var decoded = gbk.decode([176, 215, 200, 213, 210, 192, 201, 189, 190, 161, 163,
                            172, 187, 198, 186, 211, 200, 235, 186, 163, 193, 247]);

  //output a �, instead of throw a exception.
  var codec = GbkCodec(allowMalformed: true);
  var decodedMalform = codec.decode([20001]);
}
```

##example_stream_api.dart

a stream api encode and decode use-case,

- readGbkFileAndWriteToGbkFile();

Get a gbk input streams from a file, and then write to the file encoding with gbk codec.

- readUtf8FileAndWriteToGbkFile();

Get a utf8 input streams from a file, and then write to the file encoding with gbk codec.