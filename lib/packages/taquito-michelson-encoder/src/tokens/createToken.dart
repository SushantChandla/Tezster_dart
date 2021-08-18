import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/comparable/bytes.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/comparable/string.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/contract.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/bigmap.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/comparable/address.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/comparable/key_hash.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/comparable/nat.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/comparable/timestamp.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/lambda.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/list.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/map.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/option.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/or.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/pair.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/tokens.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/unit.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

createToken(MichelsonV1Expression val, int idx) {
  String objectType;
  if (val.runtimeType == List) {
    return new PairToken(val, idx, createToken(val, idx));
  }

  var t = tokens.firstWhere(
    (element) {
      if (element == PairToken) {
        objectType = "PairToken";
        return PairToken.prim == val.prim;
      } else if (element == OrToken) {
        objectType = "OrToken";
        return OrToken.prim == val.prim;
      } else if (element == OptionToken) {
        objectType = "OptionToken";
        return OptionToken.prim == val.prim;
      } else if (element == BigMapToken) {
        objectType = "BigMapToken";
        return BigMapToken.prim == val.prim;
      } else if (element == AddressToken) {
        objectType = "AddressToken";
        return AddressToken.prim == val.prim;
      } else if (element == KeyHashToken) {
        objectType = "KeyHashToken";
        return KeyHashToken.prim == val.prim;
      } else if (element == NatToken) {
        objectType = "NatToken";
        return NatToken.prim == val.prim;
      } else if (element == UnitToken) {
        objectType = "UnitToken";
        return UnitToken.prim == val.prim;
      } else if (element == ContractToken) {
        objectType = "ContractToken";
        return ContractToken.prim == val.prim;
      } else if (element == LambdaToken) {
        objectType = "LambdaToken";
        return LambdaToken.prim == val.prim;
      } else if (element == ListToken) {
        objectType = "ListToken";
        return ListToken.prim == val.prim;
      } else if (element == TimestampToken) {
        objectType = "TimestampToken";
        return TimestampToken.prim == val.prim;
      } else if (element == MapToken) {
        objectType = "MapToken";
        return MapToken.prim == val.prim;
      } else if (element == StringToken) {
        objectType = "StringToken";
        return StringToken.prim == val.prim;
      } else if (element == BytesToken) {
        objectType = "BytesToken";
        return BytesToken.prim == val.prim;
      }

      return false;
    },
    orElse: () => null,
  );

  if (t == null) {
    throw new Exception(
        'Malformed data expected a value with a valid prim property');
  }

  if (objectType == "PairToken") {
    return PairToken(val, idx, createToken);
  } else if (objectType == "OrToken") {
    return OrToken(val, idx, createToken);
  } else if (objectType == "OptionToken") {
    return OptionToken(val, idx, createToken);
  } else if (objectType == "BigMapToken") {
    return BigMapToken(val, idx, createToken);
  } else if (objectType == "AddressToken") {
    return AddressToken(val, idx, createToken);
  } else if (objectType == "KeyHashToken") {
    return KeyHashToken(val, idx, createToken);
  } else if (objectType == "NatToken") {
    return NatToken(val, idx, createToken);
  } else if (objectType == "UnitToken") {
    return UnitToken(val, idx, createToken);
  } else if (objectType == "ContractToken") {
    return ContractToken(val, idx, createToken);
  } else if (objectType == "LambdaToken") {
    return LambdaToken(val, idx, createToken);
  } else if (objectType == "ListToken") {
    return ListToken(val, idx, createToken);
  } else if (objectType == "TimestampToken") {
    return TimestampToken(val, idx, createToken);
  } else if (objectType == "MapToken") {
    return MapToken(val, idx, createToken);
  } else if (objectType == "BytesToken") {
    return BytesToken(val, idx, createToken);
  }
}
