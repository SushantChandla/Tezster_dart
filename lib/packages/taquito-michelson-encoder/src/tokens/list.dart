import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class ListValidationError extends TokenValidationError {
  String name = "ListValidationError";

  ListValidationError(dynamic value, ListToken token, String message)
      : super(value, token, message);
}

class ListToken extends Token {
  static String prim = 'list';

  ListToken(MichelsonV1Expression val, int idx, var fac) : super(val, idx, fac);

  ListValidationError _isValid(dynamic value) {
    if (value.runtimeType == List) {
      return null;
    }

    return new ListValidationError(value, this, 'Value must be an array');
  }

  @override
  execute(val, {semantics}) {
    MichelsonV1Expression michelsonV1Expression = MichelsonV1Expression();
    michelsonV1Expression.prim = this.val.args[0]['prim'];
    michelsonV1Expression.args = this.val.args[0]['args'];
    michelsonV1Expression.annots = this.val.args[0]['annots'];
    var schema = this.createToken(this.val.args[0], 0);

    var err = this._isValid(val);
    if (err != null) {
      throw err;
    }

    return val['reduce'](
        (prev, current) => [...prev, schema.Execute(current, semantics)], []);
  }

  @override
  extractSchema() {
    return ListToken.prim;
  }

  @override
  encodeObject(args) {
    Token schema = this.createToken(this.val.args[0], 0);

    var err = this._isValid(args);
    if (err != null) {
      throw err;
    }

    return args['reduce'](
        (prev, current) => [...prev, schema.encodeObject(current)], []);
  }
}
