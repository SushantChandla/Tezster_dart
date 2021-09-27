import 'package:tezster_dart/michelson_encoder/helpers/constants.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class ListValidationError extends TokenValidationError {
  String name = "ListValidationError";

  ListValidationError(dynamic value, ListToken token, String message)
      : super(value, token, message);
}

class ListToken extends Token {
  static String prim = 'list';

  ListToken(MichelsonV1Expression? val, int idx, var fac)
      : super(val, idx, fac);

  _isValid(dynamic value) {
    if (value is List) {
      return;
    }
    throw ListValidationError(value, value, 'Value must be an array');
  }

  @override
  execute(val, {semantics}) {
    MichelsonV1Expression michelsonV1Expression =
        MichelsonV1Expression.j(this.val!.args![0]);
    var schema = this.createToken(michelsonV1Expression, 0);
    List dataList = (val is MichelsonV1Expression ? val.args : val) ?? [];
    this._isValid(dataList);
    List res = [];
    for (var i in dataList) {
      res.add(schema.execute(i, semantics: semantics));
    }
    return res;
  }

  @override
  extractSchema() {
    return ListToken.prim;
  }

  @override
  encodeObject(args) {
    Token? schema = this.createToken(this.val!.args![0], 0);

    this._isValid(args);
    List res = [];
    for (var i in args) {
      res.add(schema!.encodeObject(i));
    }
    return res;
  }

  @override
  encode(List args) {
    var val = args.removeLast();

    this._isValid(val);

    var schema = this.createToken(this.val!.args![0], 0);
    return val.reduce((prev, current) {
      return [...prev, schema.EncodeObject(current)];
    }, []);
  }
}
