// import 'package:tezster_dart/contracts/contract.dart';
// import 'package:tezster_dart/contracts/tzip16/errors.dart';
// import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

// const String PROTOCOL_REGEX =
//     r'/(?:sha256\:\/\/0x(.*)\/)?(https?|ipfs|tezos-storage)\:(.*)/';

// class Tzip16Contract extends Contract {
//   Tzip16Contract({String rpcServer, String address})
//       : super(rpcServer: rpcServer, address: address);

//   getTokenMetadata(contractAbstraction, location, context) async {
//     var parsedTezosStorageUri = _parseTezosStorageUri(location);
//     if (!parsedTezosStorageUri) {
//       throw InvalidUri(location.toString());
//     }
//     var storage = await context.rpc.getScript(
//         parsedTezosStorageUri.contractAddress || contractAbstraction.address);
//     var bigMapId = Schema.fromRPCResponse(storage)
//     .FindFirstInTopLevelPair(storage.storage, typeOfValueToFind);

//     if (bigMapId == null) {
//       throw new BigMapMetadataNotFound();
//     }

//     var bytes = await context.contract.getBigMapKeyByID<String>(
//     bigMapId['int'].toString(),
//     parsedTezosStorageUri.path,
//     new Schema(typeOfValueToFind));

//     if (!bytes) {
//       throw MetadataNotFound(
//           "No '${parsedTezosStorageUri.path}' key found in the big map %metadata of the contract ${parsedTezosStorageUri.contractAddress || contractAbstraction.address}");
//     }

//     if (!RegExp(r'/^[0-9a-fA-F]*$/').hasMatch(bytes)) {
//       throw new InvalidMetadataType();
//     }
//     return bytes2Char(bytes);
//   }

//   static _parseTezosStorageUri(String tezosStorageURI) {
//        var extractor = TEZOS_STORAGE_REGEX
//           .allMatches(tezosStorageURI)
//           .map((e) => e.toString())
//           .toList();
//       if (extractor == null) return;
//       return {
//         'contractAddress': extractor[1],
//         'network': extractor[2],
//         'path': Uri.decodeComponent(extractor[3])
//       };
//   }
// }
