import 'dart:convert';
import 'dart:typed_data';
import 'package:blake2b/blake2b_hash.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:bs58check/bs58check.dart';
import 'package:tezster_dart/michelson_encoder/helpers/constants.dart';

String calculateSHA256Hash(String preimage) {
  return hex.encode(sha256.convert(utf8.encode(preimage)).bytes);
}

bytes2Char(val) {
  return utf8.decode(hex2buf(val));
}

encodeExpr(value) {
  var x = hex2buf(value);
  var blakeHash = Blake2bHash.hash(x, 0, x.length);
  return b58cencode(blakeHash, prefix['EXPR']);
}

Uint8List hex2buf(String hex) {
  final regExp = RegExp(r'..');
  final matches = regExp.allMatches(hex);
  List<int> list =
      matches.map((match) => int.tryParse(match.group(0), radix: 16)).toList();
  return Uint8List.fromList(list);
}

dynamic b58cencode(dynamic value, Uint8List prefix) {
  prefix ??= Uint8List(0);
  var payloadAr = value.runtimeType == String
      ? Uint8List.fromList(hex.decode(value))
      : value;

  var n = Uint8List(prefix.length + payloadAr.length);
  n.setAll(0, prefix);
  n.setAll(prefix.length, payloadAr);
  return encode(n);
}
