import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class BigMapToken extends Token {
  static String prim = 'big_map';

  BigMapToken(MichelsonV1Expression val, int idx, TokenFactory fac)
      : super(val, idx, fac);
}
