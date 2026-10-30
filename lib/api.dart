import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';

class MockApiInterceptor implements InterceptorContract {
  @override
  Future<bool> shouldInterceptRequest() async => true;

  @override
  Future<bool> shouldInterceptResponse() async => true;

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    final uri = Uri.parse(data.url);
    final pathname = uri.path.replaceAll(RegExp(r'/$'), ''); // Strip trailing slash

    // Match /api/get-ram regardless of domain, base href, or trailing slashes
    if (pathname.endsWith('/api/get-ram') || pathname == '/api/get-ram') {
      
      // Handle GET request
      if (data.method.toString().toUpperCase() == 'GET') {
        return data.copyWith(
          statusCode: 200,
          body: jsonEncode({"ram_mb": 1024}),
          headers: {
            ...data.headers,
            'content-type': 'application/json',
          },
        );
      }

      // Handle POST request parsing `target_mb` from the request body
      if (data.method.toString().toUpperCase() == 'POST') {
        int targetMb = 1024; // Default fallback
        try {
          if (data.body != null) {
            final decoded = jsonDecode(data.body!);
            if (decoded is Map && decoded.containsKey('target_mb')) {
              targetMb = decoded['target_mb'];
            }
          }
        } catch (_) {}

        return data.copyWith(
          statusCode: 201,
          body: jsonEncode({
            "success": true, 
            "message": "POST request mocked successfully",
            "ram_mb": targetMb,
          }),
          headers: {
            ...data.headers,
            'content-type': 'application/json',
          },
        );
      }
    }

    return data;
  }
}
