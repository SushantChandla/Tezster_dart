import 'package:flutter/cupertino.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

collapse(var val, {String prim = 'pair'}) {
  // COULD NOT CONVERT THE FOLLOWING TO DART
  // if (Array.isArray(val)) {
  //   return collapse({
  //     prim: prim,
  //     args: val,
  //   }, prim);
  // }
  if (val.args == null) {
    throw Exception('Token has no arguments');
  }
  if (val.args.length > 2) {
    return [
      val.args[0],
      {
        'prim': prim,
        'args': val.args.sublist(1),
      }
    ];
  }
  return [val.args[0], val.args[1]];
}

class PairToken extends ComparableToken {
  static String prim = 'pair';

  PairToken(MichelsonV1Expression val, int idx, var fac)
      : super(
            val.runtimeType == List
                ? {'prim': PairToken.prim, 'args': val}
                : val,
            idx,
            fac);

  _args() {
    return collapse(this.val);
  }

  _traversal(
      dynamic getLeftValue(Token token), dynamic getRightValue(Token token)) {
    var args = _args();
    Token leftToken = this.createToken(args[0], this.idx);
    var keyCount = 1;
    var leftValue;
    if (leftToken.runtimeType == PairToken && !leftToken.hasAnnotations()) {
      leftValue = getLeftValue(leftToken);
      keyCount = leftToken.extractSchema().length;
    } else {
      leftValue = {
        [leftToken.annot()]: getLeftValue(leftToken)
      };
    }

    var rightToken = this.createToken(args[1], this.idx + keyCount);
    var rightValue;
    if (rightToken.runtimeType == PairToken && !rightToken.hasAnnotations()) {
      rightValue = getRightValue(rightToken);
    } else {
      rightValue = {
        [rightToken.annot()]: getRightValue(rightToken)
      };
    }

    var res = {};
    res.addAll(leftValue);
    res.addAll(rightValue);
    return res;
  }

  @override
  Map<String, dynamic> execute(dynamic val, var semantic) {
    var args = collapse(val, prim: 'Pair');
    return _traversal((token) => null, (token) => null);
  }

  @override
  extractSchema() {
    return _traversal(
      (leftToken) => leftToken.extractSchema(),
      (rightToken) => rightToken.extractSchema(),
    );
  }
}
