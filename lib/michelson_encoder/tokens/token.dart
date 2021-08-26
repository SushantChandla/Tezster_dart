import 'package:flutter/material.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';

class TokenValidationError implements Exception {
  String name = "ValidationError";
  String message;

  TokenValidationError(dynamic value, Token token, String baseMessage) {
    var annot = token.annot();
    var annotText = annot != null ? annot : '';
    this.message = "$annotText $baseMessage";
  }
}

abstract class Token {
  MichelsonV1Expression val;
  int idx;
  var fac;
  var createToken;
  static String prim;
  Token(MichelsonV1Expression val, int idx, var fac) {
    this.val = val;
    this.idx = idx;
    this.fac = fac;
    this.createToken = this.fac;
  }
  typeWithoutAnnotations(val) {
    if (val.args != null) {
      return {
        'prim': val.prim,
        'args': val.args
            .map((x) => typeWithoutAnnotations(MichelsonV1Expression.j(x))),
      };
    } else {
      return {
        'prim': val.prim,
      };
    }
  }

  extractSignature() {
    return [
      [this.extractSchema()]
    ];
  }

  annot() {
    String data = this.val.annots != null && this.val.annots.length > 0
        ? this.val.annots[0]
        : "${this.idx}";
    RegExp reg = RegExp("(%|\\:)(_Liq_entry_)?");
    if (reg.hasMatch(data)) {
      return data.replaceFirst(
          RegExp("(%|\\:)(_Liq_entry_)?").stringMatch(data), '');
    } else {
      return data;
    }
  }

  hasAnnotations() {
    return this.val.annots != null &&
            this.val.annots.runtimeType == List &&
            this.val.annots.length > 0
        ? true
        : false;
  }

  dynamic extractSchema();
  dynamic execute(dynamic val, {var semantics});
  dynamic encode(List<dynamic> args);
  dynamic encodeObject(dynamic args);
}

abstract class ComparableToken extends Token {
  ComparableToken(MichelsonV1Expression val, int idx, var fac)
      : super(val, idx, fac);
  compare(o1, o2) {
    if (o1 == o2) {
      return 0;
    }
    return o1 < o2 ? -1 : 1;
  }

  Map toBigMapKey(dynamic val);
  dynamic toKey(dynamic val);
}
