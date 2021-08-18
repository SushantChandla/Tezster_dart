import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class BytesToken extends ComparableToken {
  static String prim = "bytes";
  BytesToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  _isValid(val) {
    RegExp regExp = RegExp("^[0-9a-fA-F]*\$");
    if (val.runtimeType == String &&
        regExp.hasMatch(val) &&
        val.length % 2 == 0) {
      return null;
    } else {
      return new Exception("Invalid bytes: $val");
    }
  }

  _convertUint8ArrayToHexString(val) {
    return val.constructor == Uint8List ? hex.encode(val) : val;
  }

  @override
  encodeObject(val) {
    val = this._convertUint8ArrayToHexString(val);
    var err = this._isValid(val);

    if (err != null) {
      throw err;
    }

    return {'bytes': val.toString()};
  }

  @override
  execute(val, {semantics}) {
    return val['bytes'];
  }

  @override
  extractSchema() {
    return BytesToken.prim;
  }

  @override
  toKey(String val) {
    if (val != null) {
      return val;
    }

    return val;
  }
}
