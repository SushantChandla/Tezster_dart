import 'package:tezster_dart/contracts/big_map.dart';
import 'package:tezster_dart/contracts/contract.dart';
import 'package:tezster_dart/contracts/tzip16/errors.dart';
import 'package:tezster_dart/contracts/utils/utils.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

var typeOfValueToFind = MichelsonV1Expression()
  ..args = ['{ prim: "string" }', '{ prim: "bytes" }']
  ..annots = ['%metadata']
  ..prim = 'big_map';

class TezosStorageHandler {
  static final TEZOS_STORAGE_REGEX =
      RegExp(r'/^(?:\/\/(KT1\w{33})(?:\.(.+))?\/)?([\w|\%]+)$/');

  static getMetadata(location, Contract contract) async {
    var parsedTezosStorageUri = _parseTezosStorageUri(location);
    if (!parsedTezosStorageUri) {
      throw new InvalidUri(location.toString());
    }
    var bigMapId = contract.contractSchema
        .findFirstInTopLevelPair(contract.contractStorage, typeOfValueToFind);
    if (bigMapId == null) {
      throw new BigMapMetadataNotFound();
    }

    var bytes = await BigMapAbstraction.getBigMapKeyByID(
      bigMapId['int'].toString(),
      parsedTezosStorageUri.path,
      new Schema(typeOfValueToFind),
    );

    if (!bytes) {
      throw MetadataNotFound(
          "No '${parsedTezosStorageUri.path}' key found in the big map %metadata of the contract ${parsedTezosStorageUri.contractAddress}");
    }

    if (!RegExp(r'/^[0-9a-fA-F]*$/').hasMatch(bytes)) {
      throw new InvalidMetadataType();
    }
    return bytes2Char(bytes);
  }

  static _parseTezosStorageUri(String tezosStorageURI) {
    var extractor = TEZOS_STORAGE_REGEX
        .allMatches(tezosStorageURI)
        .map((e) => e.toString())
        .toList();
    if (extractor == null) return;
    return {
      'contractAddress': extractor[1],
      'network': extractor[2],
      'path': Uri.decodeComponent(extractor[3])
    };
  }
}
