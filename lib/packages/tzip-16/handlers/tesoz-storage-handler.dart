import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito-utils/src/taquito-utils.dart';
import 'package:tezster_dart/packages/tzip-16/errors.dart';

var typeOfValueToFind = MichelsonV1Expression()
  ..args = ['{ prim: "string" }', '{ prim: "bytes" }']
  ..annots = ['%metadata']
  ..prim = 'big_map';

class TezosStorageHandler {
  static final TEZOS_STORAGE_REGEX =
      RegExp(r'/^(?:\/\/(KT1\w{33})(?:\.(.+))?\/)?([\w|\%]+)$/');

  static getMetadata(contractAbstraction, location, context) async {
    var parsedTezosStorageUri = _parseTezosStorageUri(location);
    if (!parsedTezosStorageUri) {
      throw new InvalidUri(location.toString());
    }
    var storage = await context.rpc.getScript(
        parsedTezosStorageUri.contractAddress || contractAbstraction.address);
    var bigMapId = Schema.fromRPCResponse(storage)
        .FindFirstInTopLevelPair(storage.storage, typeOfValueToFind);

    if (bigMapId == null) {
      throw new BigMapMetadataNotFound();
    }

    var bytes = await context.contract.getBigMapKeyByID<String>(
        bigMapId['int'].toString(),
        parsedTezosStorageUri.path,
        new Schema(typeOfValueToFind));

    if (!bytes) {
      throw MetadataNotFound(
          "No '${parsedTezosStorageUri.path}' key found in the big map %metadata of the contract ${parsedTezosStorageUri.contractAddress || contractAbstraction.address}");
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

class BigMapId extends MichelsonV1Expression {}
