import 'package:tezster_dart/helper/http_helper.dart';

class SaplingStateAbstraction {
  BigInt id;
  SaplingStateAbstraction(BigInt id) {
    this.id = id;
  }

  // getSaplingDiff(
  //   String rpc,
  //   int block,
  // ) async {
  //   return _getSaplingDiffById(rpc, this.id.toString());
  // }

  getId() {
    return this.id.toString();
  }

  Future _getSaplingDiffById(String rpc, String id,
      {String block = 'head', String chain = 'main'}) async {
    block ??= 'head';
    var response = await HttpHelper.performGetRequest(
        rpc, "chains/$chain/blocks/$block/context/sapling/$id/get_diff");
    return response;
  }
}