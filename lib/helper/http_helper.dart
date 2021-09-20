import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  static Future<dynamic> performPostRequest(server, command, payload,
      {Map<String, String?>? headers}) async {
    headers?.removeWhere((key, value) => value == null);
    Map<String, String> header =
        headers != null ? headers as Map<String, String> : {};
    var response = await http.post(
      command.isEmpty ? Uri.parse(server) : Uri.parse("$server/$command"),
      headers: {'Content-type': 'application/json', ...header},
      body: utf8.encode(json.encode(payload)),
    );
    return response.body;
  }

  static Future<dynamic> performGetRequest(server, command,
      {bool responseJson = true}) async {
    var response = (await http.get(Uri.parse('$server/$command'))).body;
    if (responseJson) return jsonDecode(response);
    return response;
  }
}
