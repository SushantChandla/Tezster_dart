import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class OrToken extends ComparableToken {
  static String prim = 'or';

  String get getPrim {
    return prim;
  }

  OrToken(MichelsonV1Expression val, int idx, var fac) : super(val, idx, fac);

  _traversal(
      Function getLeftValue(Token token), Function getRightValue(Token token)) {
    MichelsonV1Expression data = MichelsonV1Expression();
    data.prim = this.val.args[0]['prim'];
    data.args = this.val.args[0]['args'];
    data.annots = this.val.args[0]['annots'];
    var leftToken = this.createToken(data, this.idx);
    var keyCount = 1;
    var leftValue;
    if (leftToken.runtimeType == OrToken && !leftToken.hasAnnotations()) {
      leftValue = leftToken.extractSchema();
      keyCount = leftToken.extractSchema().keys.length;
    } else {
      leftValue = {
        [leftToken.annot()]: leftToken.extractSchema()
      };
    }
    data = MichelsonV1Expression();
    data.prim = this.val.args[1]['prim'];
    data.args = this.val.args[1]['args'];
    data.annots = this.val.args[1]['annots'];
    var rightToken = this.createToken(data, this.idx + keyCount);
    var rightValue;
    if (rightValue.runtimeType == OrToken && !rightToken.hasAnnotations()) {
      rightValue = rightToken.extractSchema();
    } else {
      rightValue = {
        [rightToken.annot()]: rightToken.extractSchema()
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
      (leftToken) => leftToken.extractSchema(),
      (rightToken) => rightToken.extractSchema(),
    );
  }

  @override
  execute(val, {semantics}) {
    var leftToken = this.createToken(this.val.args[0], this.idx);
    var keyCount = 1;
    if (leftToken.runtimeType == OrToken) {
      keyCount = leftToken.extractSchema().keys.length;
    }

    var rightToken = this.createToken(this.val.args[1], this.idx + keyCount);

    if (val.prim == 'Right') {
      if (rightToken.runtimeType == OrToken) {
        return rightToken.execute(val.args[0], semantics);
      } else {
        return {
          [rightToken.annot()]: rightToken.execute(val.args[0], semantics),
        };
      }
    } else if (val.prim == 'Left') {
      if (leftToken.runtimeType == OrToken) {
        return leftToken.execute(val.args[0], semantics);
      }
      return {
        [leftToken.annot()]: leftToken.execute(val.args[0].semantic),
      };
    } else {
      throw Exception('Was expecting Left or Right prim but got : ${val.prim}');
    }
  }

  @override
  encodeObject(args) {
    var lable = args.keys.toList()[0];

    Token leftToken = this.createToken(this.val.args[0], this.idx);
    var keyCount = 1;
    if (leftToken.runtimeType == OrToken) {
      keyCount = leftToken.extractSchema().keys.length;
    }

    Token rightToken = this.createToken(this.val.args[1], this.idx + keyCount);

    if (leftToken.annot().toString() == lable.toString() &&
        leftToken.runtimeType != OrToken) {
      return {
        'prim': 'Left',
        'args': [leftToken.encodeObject(args[lable])]
      };
    } else if (rightToken.annot().toString() == lable.toString() &&
        rightToken.runtimeType != OrToken) {
      return {
        'prim': 'Right',
        'args': [rightToken.encodeObject(args[lable])]
      };
    } else {
      if (leftToken.runtimeType == OrToken) {
        var val = leftToken.encodeObject(args);
        if (val != null) {
          return {
            'prim': 'Left',
            'args': [val]
          };
        }
      }

      if (rightToken.runtimeType == OrToken) {
        var val = rightToken.encodeObject(args);
        if (val) {
          return {
            'prim': 'Right',
            'args': [val]
          };
        }
      }
      return null;
    }
  }

  @override
  toKey(String val) {
    return this.execute(val);
  }
}
