import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// API base URL for events
  static const String baseUrl =
      "https://gist.githubusercontent.com/degisew/83563097c967c13b6be276d7caa1f1e8/raw";

  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? query}) async {
    try {
      // If path starts with 'http', use it as full URL; otherwise join with baseUrl
      final Uri uri = path.startsWith('http')
          ? Uri.parse(path).replace(queryParameters: query)
          : Uri.parse('$baseUrl/$path').replace(queryParameters: query);

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'data': data, 'statusCode': response.statusCode};
      } else if (response.statusCode == 404) {
        throw Exception('Events not found. Please check your connection.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception(
            'Failed to load events (${response.statusCode}). Please try again.');
      }
    } on FormatException {
      throw Exception('Invalid data format received from server.');
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        throw Exception('No internet connection. Please check your network.');
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
