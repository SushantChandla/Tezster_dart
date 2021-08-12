import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class Bls12381g1ValidationError extends TokenValidationError {
  String name = 'Bls12381g1ValidationError';
  Bls12381g1ValidationError(value, Token token, String baseMessage)
      : super(value, token, baseMessage);
}

class Bls12381g1Token extends Token {
  static String prim = 'bls12_381_g1';

  Bls12381g1Token(MichelsonV1Expression val, int idx, fac)
      : super(val, idx, fac);

  isValid(dynamic value) =>
      RegExp(r"^[0-9a-fA-F]*$").hasMatch(value) && value.length % 2 == 0
          ? null
          : new Bls12381g1ValidationError(val, this, 'Invalid bytes: $val');

  _convertUint8ArrayToHexString(dynamic val) =>
      val is List<int> || val is Uint8List ? hex.encode(val) : val;

  encode(List<dynamic> args) {
    var val = args.last;
    if (val is num)
      return {'int': val.toString()};
    else {
      val = _convertUint8ArrayToHexString(val);
      var err = isValid(val);
      if (err != null) throw err;
      return {'bytes': val};
    }
  }

  @override
  encodeObject(args) {
    var val = args.last;
    if (val is num)
      return {'int': val.toString()};
    else {
      val = _convertUint8ArrayToHexString(val);
      var err = isValid(val);
      if (err != null) throw err;
      return {'bytes': val};
    }
  }

  @override
  execute(val, {semantics}) => val['bytes'];

  @override
  extractSchema() => Bls12381g1Token.prim;
}
