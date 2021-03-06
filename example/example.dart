import 'package:fast_gbk/fast_gbk.dart';
void main() async {
  // normal usage
  var encoded = gbk.encode("白日依山尽，黄河入海流");
  print(encoded);
  var decoded = gbk.decode([176, 215, 200, 213, 210, 192, 201, 189, 190, 161, 163,
                            172, 187, 198, 186, 211, 200, 235, 186, 163, 193, 247]);
  print(decoded);
  //output a �, instead of throw a exception.
  var codec = GbkCodec(allowMalformed: true);
  var decodedMalform = codec.decode([20001]);
  print(decodedMalform);
}