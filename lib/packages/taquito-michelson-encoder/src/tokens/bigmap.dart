import 'package:flutter/cupertino.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class BigMapToken extends Token {
  static String prim = 'big_map';

  BigMapToken(MichelsonV1Expression val, int idx, var fac)
      : super(val, idx, fac);

  get valueSchema {
    return this.createToken(this.val.args[1], 0);
  }

  ComparableToken get keySchema {
    return (this.createToken(this.val.args[0], 0)) as ComparableToken;
  }

  @override
  extractSchema() {
    return {
      [this.keySchema.extractSchema()]: this.valueSchema.extractSchema(),
    };
  }

  @override
  execute(dynamic val, dynamic semantic) {
    if (semantic != null && semantic[BigMapToken.prim] != null) {
      return semantic[BigMapToken.prim](val, this.val);
    }
  }
}
