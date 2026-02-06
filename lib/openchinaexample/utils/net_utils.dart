import 'package:http/http.dart' as http;

class NetUtils {
  static const String baseUrl = 'https://api.openchina.com';

  static Future<String> get(String url, Map<String, dynamic> params) async {
    if (params.isNotEmpty) {
      String paramsString = params.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('&');
      url = '$url?$paramsString';
    }
    print('NetUtils: get url: $url');
    final response = await http.get(Uri.parse(baseUrl + url));
    print('NetUtils: get response: ${response.body}');
    return response.body;
  }

  static Future<String> post(String url, Map<String, dynamic> params) async {
    final response = await http.post(Uri.parse(baseUrl + url), body: params);
    return response.body;
  }
}
