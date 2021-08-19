import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bigmap.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bls12_381_fr.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/address.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/bool.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/bytes.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/int.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/key_hash.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/mutez.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/nat.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/string.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/timestamp.dart';
import 'package:tezster_dart/michelson_encoder/tokens/contract.dart';
import 'package:tezster_dart/michelson_encoder/tokens/lambda.dart';
import 'package:tezster_dart/michelson_encoder/tokens/list.dart';
import 'package:tezster_dart/michelson_encoder/tokens/map.dart';
import 'package:tezster_dart/michelson_encoder/tokens/option.dart';
import 'package:tezster_dart/michelson_encoder/tokens/or.dart';
import 'package:tezster_dart/michelson_encoder/tokens/pair.dart';
import 'package:tezster_dart/michelson_encoder/tokens/set.dart';
import 'package:tezster_dart/michelson_encoder/tokens/tokens.dart';
import 'package:tezster_dart/michelson_encoder/tokens/unit.dart';

createToken(MichelsonV1Expression val, int idx) {
  String objectType;
  if (val is List) {
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
        return UnitToken.prim == val.prim.toLowerCase();
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
      } else if (element == SetToken) {
        objectType = "SetToken";
        return SetToken.prim == val.prim;
      } else if (element == Bls12381frToken) {
        objectType = "Bls12381frToken";
        return Bls12381frToken.prim == val.prim;
      } else if (element == IntToken) {
        objectType = "IntToken";
        return IntToken.prim == val.prim;
      } else if (element == BoolToken) {
        objectType = "BoolToken";
        return BoolToken.prim == val.prim;
      } else if (element == MutezToken) {
        objectType = "MutezToken";
        return MutezToken.prim == val.prim;
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
  } else if (objectType == "StringToken") {
    return StringToken(val, idx, createToken);
  } else if (objectType == "BytesToken") {
    return BytesToken(val, idx, createToken);
  } else if (objectType == "SetToken") {
    return SetToken(val, idx, createToken);
  } else if (objectType == "Bls12381frToken") {
    return Bls12381frToken(val, idx, createToken);
  } else if (objectType == "IntToken") {
    return IntToken(val, idx, createToken);
  } else if (objectType == "BoolToken") {
    return BoolToken(val, idx, createToken);
  } else if (objectType == "MutezToken") {
    return MutezToken(val, idx, createToken);
  }
}
