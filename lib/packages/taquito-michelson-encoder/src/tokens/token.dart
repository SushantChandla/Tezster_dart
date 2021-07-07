import 'package:flutter/cupertino.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
abstract class Token {
  MichelsonV1Expression val;
  int idx;
  var fac;
  var createToken;
  Token(MichelsonV1Expression val, int idx, var fac) {
    this.val = val;
    this.idx = idx;
    this.fac = fac;
    this.createToken = this.fac;
  }

  dynamic extractSchema();

  extractSignature() {
    return [
      [this.extractSchema()]
    ];
  }

  annot() {
    return this.val.annots.length > 0 ? this.val.annots[0] : this.idx as String;
  }

  hasAnnotations() {
    //wrong convertion. Need to fix this
    return this.val.annots.length > 0 ? true : false;
  }

  dynamic execute(dynamic val, Semantics semantics);
}

abstract class ComparableToken extends Token {
  ComparableToken(MichelsonV1Expression val, int idx, var fac)
      : super(val, idx, fac);
}
