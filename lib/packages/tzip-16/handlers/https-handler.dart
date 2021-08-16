// async getMetadata(_contractAbstraction: ContractAbstraction<ContractProvider | Wallet>, { protocol, location }: Tzip16Uri, _context: Context) {
//         return this.httpBackend.createRequest<string>({
//             url: `${protocol}:${decodeURIComponent(location)}`,
//             method: 'GET',
//             mimeType: "text; charset=utf-8",
//             json: false
//         })
//     }

import 'package:tezster_dart/helper/http_helper.dart';

class HttpHandler {
  static Future<dynamic> getMetaData(
      String server, String protocol, String location) {
    return HttpHelper.performGetRequest(
        server, '$protocol:${Uri.decodeComponent(location)}}',
        respondJson: false
       );
  }
}
