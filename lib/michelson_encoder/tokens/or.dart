import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class OrToken extends ComparableToken {
  static String prim = 'or';

  String get getPrim {
    return prim;
  }

  OrToken(MichelsonV1Expression? val, int idx, var fac) : super(val, idx, fac);

  _traversal(
      Function? getLeftValue(Token token), Function? getRightValue(Token token)) {
    MichelsonV1Expression data = MichelsonV1Expression.j(val!.args![0]);
    var leftToken = this.createToken(data, this.idx);
    int? keyCount = 1;
    var leftValue;
    if (leftToken.runtimeType == OrToken && !leftToken.hasAnnotations()) {
      leftValue = leftToken.extractSchema();
      keyCount = leftToken.extractSchema().keys.length;
    } else {
      leftValue = {leftToken.annot(): leftToken.extractSchema()};
    }
    data = MichelsonV1Expression.j(val!.args![1]);
    var rightToken = this.createToken(data, this.idx! + keyCount!);
    var rightValue;
    if (rightValue.runtimeType == OrToken && !rightToken.hasAnnotations()) {
      rightValue = rightToken.extractSchema();
    } else {
      rightValue = {rightToken.annot(): rightToken.extractSchema()};
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
    MichelsonV1Expression data = MichelsonV1Expression.j(this.val!.args![0]);
    var leftToken = this.createToken(data, this.idx);
    int? keyCount = 1;
    if (leftToken.runtimeType == OrToken) {
      keyCount = leftToken.extractSchema().keys.length;
    }
    data = MichelsonV1Expression.j(this.val!.args![1]);
    var rightToken = this.createToken(data, this.idx! + keyCount!);
    MichelsonV1Expression? x;
    if (val is Map) {
      x = MichelsonV1Expression.j(val);
    } else {
      x = val;
    }

    MichelsonV1Expression t = MichelsonV1Expression.j(x!.args![0]);
    if (x.prim == 'Right') {
      if (rightToken.runtimeType == OrToken) {
        return rightToken.execute(t, semantics: semantics);
      } else {
        return {
          [rightToken.annot()]: rightToken.execute(t, semantics: semantics),
        };
      }
    } else if (x.prim == 'Left') {
      if (leftToken.runtimeType == OrToken) {
        return leftToken.execute(t, semantics: semantics);
      }
      return {
        [leftToken.annot()]: leftToken.execute(t, semantics: semantics),
      };
    } else {
      throw Exception('Was expecting Left or Right prim but got : ${val.prim}');
    }
  }

  @override
  encodeObject(args) {
    var lable = args.keys.toList()[0];

    Token leftToken = this.createToken(this.val!.args![0], this.idx);
    int? keyCount = 1;
    if (leftToken.runtimeType == OrToken) {
      keyCount = leftToken.extractSchema().keys.length;
    }

    Token? rightToken = this.createToken(this.val!.args![1], this.idx! + keyCount!);

    if (leftToken.annot().toString() == lable.toString() &&
        leftToken.runtimeType != OrToken) {
      return {
        'prim': 'Left',
        'args': [leftToken.encodeObject(args[lable])]
      };
    } else if (rightToken!.annot().toString() == lable.toString() &&
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
  toKey(dynamic val) {
    return this.execute(val);
  }

  encode(args) {
    var label = args[args.length - 1];

    var leftToken = createToken(this.val!.args![0], this.idx);
    int? keyCount = 1;
    if (leftToken is OrToken) {
      keyCount = leftToken.extractSchema().length;
    }

    var rightToken = this.createToken(this.val!.args![1], this.idx! + keyCount!);

    if (leftToken.annot().toString() == label.toString() &&
        !(leftToken is OrToken)) {
      args.removeLast();
      return {
        prim: 'Left',
        args: [leftToken.Encode(args)]
      };
    } else if (rightToken.annot().toString() == label.toString() &&
        !(rightToken is OrToken)) {
      args.removeLast();
      return {
        prim: 'Right',
        args: [rightToken.Encode(args)]
      };
    } else {
      if (leftToken is OrToken) {
        var val = leftToken.encode(args);
        if (val) {
          return {
            prim: 'Left',
            args: [val]
          };
        }
      }

      if (rightToken is OrToken) {
        var val = rightToken.encode(args);
        if (val) {
          return {
            prim: 'Right',
            args: [val]
          };
        }
      }
      return null;
    }
  }

  @override
  Map toBigMapKey(val) {
    return {
      'key': this.encodeObject(val),
      'type': typeWithoutAnnotations(val),
    };
  }
}
