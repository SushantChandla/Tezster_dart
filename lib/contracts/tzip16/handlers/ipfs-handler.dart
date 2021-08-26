import 'package:tezster_dart/helper/http_helper.dart';

class IpfsHttpHandler {
  static Future<dynamic> getMetaData(server, protocol, location,
      {String ipfsGateway = 'ipfs.io'}) {
    return HttpHelper.performGetRequest(
        'https://$ipfsGateway', '/ipfs/${location.substring(2)}/',
        responseJson: false);
  }
}
