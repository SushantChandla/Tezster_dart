import 'package:tezster_dart/helper/http_helper.dart';

class IpfsHttpHandler {
  static Future<dynamic> getMetaData(
      String server, String protocol, String location,
      {String ipfsGateway = 'ipfs.io'}) {
    return HttpHelper.performGetRequest(
        server, 'https://$ipfsGateway/ipfs/${location.substring(2)}/',
        responseJson: false);
  }
}
