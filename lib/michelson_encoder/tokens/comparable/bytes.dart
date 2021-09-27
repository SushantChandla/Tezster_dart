import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class BytesToken extends ComparableToken {
  static String prim = "bytes";
  BytesToken(MichelsonV1Expression? val, int idx, fac) : super(val, idx, fac);

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
    return val is Uint8List ? hex.encode(val) : val;
  }

  @override
  encodeObject(val) {
    if (val is Map) val = val['bytes'];
    val = this._convertUint8ArrayToHexString(val);
    var err = this._isValid(val);

    if (err != null) {
      throw err;
    }

    return {'bytes': val.toString()};
  }

  @override
  execute(val, {semantics}) {
    if (val is MichelsonV1Expression) val = val.jsonCopy;
    return val['bytes'];
  }

  @override
  extractSchema() {
    return BytesToken.prim;
  }

  @override
  toKey(dynamic val) {
    if (val != null) {
      return val;
    }

    return val;
  }

  @override
  encode(List args) {
    var val = args.removeLast();

    var t = _convertUint8ArrayToHexString(val);
    var err = _isValid(t);
    if (err != null) {
      throw err;
    }

    return {'bytes': t.toString()};
  }

  @override
  Map toBigMapKey(val) {
    return {
      'key': {'bytes': val},
      'type': {'prim': BytesToken.prim},
    };
  }
}
