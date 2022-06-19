import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../resource/urls.dart';

enum ApiUrlType {
  login,
  signUp,
}

class ApiClient {
  http.Client httClient = http.Client();

  Future<http.Response> getRequest(String url, {bool isPublic = false}) async {
    var completeUrl = _buildUrl(url);
    var headers = await _getHeaders();
    return isPublic
        ? httClient.get(Uri.parse(completeUrl))
        : httClient.get(Uri.parse(completeUrl), headers: headers);
  }

  Future<http.Response> postRequest(String url, Map<String, dynamic> body,
      {Duration? timeout}) async {
    var completeUrl = _buildUrl(url);
    var headers = await _getHeaders();
    var encodedBody = json.encode(body);
    return httClient
        .post(Uri.parse(completeUrl), headers: headers, body: encodedBody)
        .timeout(Duration(seconds: 15));
  }

  Future<http.Response> deleteRequest(String url, {Duration? timeout}) async {
    var completeUrl = _buildUrl(url);
    var headers = await _getHeaders();
    //var encodedBody = json.encode(body);
    return httClient
        .delete(Uri.parse(completeUrl), headers: headers)
        .timeout(Duration(seconds: 15));
  }

  Future<http.Response> putRequest(String url, Map<String, dynamic> body,
      {Duration? timeout}) async {
    var completeUrl = _buildUrl(url);
    var headers = await _getHeaders();
    var encodedBody = json.encode(body);
    return httClient.put(Uri.parse(completeUrl),
        headers: headers, body: encodedBody);

//    return httClient.put(completeUrl, headers: headers, body: encodedBody);
  }

  Future<Map<String, String>> _getHeaders() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    return headers;
  }

  _buildUrl(String partialUrl) {
    String baseUrl = Urls.baseUrl;
    return baseUrl + partialUrl;
  }
}
