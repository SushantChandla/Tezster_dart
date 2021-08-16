import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito-utils/src/taquito-utils.dart';
import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/big-map.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
import 'package:tezster_dart/packages/taquito/src/wallet/wallet.dart';
import 'package:tezster_dart/packages/tzip-16/errors.dart';
import 'package:tezster_dart/packages/tzip-16/metadata-provider.dart';
import 'package:tezster_dart/packages/tzip-16/viewKind/viewFactory.dart';

var metadataBigMapType = MichelsonV1Expression()
  ..prim = 'big_map'
  ..annots = ['%metadata']
  ..args = [
    MichelsonV1Expression()..prim = 'string',
    MichelsonV1Expression()..prim = 'bytes'
  ];

class Tzip16ContractAbstraction {
  MetadataProviderInterface _metadataProvider;
  MetadataEnvelope _metadataEnvelope;
  ViewFactory _viewFactory;
  dynamic _metadataViewsObject;
  dynamic context;
  ContractAbstraction constractAbstraction;
  Tzip16ContractAbstraction(this.constractAbstraction, this.context,
      this._metadataEnvelope, this._metadataProvider);

  BigMapAbstraction findMetadataBigMap() {
    var metadataBigMapId = this
        .constractAbstraction
        .schema
        .FindFirstInTopLevelPair(
            this.constractAbstraction.script.storage, metadataBigMapType);

    if (!metadataBigMapId) {
      throw new BigMapMetadataNotFound();
    }

    return new BigMapAbstraction(BigInt.tryParse(metadataBigMapId['int']),
        new Schema(metadataBigMapType), this.context.contract);
  }

  getMetadata() async {
    if (this._metadataProvider == null) {
      throw new UnconfiguredMetadataProviderError();
    }
    if (this._metadataEnvelope == null) {
      var uri = await this.getUriOrFail();
      this._metadataEnvelope = await this._metadataProvider.provideMetadata(
          this.constractAbstraction, bytes2Char(uri), this.context);
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

    //TODO;
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
        // when views have the same name, add an index at the end of the name
        var viewName = this.generateIndexedViewName(view.name, metadataViews);
        var metadataView = this._viewFactory.getView(viewName, this.context.rpc,
            this.constractAbstraction, viewImplementation);
        if (metadataView) {
          metadataViews[viewName] = metadataView;
        } else {
          print(
              'Skipped generating ${viewName} because the view has an unsupported type: ${this._viewFactory.getImplementationType(viewImplementation)}');
        }
      }
    }
  }

  getUriOrFail()async  {
        BigMapAbstraction metadataBigMap = this.findMetadataBigMap();
        // var uri = await metadataBigMap.;
        // if (!uri) {
        //     throw new UriNotFound();
        // }
        // return uri;
    }

}
