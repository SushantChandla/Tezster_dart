import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

collapse(var val, {String prim = 'pair'}) {
  if (val.runtimeType == List) {
    return collapse({
      'prim': prim,
      'args': val,
    }, prim: prim);
  }
  if (val is Map) {
    if (val['args'] == null) {
      throw Exception('Token has no arguments');
    }
    if (val['args'].length > 2) {
      return [
        val['args'][0],
        {
          'prim': prim,
          'args': val['args'].sublist(1),
        }
      ];
    }
    return [val['args'][0], val['args'][1]];
  } else {
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

  List _args() {
    return collapse(this.val);
  }

  _traversal(getLeftValue(Token token), getRightValue(Token token)) {
    var args = _args();
    MichelsonV1Expression data = MichelsonV1Expression();
    data.prim = args[0]['prim'];
    data.args = args[0]['args'];
    data.annots = args[0]['annots'];
    Token leftToken = this.createToken(data, this.idx);
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
    data = MichelsonV1Expression();
    data.prim = args[1]['prim'];
    data.args = args[1]['args'];
    data.annots = args[1]['annots'];
    var rightToken = this.createToken(data, this.idx + keyCount);
    var rightValue;
    if (rightToken.runtimeType == PairToken && !rightToken.hasAnnotations()) {
      rightValue = getRightValue(rightToken);
    } else {
      rightValue = {
        [rightToken.annot()]: getRightValue(rightToken)
      };
    }

    var res = {};
    if (leftValue != null) res.addAll(leftValue);
    if (rightValue != null) res.addAll(rightValue);
    return res;
  }

  @override
  execute(dynamic val, {semantics}) {
    var args = collapse(val, prim: 'Pair');
    var data = _traversal(
        (leftToken) => leftToken.execute(args[0], semantics: semantics),
        (rightToken) => rightToken.execute(args[1], semantics: semantics));
    return data;
  }

  @override
  extractSchema() {
    return _traversal(
      (leftToken) => leftToken.extractSchema(),
      (rightToken) => rightToken.extractSchema(),
    );
  }

  List<Token> _tokens() {
    var cnt = 0;
    List data = [];
    this._args().forEach((a) {
      Token tok = this.createToken(a, this.idx + cnt);
      if (tok.runtimeType == PairToken) {
        cnt += tok.extractSchema().keys.length;
      } else {
        cnt++;
      }
      data.add(tok);
    });
    return data;
  }

  @override
  encodeObject(args) {
    var leftToken = this._tokens()[0];
    var rightToken = this._tokens()[0];

    var leftValue;
    if (leftToken.runtimeType == PairToken && !leftToken.hasAnnotations()) {
      leftValue = args;
    } else {
      leftValue = args[leftToken.annot()];
    }

    var rightValue;
    if (rightToken.runtimeType == PairToken && !rightToken.hasAnnotations()) {
      rightValue = args;
    } else {
      rightValue = args[rightToken.annot()];
    }

    return {
      prim: 'Pair',
      args: [
        leftToken.encodeObject(leftValue),
        rightToken.encodeObject(rightValue)
      ],
    };
  }

  @override
  toKey(String val) {
    return this.execute(val);
  }
}
