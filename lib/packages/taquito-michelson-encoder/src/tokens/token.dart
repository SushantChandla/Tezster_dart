import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class TokenFactory extends Token {
  TokenFactory(MichelsonV1Expression val, int idx, TokenFactory fac)
      : super(val, idx, fac);
}

class Token {
  Token(MichelsonV1Expression val, int idx, TokenFactory fac);
}

abstract class ComparableToken extends Token{
  ComparableToken(MichelsonV1Expression val, int idx, TokenFactory fac)
      : super(val, idx, fac);
}