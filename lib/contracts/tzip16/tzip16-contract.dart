import 'package:tezster_dart/contracts/big_map.dart';
import 'package:tezster_dart/contracts/contract.dart';
import 'package:tezster_dart/contracts/tzip16/errors.dart';
import 'package:tezster_dart/contracts/tzip16/handlers/https-handler.dart';
import 'package:tezster_dart/contracts/tzip16/handlers/ipfs-handler.dart';
import 'package:tezster_dart/contracts/tzip16/handlers/tesoz-storage-handler.dart';
import 'package:tezster_dart/contracts/tzip16/metadata-provider.dart';
import 'package:tezster_dart/contracts/tzip16/viewKind/viewFactory.dart';
import 'package:tezster_dart/contracts/utils/utils.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

var _metadataBigMapType = {
  'prim': 'big_map',
  'annots': ['%metadata'],
  'args': [
    {'prim': 'string'},
    {'prim': 'bytes'}
  ]
};
var _defaultHandler = {
  'http': HttpHandler(),
  'https': HttpHandler(),
  'tezos-storage': TezosStorageHandler(),
  'ipfs': IpfsHttpHandler(),
};

class Tzip16Contract extends Contract {
  MetadataProvider metadataProvider;
  Map? _metadataEnvelope;
  ViewFactory _viewFactory = new ViewFactory();
  dynamic _metadataViewsObject = {};
  Tzip16Contract(
      {required String rpcServer,
      required String address,
      MetadataProvider? metadataProviderInterface})
      : metadataProvider =
            metadataProviderInterface ?? MetadataProvider(_defaultHandler),
        super(address: address, rpcServer: rpcServer);

  BigMapAbstraction _findMetadataBigMap() {
    var metadataBigMapId = contractSchema!.findFirstInTopLevelPair(
        contractStorage, _metadataBigMapType);

    if (metadataBigMapId == null) {
      throw new BigMapMetadataNotFound();
    }

    return BigMapAbstraction(
        BigInt.tryParse(metadataBigMapId['int']), Schema(typeOfValueToFind));
  }

  getMetadata() async {
    await verifySchemaAndStorage();
    if (this.metadataProvider == null) {
      throw new UnconfiguredMetadataProviderError();
    }
    if (this._metadataEnvelope == null) {
      var uri = await this._getUriOrFail();
      this._metadataEnvelope =
          await this.metadataProvider.provideMetadata(bytes2Char(uri), this);
    }
    return this._metadataEnvelope;
  }

  metadataViews() async {
    if (this._metadataViewsObject.keys.length == 0) {
      await _initializeMetadataViewsList();
    }
    return this._metadataViewsObject;
  }

  _initializeMetadataViewsList() async {
    Map t = await this.getMetadata();
    var metadata = t['metadata'];
    var metadataViews = {};
    if (metadata['views'] != null) {
      metadata['views'].forEach(
          (view) => this._createViewImplementations(view, metadataViews));
    }
    this._metadataViewsObject = metadataViews;
  }

  _generateIndexedViewName(viewName, Map metadataViews) {
    var i = 1;
    if (metadataViews.containsKey(viewName)) {
      while (metadataViews.containsKey('$viewName$i')) {
        i++;
      }
      viewName = '$viewName$i';
    }
    return viewName;
  }

  dynamic _createViewImplementations(view, metadataViews) {
    for (var viewImplementation in view?.implementations ?? []) {
      if (view.name) {
        var viewName = this._generateIndexedViewName(view.name, metadataViews);
        var metadataView =
            this._viewFactory.getView(viewName, viewImplementation);
        if (metadataView) {
          metadataViews[viewName] = metadataView;
        } else {
          print(
              'Skipped generating ${viewName} because the view has an unsupported type: ${this._viewFactory.getImplementationType(viewImplementation)}');
        }
      }
    }
  }

  _getUriOrFail() async {
    BigMapAbstraction metadataBigMap = _findMetadataBigMap();
    var uri = await metadataBigMap.get(rpcServer, '');
    if (uri == null) {
      throw new UriNotFound();
    }
    return uri;
  }
}
