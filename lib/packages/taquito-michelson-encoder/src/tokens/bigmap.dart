import 'dart:convert';

import 'package:tezster_dart/packages/taquito-michelson-encoder/src/michelson-map.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class BigMapToken extends Token {
  static String prim = 'big_map';

  String get getPrim {
    return prim;
  }

  BigMapToken(MichelsonV1Expression val, int idx, var fac)
      : super(val, idx, fac);

  get valueSchema {
    MichelsonV1Expression michelsonV1Expression = MichelsonV1Expression();
    michelsonV1Expression.prim = this.val.args[1]['prim'];
    michelsonV1Expression.args = this.val.args[1]['args'];
    michelsonV1Expression.annots = this.val.args[1]['annots'];
    return this.createToken(michelsonV1Expression, 0);
  }

  ComparableToken get keySchema {
    MichelsonV1Expression michelsonV1Expression = MichelsonV1Expression();
    michelsonV1Expression.prim = this.val.args[0]['prim'];
    michelsonV1Expression.args = this.val.args[0]['args'];
    michelsonV1Expression.annots = this.val.args[0]['annots'];
    return (this.createToken(michelsonV1Expression, 0)) as ComparableToken;
  }

  _isValid(value) {
    if (MichelsonMap.isMichelsonMap(value)) {
      return null;
    }
    return Exception("$value Value must be a MichelsonMap");
  }

  @override
  extractSchema() {
    return {
      [this.keySchema?.extractSchema()]: this.valueSchema.extractSchema(),
    };
  }

  @override
  execute(val, {semantics}) {
    if (semantics != null && semantics[BigMapToken.prim] != null) {
      return semantics[BigMapToken.prim](val, this.val);
    }

    if (val.runtimeType == List) {
      var map = MichelsonMap(this.val);
      val.forEach((current) => map.set(this.keySchema.toKey(current.args[0]),
          this.valueSchema.execute(current.args[1])));
      return map;
    } else if (val.containsKey('int')) {
      return val['int'];
    } else {
      throw Exception(
          "Big map is expecting either an array (Athens) or an object with an int property (Babylon). Got " +
              jsonDecode(val));
    }
  }

  @override
  encodeObject(args) {
    MichelsonMap<dynamic, dynamic> val = args;

    var err = this._isValid(val);
    if (err != null) {
      throw err;
    }

    List list = val.keys().toList();
    list.sort();

    return list.map((key) => {
          'prim': 'Elt',
          'args': [
            this.keySchema.encodeObject(key),
            this.valueSchema.encodeObject(val.get(key))
          ]
        });
  }
}
