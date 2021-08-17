import 'dart:ffi';

import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/tzip-16/handlers/https-handler.dart';
import 'package:tezster_dart/packages/tzip-16/handlers/ipfs-handler.dart';
import 'package:tezster_dart/packages/tzip-16/handlers/tesoz-storage-handler.dart';
import 'package:tezster_dart/packages/tzip-16/metadata-provider.dart';

var DEFAULT_HANDLERS = {
  'http': HttpHandler(),
  'https': HttpHandler(),
  'tezos-storage': TezosStorageHandler(),
  'ipfs': IpfsHttpHandler(),
};

class Tzip16Module {
  MetadataProviderInterface metadataProviderInterface;
  Tzip16Module({this.metadataProviderInterface}) {
    metadataProviderInterface =
        metadataProviderInterface ?? MetadataProvider(DEFAULT_HANDLERS);
  }

  configureContext(Context context) {
    context.metadataProvider = metadataProviderInterface;
  }
}
