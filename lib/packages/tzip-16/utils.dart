import 'dart:convert';
import 'package:crypto/crypto.dart';

String calculateSHA256Hash(String preimage) {
  return sha256.convert(utf8.encode(preimage)).toString();
}
