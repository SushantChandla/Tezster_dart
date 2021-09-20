import 'dart:typed_data';
import 'package:bs58check/bs58check.dart';
import 'package:convert/convert.dart';
import 'package:tezster_dart/michelson_encoder/helpers/constants.dart';

dynamic encodePubKey(String value) {
  if (value.substring(0, 2) == '00') {
    Map<String, Uint8List?> pref = {
      '0000': prefix['TZ1'],
      '0001': prefix['TZ2'],
      '0002': prefix['TZ3'],
    };

    return b58cencode(value.substring(4), pref[value.substring(0, 4)]);
  }

  return b58cencode(value.substring(2, 42), prefix['KT']);
}

dynamic b58cencode(dynamic value, Uint8List? prefix) {
  prefix ??= Uint8List(0);
  var payloadAr = value.runtimeType == String
      ? Uint8List.fromList(hex.decode(value))
      : value;

  var n = Uint8List(prefix.length + payloadAr.length as int);
  n.setAll(0, prefix);
  n.setAll(prefix.length, payloadAr);

  return encode(n);
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

b58decode(payload) {
  var buf = base58.decode(payload);
  const prefixMap = {
    'tz1': '0000',
    'tz2': '0001',
    'tz3': '0002',
  };

  var pref =
      prefixMap[Uint8List.fromList(buf.sublist(0, 3).toList()).toString()];
  if (pref != null) {
    // tz addresses
    var hex = buf2hex(buf.sublist(0, 3).toList());
    return pref + hex;
  } else {
    // other (kt addresses)
    return '01' + buf2hex(buf.sublist(3, 42).toList()) + '00';
  }
}

buf2hex(List<int> buffer) {
  var byteArray = new Uint8List.fromList(buffer);
  var hexParts = [];
  byteArray.forEach((int byte) {
    var hex = byte.toRadixString(16);
    var paddedHex = '00$hex'.substring(hex.length - 2, hex.length);
    hexParts.add(paddedHex);
  });
  return hexParts.join('');
}
