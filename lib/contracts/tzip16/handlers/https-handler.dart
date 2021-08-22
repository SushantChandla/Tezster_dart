import 'package:tezster_dart/helper/http_helper.dart';

class HttpHandler {
  static Future<dynamic> getMetaData(
      String server, String protocol, String location) {
    return HttpHelper.performGetRequest(
        server, '$protocol:${Uri.decodeComponent(location)}}',
        responseJson: false);
  }
}
