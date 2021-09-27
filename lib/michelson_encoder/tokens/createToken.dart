import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bigmap.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bls12_381_fr.dart';
import 'package:tezster_dart/michelson_encoder/tokens/chain-id.dart';
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
import 'package:tezster_dart/michelson_encoder/tokens/key.dart';
import 'package:tezster_dart/michelson_encoder/tokens/lambda.dart';
import 'package:tezster_dart/michelson_encoder/tokens/list.dart';
import 'package:tezster_dart/michelson_encoder/tokens/map.dart';
import 'package:tezster_dart/michelson_encoder/tokens/option.dart';
import 'package:tezster_dart/michelson_encoder/tokens/or.dart';
import 'package:tezster_dart/michelson_encoder/tokens/pair.dart';
import 'package:tezster_dart/michelson_encoder/tokens/set.dart';
import 'package:tezster_dart/michelson_encoder/tokens/signature.dart';
import 'package:tezster_dart/michelson_encoder/tokens/ticket.dart';
import 'package:tezster_dart/michelson_encoder/tokens/unit.dart';

createToken(dynamic val, int idx) {
  if (!(val is MichelsonV1Expression)) {
    val = MichelsonV1Expression.j(val);
  }
  if (val.prim == PairToken.prim) {
    return PairToken(val, idx, createToken);
  } else if (OrToken.prim == val.prim) {
    return OrToken(val, idx, createToken);
  } else if (OptionToken.prim == val.prim) {
    return OptionToken(val, idx, createToken);
  } else if (BigMapToken.prim == val.prim) {
    return BigMapToken(val, idx, createToken);
  } else if (AddressToken.prim == val.prim) {
    return AddressToken(val, idx, createToken);
  } else if (KeyHashToken.prim == val.prim) {
    return KeyHashToken(val, idx, createToken);
  } else if (NatToken.prim == val.prim) {
    return NatToken(val, idx, createToken);
  } else if (UnitToken.prim == val.prim!.toLowerCase()) {
    return UnitToken(val, idx, createToken);
  } else if (ContractToken.prim == val.prim) {
    return ContractToken(val, idx, createToken);
  } else if (LambdaToken.prim == val.prim) {
    return LambdaToken(val, idx, createToken);
  } else if (ListToken.prim == val.prim) {
    return ListToken(val, idx, createToken);
  } else if (TimestampToken.prim == val.prim) {
    return TimestampToken(val, idx, createToken);
  } else if (MapToken.prim == val.prim) {
    return MapToken(val, idx, createToken);
  } else if (StringToken.prim == val.prim) {
    return StringToken(val, idx, createToken);
  } else if (BytesToken.prim == val.prim) {
    return BytesToken(val, idx, createToken);
  } else if (SetToken.prim == val.prim) {
    return SetToken(val, idx, createToken);
  } else if (Bls12381frToken.prim == val.prim) {
    return Bls12381frToken(val, idx, createToken);
  } else if (IntToken.prim == val.prim) {
    return IntToken(val, idx, createToken);
  } else if (BoolToken.prim == val.prim) {
    return BoolToken(val, idx, createToken);
  } else if (MutezToken.prim == val.prim) {
    return MutezToken(val, idx, createToken);
  } else if (KeyToken.prim == val.prim) {
    return KeyToken(val, idx, createToken);
  } else if (ChainIDToken.prim == val.prim) {
    return ChainIDToken(val, idx, createToken);
  } else if (SignatureToken.prim == val.prim) {
    return SignatureToken(val, idx, createToken);
  } else if (TicketToken.prim == val.prim) {
    return TicketToken(val, idx, createToken);
  }
  throw new Exception(
      'Malformed data expected a value with a valid prim property');
}
