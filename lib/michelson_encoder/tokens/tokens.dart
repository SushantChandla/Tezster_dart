import 'package:tezster_dart/michelson_encoder/tokens/bigmap.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bls12_381_fr.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bls12_381_g1.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bls12_381_g2.dart';
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
import 'package:tezster_dart/michelson_encoder/tokens/unit.dart';

List<Type> tokens = [
  PairToken,
  OrToken,
  OptionToken,
  BigMapToken,
  AddressToken,
  KeyHashToken,
  NatToken,
  UnitToken,
  ContractToken,
  LambdaToken,
  ListToken,
  TimestampToken,
  MapToken,
  StringToken,
  BytesToken,
  SetToken,
  Bls12381frToken,
  Bls12381g1Token,
  Bls12381g2Token,
  IntToken,
  BoolToken,
  MutezToken,
];
