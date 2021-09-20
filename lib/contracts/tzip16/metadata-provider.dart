import 'dart:convert';
import 'package:tezster_dart/contracts/contract.dart';
import 'package:tezster_dart/contracts/tzip16/errors.dart';
import 'package:tezster_dart/contracts/tzip16/handlers/ipfs-handler.dart';
import 'package:tezster_dart/contracts/utils/utils.dart';

final RegExp PROTOCOL_REGEX =
    RegExp(r'(?:sha256\:\/\/0x(.*)\/)?(https?|ipfs|tezos-storage)\:(.*)/');

class MetadataProvider {
  Map handlers;
  MetadataProvider(this.handlers);

  provideMetadata(uri, Contract contract) async {
    var uriInfo = this.extractProtocolInfo(uri);
    if (uriInfo == null || uriInfo['location'] == null) {
      throw new InvalidUri(uri);
    }

    var handler = handlers[uriInfo['protocol']];
    if (handler == null) {
      throw new ProtocolNotSupported(uriInfo['protocol']);
    }

    var metadata = await IpfsHttpHandler.getMetaData(
        contract.rpcServer, uriInfo['protocol'], uriInfo['location']);
    var sha256Hash = calculateSHA256Hash(metadata);
    var metadataJSON;
    try {
      metadataJSON = jsonDecode(metadata);
    } catch (ex) {
      print("metaData found:$ex");
      throw new InvalidMetadata(metadata);
    }

    return {
      'uri': uri,
      'metadata': metadataJSON,
      'integrityCheckResult': uriInfo['sha256hash'] == null
          ? uriInfo['sha256hash'] == sha256Hash
          : null,
      'sha256Hash': uriInfo['sha256hash'] == null ? sha256Hash : null
    };
  }

  extractProtocolInfo(String _uri) {
    final regExp =
        RegExp(r'(?:sha256\:\/\/0x(.*)\/)?(https?|ipfs|tezos-storage)\:(.*)');
    final match = regExp.firstMatch(_uri)!;

    final group1 = match.group(1);
    final group2 = match.group(2);
    final group3 = match.group(3);
    return {
      'sha256hash': group1, //extractor[1],
      'protocol': group2, //extractor[2],
      'location': group3 //extractor[3]
    };
  }
}
