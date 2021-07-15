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
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/unit.dart';

List<dynamic> tokens = [
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
];
