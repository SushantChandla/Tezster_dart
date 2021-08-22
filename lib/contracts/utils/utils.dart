import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

String calculateSHA256Hash(String preimage) {
  return sha256.convert(utf8.encode(preimage)).toString();
}

bytes2Char(val) {
  return hex.encode(val);
}
