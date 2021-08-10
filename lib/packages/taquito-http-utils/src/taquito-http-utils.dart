import 'package:flutter/material.dart';

class HttpBackend {
  createRequest<T>(
      {@required String url,
      @required String methods,
      int timeout,
      bool json,
      Map<String, dynamic> query,
      Map<String, dynamic> headers,
      String mimeType}) {}
}
