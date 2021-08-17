import 'dart:convert';

import 'package:tezster_dart/packages/tzip-16/errors.dart';
import 'package:tezster_dart/packages/tzip-16/metadata-interface.dart';
import 'package:tezster_dart/packages/tzip-16/utils.dart';

abstract class MetadataProviderInterface {
  provideMetadata(contractAbstraction, uri, context);
}

abstract class MetadataEnvelope {
  // uri: string;
  String uri;
  // integrityCheckResult?: boolean;
  bool integrityCheckResult;
  // sha256Hash?: string;
  String sha256hash;
  // metadata: MetadataInterface;
  MetadataInterface metadata;
}

const String PROTOCOL_REGEX =
    r'/(?:sha256\:\/\/0x(.*)\/)?(https?|ipfs|tezos-storage)\:(.*)/';

class MetadataProvider implements MetadataProviderInterface {
  Map handlers;
  MetadataProvider(this.handlers);
  @override
  provideMetadata(contractAbstraction, uri, context) async {
    var uriInfo = this.extractProtocolInfo(uri);
    if (!uriInfo || !uriInfo.location) {
      throw new InvalidUri(uri);
    }

    var handler = handlers[uriInfo.protocol];
    if (handler==null) {
      throw new ProtocolNotSupported(uriInfo.protocol);
    }

    var metadata =
        await handler.getMetadata(contractAbstraction, uriInfo, context);
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
    // constructor(private handlers: Map<string, Handler>) {}

    /**
     * @description Fetch the metadata by using the appropriate handler based on the protcol found in the URI
     * @returns an object which contains the uri, the metadata, an optional integrity check result and an optional SHA256 hash
     * @param _contractAbstraction the contract abstraction which contains the URI in its storage
     * @param _uri the decoded uri found in the storage
     * @param context the TezosToolkit Context
     */
    // async provideMetadata(contractAbstraction: ContractAbstraction<ContractProvider | Wallet>, uri: string, context: Context): Promise<MetadataEnvelope> {

    //     const uriInfo = this.extractProtocolInfo(uri);
    //     if (!uriInfo || !uriInfo.location) {
    //         throw new InvalidUri(uri);
    //     }

    //     const handler = this.handlers.get(uriInfo.protocol);
    //     if (!handler) {
    //         throw new ProtocolNotSupported(uriInfo.protocol);
    //     }

    //     const metadata = await handler.getMetadata(contractAbstraction, uriInfo, context);
    //     const sha256Hash = calculateSHA256Hash(metadata);
    //     let metadataJSON;
    //     try {
    //         metadataJSON = JSON.parse(metadata);
    //     } catch (ex) {
    //         throw new InvalidMetadata(metadata);
    //     }

    //     return {
    //         uri,
    //         metadata: metadataJSON,
    //         integrityCheckResult: uriInfo.sha256hash ? uriInfo.sha256hash === sha256Hash : undefined,
    //         sha256Hash: uriInfo.sha256hash ? sha256Hash : undefined
    //     }
    // }

    // private extractProtocolInfo(_uri: string) {
    //     const extractor = this.PROTOCOL_REGEX.exec(_uri);
    //     if (!extractor) return;
    //     return {
    //         sha256hash: extractor[1],
    //         protocol: extractor[2],
    //         location: extractor[3]
    //     }
    // }
// }
//