import 'package:tezster_dart/packages/tzip-16/handlers/https-handler.dart';
import 'package:tezster_dart/packages/tzip-16/handlers/ipfs-handler.dart';
import 'package:tezster_dart/packages/tzip-16/handlers/tesoz-storage-handler.dart';

var DEFAULT_HANDLERS = {
  'http':HttpHandler(),
  'https':HttpHandler(),
  'tezos-storage':TezosStorageHandler(),
  'ipfs':IpfsHttpHandler(),
};
// class Tzip16Module implements Extension {
//     private _metadataProvider: MetadataProviderInterface;

//     constructor(metadataProvider?: MetadataProviderInterface) {
//         this._metadataProvider = metadataProvider ? metadataProvider : new MetadataProvider(DEFAULT_HANDLERS);
//     }

//     configureContext(context: Context) {
//         Object.assign(context, { metadataProvider: this._metadataProvider });
//     }
// }