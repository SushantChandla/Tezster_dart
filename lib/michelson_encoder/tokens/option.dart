import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class OptionToken extends ComparableToken {
  static String prim = 'option';

  String get getPrim {
    return prim;
  }

  MichelsonV1Expression val;
  int idx;
  var fac;
  OptionToken(MichelsonV1Expression val, int idx, var fac)
      : super(val, idx, fac) {
    this.val = val;
    this.idx = idx;
    this.fac = fac;
  }

  Token subToken() {
    // MichelsonV1Expression data = MichelsonV1Expression();
    // data.prim = this.val.args[0]['prim'];
    // data.args = this.val.args[0]['args'];
    // data.annots = this.val.args[0]['annots'];
    var t = MichelsonV1Expression.j(val.args[0]);
    return this.createToken(t, this.idx);
  }

  @override
  extractSchema() {
    MichelsonV1Expression data = MichelsonV1Expression.j(val.args[0]);
    var schema = this.createToken(data, 0);
    return schema.extractSchema();
  }

  @override
  extractSignature() {
    MichelsonV1Expression data = MichelsonV1Expression.j(val.args[0]);
    var schema = this.createToken(val.args[0], 0);
    return [...schema.extractSignature(), []];
  }

  @override
  execute(dynamic val, {var semantics}) {
    if (val is Map) {
      if (val['prim'] == 'None') {
        return null;
      }
      MichelsonV1Expression data = MichelsonV1Expression.j(this.val.args[0]);
      var schema = this.createToken(data, 0);
      return schema.execute(val['args'][0], semantics: semantics);
    } else {
      if (val.prim == 'None') {
        return null;
      }
      MichelsonV1Expression data = MichelsonV1Expression.j(this.val.args[0]);
      var schema = this.createToken(data, 0);
      return schema.execute(data, semantics: semantics);
    }
  }

  @override
  encodeObject(args) {
    var schema = this.createToken(this.val.args[0], 0);
    var value = args;

    if (value == null || value == null) {
      return {'prim': 'None'};
    }

    return {
      'prim': 'Some',
      'args': [schema.encodeObject(value)]
    };
  }

  @override
  toKey(dynamic val) {
    this.execute(val);
  }

  @override
  encode(args) {
    var value = args;
    if (value == null) {
      return {prim: 'None'};
    } else if (value is List && (value[value.length - 1] == null)) {
      value.removeLast();
      return {prim: 'None'};
    }

    var schema = this.createToken(this.val.args[0], 0);
    return {
      prim: 'Some',
      args: [schema.Encode(args)]
    };
  }




  @override
  Map toBigMapKey(val) {
    return {
      'key': encodeObject(val),
      'type': typeWithoutAnnotations(val),
    };
  }

}