import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class PairToken extends ComparableToken {
  static String prim = 'pair';

  PairToken(MichelsonV1Expression val, int idx, TokenFactory fac)
      : super(
            val.runtimeType == List
                ? {'prim': PairToken.prim, 'args': val}
                : val,
            idx,
            fac);
}
