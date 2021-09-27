import 'package:tezster_dart/contracts/big_map.dart';
import 'package:tezster_dart/contracts/tzip12/errors.dart';
import 'package:tezster_dart/contracts/tzip16/tzip16-contract.dart';
import 'package:tezster_dart/contracts/tzip16/viewKind/michelsonStorage-view.dart';
import 'package:tezster_dart/contracts/utils/utils.dart';
import 'package:tezster_dart/michelson_encoder/helpers/michelson_map.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

var _tokenMetaBigMap = {
  'annots': ['%token_metadata'],
  'args': [
    {'prim': 'nat'},
    {
      'prim': 'pair',
      'args': [
        {
          'prim': 'nat',
          'annots': ['%token_id']
        },
        {
          'prim': "map",
          'args': [
            {'prim': 'string'},
            {'prim': 'bytes'}
          ],
          'annots': ['%token_info']
        }
      ]
    }
  ],
  'prim': 'big_map'
};

class Tzip12Contract extends Tzip16Contract {
  Tzip12Contract({required String rpcServer, required String address})
      : super(rpcServer: rpcServer, address: address);

  getTokenMetadata(int tokenId) async {
    var tokenMetadata = await this._retrieveTokenMetadataFromView(tokenId);
    return (tokenMetadata == null)
        ? this._retrieveTokenMetadataFromBigMap(tokenId)
        : tokenMetadata;
  }

  _retrieveTokenMetadataFromView(int tokenId) async {
    var views = (await this.metadataViews()) as Map;
    if (views != null && this._hasTokenMetadataView(views)) {
      return this._executeTokenMetadataView(views['token_metadata'](), tokenId);
    }
  }

  _hasTokenMetadataView(Map views) {
    for (var view in views.keys) {
      if (view == 'token_metadata') {
        return true;
      }
    }
    return false;
  }

  _executeTokenMetadataView(View tokenMetadataView, int tokenId) async {
    var tokenMetadata;
    try {
      tokenMetadata = await tokenMetadataView.executeView(tokenId);
    } catch (err) {
      throw new TokenIdNotFound(tokenId);
    }
    var tokenMap = tokenMetadata.values.first;
    if (!MichelsonMap.isMichelsonMap(tokenMap)) {
      throw new TokenMetadataNotFound(address);
    }
    var metadataFromUri =
        await this._fetchTokenMetadataFromUri(tokenMap as MichelsonMap);
    return this._formatMetadataToken(tokenId, tokenMap, metadataFromUri);
  }

  _retrieveTokenMetadataFromBigMap(tokenId) async {
    var bigmapTokenMetadataId = _findTokenMetadataBigMap();
    var pairNatMap;
    try {
      pairNatMap = await BigMapAbstraction(bigmapTokenMetadataId,
              Schema(MichelsonV1Expression.j(_tokenMetaBigMap)))
          .getBigMapKeyByID(rpcServer, tokenId);
    } catch (err) {
      throw TokenIdNotFound(tokenId);
    }

    var michelsonMap = pairNatMap['token_info'];
    if (!MichelsonMap.isMichelsonMap(michelsonMap)) {
      throw new TokenIdNotFound(tokenId);
    }
    var metadataFromUri =
        await this._fetchTokenMetadataFromUri(michelsonMap as MichelsonMap);
    return this._formatMetadataToken(tokenId, michelsonMap, metadataFromUri);
  }

  _fetchTokenMetadataFromUri(MichelsonMap tokenMetadata) async {
    var uri = tokenMetadata.get('', '{"string":""}');
    if (uri != null) {
      try {
        var metadataFromUri =
            await metadataProvider.provideMetadata(bytes2Char(uri), this);
        return metadataFromUri['metadata'];
      } catch (e) {
        print('Uri : ${bytes2Char(uri)}');
        throw e;
      }
    }
  }

  _formatMetadataToken(
      int tokenId, MichelsonMap metadataTokenMap, metadataFromUri) {
    Map<String, dynamic> tokenMetadataDecoded = {'token_id': tokenId};
    for (var keyTokenMetadata in metadataTokenMap.keys()) {
      if (keyTokenMetadata == 'decimals') {
        tokenMetadataDecoded[keyTokenMetadata] =
            int.parse(bytes2Char(metadataTokenMap.get(keyTokenMetadata)));
      } else if (keyTokenMetadata != '') {
        var val = metadataTokenMap.get(keyTokenMetadata);
        tokenMetadataDecoded[keyTokenMetadata.toString()] = bytes2Char(val);
      }
    }
    if (metadataFromUri != null && metadataFromUri is Map) {
      for (var property in metadataFromUri.entries) {
        tokenMetadataDecoded[property.key] = property.value;
      }
    }
    if (!tokenMetadataDecoded.containsKey('decimals')) {
      throw InvalidTokenMetadata();
    }
    return tokenMetadataDecoded;
  }

  BigInt _findTokenMetadataBigMap() {
    var tokenMetadataBigMapId = contractSchema!
        .findFirstInTopLevelPair(contractStorage, _tokenMetaBigMap);
    if (tokenMetadataBigMapId == null) {
      throw new TokenMetadataNotFound(address);
    }
    return BigInt.parse(tokenMetadataBigMapId['int']);
  }
}
