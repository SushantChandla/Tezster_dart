import 'dart:typed_data';

import 'package:bs58check/bs58check.dart';
import 'package:convert/convert.dart';
import 'package:tezster_dart/packages/taquito-utils/src/constants.dart';

dynamic encodePubKey(String value) {
  if (value.substring(0, 2) == '00') {
    Map<String, Uint8List> pref = {
      '0000': prefix['tz1'],
      '0001': prefix['tz2'],
      '0002': prefix['tz3'],
    };

    return b58cencode(value.substring(4), pref[value.substring(0, 4)]);
  }

  return b58cencode(value.substring(2, 42), prefix['KT']);
}

dynamic b58cencode(dynamic value, Uint8List prefix) {
  var payloadAr = value.runtimeType == String
      ? Uint8List.fromList(hex.encode(value).codeUnits)
      : value;

  var n = Uint8List(prefix.length + payloadAr.length);
  n.setAll(0, prefix);
  n.setAll(prefix.length, payloadAr);

  return base58.encode(n);
}

dynamic encodeKeyHash(String value) {
  if (value[0] == '0') {
    Map<String, Uint8List> pref = {
      '00': Uint8List.fromList([6, 161, 159]),
      '01': Uint8List.fromList([6, 161, 161]),
      '02': Uint8List.fromList([6, 161, 164]),
    };

    return b58cencode(value.substring(2), pref[value.substring(0, 2)]);
  }
}
