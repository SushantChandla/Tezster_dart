import 'dart:convert';
import 'package:tezster_dart/contracts/contract.dart';
import 'package:tezster_dart/contracts/tzip16/errors.dart';
import 'package:tezster_dart/contracts/tzip16/metadata-interface.dart';
import 'package:tezster_dart/contracts/utils/utils.dart';

abstract class MetadataEnvelope {
  String uri;
  bool integrityCheckResult;
  String sha256hash;
  MetadataInterface metadata;
}

const String PROTOCOL_REGEX =
    r'/(?:sha256\:\/\/0x(.*)\/)?(https?|ipfs|tezos-storage)\:(.*)/';

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

    var metadata = await handler.getMetadata(
        contract.rpcServer, uriInfo, uriInfo['location']);
    var sha256Hash = calculateSHA256Hash(metadata);
    var metadataJSON;
    try {
      metadataJSON = jsonDecode(metadata);
    } catch (ex) {
      throw new InvalidMetadata(metadata);
    }

    return {
      'uri': uri,
      'metadata': metadataJSON,
      'integrityCheckResult':
          uriInfo.sha256hash ? uriInfo.sha256hash == sha256Hash : null,
      'sha256Hash': uriInfo.sha256hash ? sha256Hash : null
    };
  }

  extractProtocolInfo(_uri) {
    var extractor = RegExp(PROTOCOL_REGEX)
        .allMatches(_uri)
        .map((e) => e.toString())
        .toList();
    if (extractor == null) return;
    return {
      'sha256hash': extractor[1],
      'protocol': extractor[2],
      'location': extractor[3]
    };
  }
}
