import 'package:flutter/cupertino.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class OrToken extends ComparableToken {
  static String prim = 'or';

  OrToken(MichelsonV1Expression val, int idx, var fac) : super(val, idx, fac);

  _traversal(
      Function getLeftValue(Token token), Function getRightValue(Token token)) {
    var leftToken = this.createToken(this.val.args[0], this.idx);
    var keyCount = 1;
    var leftValue;
    if (leftToken.runtimeType == OrToken && !leftToken.hasAnnotations()) {
      leftValue = getLeftValue(leftToken);
      keyCount = leftToken.extractSchema().keys.length;
    } else {
      leftValue = {
        [leftToken.annot()]: getLeftValue(leftToken)
      };
    }

    var rightToken = this.createToken(this.val.args[0], this.idx + keyCount);
    var rightValue;
    if (rightValue.runtimeType == OrToken && !rightToken.hasAnnotations()) {
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
  extractSchema() {
    return _traversal(
      (leftToken) => leftToken.extractSchema,
      (rightToken) => rightToken.extractSchema,
    );
  }

  @override
  dynamic execute(dynamic val, var semantic) {
    var leftToken = this.createToken(this.val.args[0], this.idx);
    var keyCount = 1;
    if (leftToken.runtimeType == OrToken) {
      keyCount = leftToken.extractSchema().keys.length;
    }

    var rightToken = this.createToken(this.val.args[1], this.idx + keyCount);

    if (val.prim == 'Right') {
      if (rightToken.runtimeType == OrToken) {
        return rightToken.execute(val.args[0], semantic);
      } else {
        return {
          [rightToken.annot()]: rightToken.execute(val.args[0], semantic),
        };
      }
    } else if (val.prim == 'Left') {
      if (leftToken.runtimeType == OrToken) {
        return leftToken.execute(val.args[0], semantic);
      }
      return {
        [leftToken.annot()]: leftToken.execute(val.args[0].semantic),
      };
    } else {
      throw Exception('Was expecting Left or Right prim but got : ${val.prim}');
    }
  }
}
