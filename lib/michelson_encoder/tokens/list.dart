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

  ListToken(MichelsonV1Expression? val, int idx, var fac) : super(val, idx, fac);

  List? _isValid(dynamic value) {
    if (value is List) {
      return value;
    }
    if (value is MichelsonV1Expression) return value.args;

    throw ListValidationError(value, this, 'Value must be an array');
  }

  @override
  execute(val, {semantics}) {
    MichelsonV1Expression michelsonV1Expression =
        MichelsonV1Expression.j(this.val!.args![0]);
    var schema = this.createToken(michelsonV1Expression, 0);

    List v = this._isValid(val)!;

    return v.reduce((prev, current) {
      var temlist;
      if (prev is Map) {
        temlist = prev.values;
      } else {
        temlist = prev;
      }
      return [...temlist, schema.execute(current, semantics: semantics)];
    });
  }

  @override
  extractSchema() {
    return ListToken.prim;
  }

  @override
  encodeObject(args) {
    Token? schema = this.createToken(this.val!.args![0], 0);

    var err = this._isValid(args);
    if (err != null) {
      throw err;
    }

    return args['reduce'](
        (prev, current) => [...prev, schema!.encodeObject(current)], []);
  }

  @override
  encode(List args) {
    var val = args.removeLast();

    var err = _isValid(val);
    if (err != null) {
      throw err;
    }

    var schema = this.createToken(this.val!.args![0], 0);
    return val.reduce((prev, current) {
      return [...prev, schema.EncodeObject(current)];
    }, []);
  }
}
