import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/pair.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/tokens.dart';

Token createToken(dynamic val, int idx) {
  if (val.runtimeType == List) {
    return new PairToken(val, idx, createToken(val, idx));
  }

  var t = tokens.firstWhere((element) => element.prim == val.prim);

  if (t != null) {
    throw new Exception(
        'Malformed data expected a value with a valid prim property');
  }

  return t(val, idx, createToken(val, idx));
}
