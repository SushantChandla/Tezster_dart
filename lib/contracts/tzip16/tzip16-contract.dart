import 'package:tezster_dart/contracts/big_map.dart';
import 'package:tezster_dart/contracts/contract.dart';
import 'package:tezster_dart/contracts/tzip16/errors.dart';
import 'package:tezster_dart/contracts/tzip16/handlers/https-handler.dart';
import 'package:tezster_dart/contracts/tzip16/handlers/ipfs-handler.dart';
import 'package:tezster_dart/contracts/tzip16/handlers/tesoz-storage-handler.dart';
import 'package:tezster_dart/contracts/tzip16/metadata-provider.dart';
import 'package:tezster_dart/contracts/tzip16/viewKind/viewFactory.dart';
import 'package:tezster_dart/contracts/utils/utils.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';

var metadataBigMapType = MichelsonV1Expression()
  ..prim = 'big_map'
  ..annots = ['%metadata']
  ..args = [
    {'prim': 'string'},
    {'prim': 'bytes'}
  ];

var defaultHandler = {
  'http': HttpHandler(),
  'https': HttpHandler(),
  'tezos-storage': TezosStorageHandler(),
  'ipfs': IpfsHttpHandler(),
};

class Tzip16Contract extends Contract {
  MetadataProvider _metadataProvider;
  MetadataEnvelope _metadataEnvelope;
  ViewFactory _viewFactory = new ViewFactory();
  dynamic _metadataViewsObject = {};
  Tzip16Contract(
      {String rpc, String contract, MetadataProvider metadataProviderInterface})
      : _metadataProvider =
            metadataProviderInterface ?? MetadataProvider(defaultHandler),
        super(address: contract, rpcServer: rpc);

  BigMapAbstraction findMetadataBigMap() {
    var metadataBigMapId = contractSchema.findFirstInTopLevelPair(
        contractStorage, metadataBigMapType);

    if (!metadataBigMapId) {
      throw new BigMapMetadataNotFound();
    }

    return new BigMapAbstraction(
      BigInt.tryParse(metadataBigMapId['int']),
    );
  }

  getMetadata() async {
    if (this._metadataProvider == null) {
      throw new UnconfiguredMetadataProviderError();
    }
    if (this._metadataEnvelope == null) {
      var uri = await this.getUriOrFail();
      this._metadataEnvelope =
          await this._metadataProvider.provideMetadata(bytes2Char(uri), this);
    }
    return this._metadataEnvelope;
  }

  metadataViews() async {
    if (this._metadataViewsObject.keys().length == 0) {
      await initializeMetadataViewsList();
    }
    return this._metadataViewsObject;
  }

  initializeMetadataViewsList() async {
    MetadataEnvelope t = await this.getMetadata();
    var metadata = t.metadata;
    var metadataViews = {};
    metadata.views.fold(
        t, (t, view) => this.createViewImplementations(view, metadataViews));
    this._metadataViewsObject = metadataViews;
  }

  generateIndexedViewName(viewName, metadataViews) {
    var i = 1;

    // TODO;
    // if (viewName in metadataViews) {
    //     while (viewName in metadataViews) {
    //         i++;
    //     }
    //     viewName = '${viewName}${i}';
    // }
    return viewName;
  }

  MetadataEnvelope createViewImplementations(view, metadataViews) {
    for (var viewImplementation in view?.implementations ?? []) {
      if (view.name) {
        var viewName = this.generateIndexedViewName(view.name, metadataViews);
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

  getUriOrFail() async {
    BigMapAbstraction metadataBigMap = this.findMetadataBigMap();
    var uri = await metadataBigMap.get('', contractSchema);
    if (uri == null) {
      throw new UriNotFound();
    }
    return uri;
  }
}
