import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class SetToken extends Token {
  static String prim = 'set';

  SetToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  ComparableToken get keySchema {
    return this.createToken(this.val.args[0], 0);
  }

  _isValid(value) {
    if (value is List) {
      return null;
    }

    return Exception("$value Value must be an array");
  }

  @override
  encodeObject(args) {
    var err = _isValid(args);
    if (err != null) {
      throw err;
    }
  }

  @override
  execute(val, {semantics}) {
    if (val.length < 1) {
      return val;
    }
    return val.reduce((prev, current) =>
        [...prev, keySchema.execute(current, semantics: semantics)]);
  }

  @override
  extractSchema() {
    return SetToken.prim;
  }

  @override
  encode(List args) {
    List val = args[args.length - 1];

    var err = _isValid(val);
    if (err != null) {
      throw err;
    }

    val.sort((a, b) => this.keySchema.compare(a, b));

    return val.reduce(
        (prev, current) => [...prev, this.keySchema.encodeObject(current)]);
  }
}
