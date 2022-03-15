import 'dart:async';

import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';
import 'dart:convert';
import 'dart:core';
import 'common.dart';
import 'event.dart';

// final Logger log = new Logger('requests');

class Requests {
  const Requests();

  static final Event onError = Event();
  static const String HTTP_METHOD_GET = "get";
  static const String HTTP_METHOD_PUT = "put";
  static const String HTTP_METHOD_PATCH = "patch";
  static const String HTTP_METHOD_DELETE = "delete";
  static const String HTTP_METHOD_POST = "post";
  static const String HTTP_METHOD_HEAD = "head";
  static const int DEFAULT_TIMEOUT_SECONDS = 10;

  static Set _cookiesKeysToIgnore = Set.from(["SameSite", "Path", "Domain", "Max-Age", "Expires", "Secure", "HttpOnly"]);

  static Map<String, String> _extractResponseCookies(responseHeaders) {
    Map<String, String> cookies = {};
    for (var key in responseHeaders.keys) {
      if (Common.equalsIgnoreCase(key, 'set-cookie')) {
        String cookie = responseHeaders[key];
        cookie.split(";").map((x) => x.trim().split("=")).where((x) => x.length == 2).where((x) => !_cookiesKeysToIgnore.contains(x[0])).forEach((x) => cookies[x[0]] = x[1]);
        break;
      }
    }

    return cookies;
  }

  static Future<Map> _constructRequestHeaders(String hostname, Map<String, String> customHeaders) async {
    var cookies = await getStoredCookies(hostname);
    String cookie = cookies.keys.map((key) => "$key=${cookies[key]}").join("; ");
    Map<String, String> requestHeaders = Map();
    requestHeaders['cookie'] = cookie;
    requestHeaders['Content-Type'] = 'application/json; charset=UTF-8';

    if (customHeaders != null) {
      requestHeaders.addAll(customHeaders);
    }
    return requestHeaders;
  }

  static Future<Map<String, String>> getStoredCookies(String hostname) async {
    try {
      String hostnameHash = Common.hashStringSHA256(hostname);
      String cookiesJson = await Common.storageGet('cookies-$hostnameHash');
      var cookies = Common.fromJson(cookiesJson);
      return Map<String, String>.from(cookies);
    } catch (e) {
      // log.shout("problem reading stored cookies. fallback with empty cookies $e");
      return new Map<String, String>();
    }
  }

  static Future setStoredCookies(String hostname, Map<String, String> cookies) async {
    String hostnameHash = Common.hashStringSHA256(hostname);
    String cookiesJson = Common.toJson(cookies);
    await Common.storageSet('cookies-$hostnameHash', cookiesJson);
  }

  static Future clearStoredCookies(String hostname) async {
    String hostnameHash = Common.hashStringSHA256(hostname);
    await Common.storageSet('cookies-$hostnameHash', null);
  }

  static String getHostname(String url) {
    var uri = Uri.parse(url);
    return uri.host;
  }

  static Future<http.Response> _handleHttpResponse(String url, String hostname, http.Response response, bool json1, bool persistCookies) async {

    if (persistCookies) {
      var responseCookies = _extractResponseCookies(response.headers);
      if (responseCookies.isNotEmpty) {
        var storedCookies = await getStoredCookies(hostname);
        storedCookies.addAll(responseCookies);
        await setStoredCookies(hostname, storedCookies);
      }
    }

    return response;
  }

  static Future<http.Response> head(String url, {headers, timeoutSeconds = DEFAULT_TIMEOUT_SECONDS, json = false, persistCookies = true}) {
    return _httpRequest(HTTP_METHOD_HEAD, url, headers: headers, timeoutSeconds: timeoutSeconds, json: json, persistCookies: persistCookies);
  }

  static Future<http.Response> get(String url, {headers, timeoutSeconds = DEFAULT_TIMEOUT_SECONDS, json = false, persistCookies = true}) {
    return _httpRequest(HTTP_METHOD_GET, url, headers: headers, timeoutSeconds: timeoutSeconds, json: json, persistCookies: persistCookies);
  }

  static Future<http.Response> patch(String url, {headers, timeoutSeconds = DEFAULT_TIMEOUT_SECONDS, json = false, persistCookies = true}) {
    return _httpRequest(HTTP_METHOD_PATCH, url, headers: headers, timeoutSeconds: timeoutSeconds, json: json, persistCookies: persistCookies);
  }

  static Future<http.Response> delete(String url, {headers, timeoutSeconds = DEFAULT_TIMEOUT_SECONDS, json = false, persistCookies = true}) {
    return _httpRequest(HTTP_METHOD_DELETE, url, headers: headers, timeoutSeconds: timeoutSeconds, json: json, persistCookies: persistCookies);
  }

  static Future<http.Response> post(String url, {body, headers, timeoutSeconds = DEFAULT_TIMEOUT_SECONDS, json = false, persistCookies = true}) {
    return _httpRequest(HTTP_METHOD_POST, url, body: body, headers: headers, timeoutSeconds: timeoutSeconds, json: json, persistCookies: persistCookies);
  }

  static Future<http.Response> put(String url, {body, headers, timeoutSeconds = DEFAULT_TIMEOUT_SECONDS, json = false, persistCookies = true}) {
    return _httpRequest(HTTP_METHOD_PUT, url, body: body, headers: headers, timeoutSeconds: timeoutSeconds, json: json, persistCookies: persistCookies);
  }

  static Future<http.Response> _httpRequest(String method, String url, {body, headers, timeoutSeconds = DEFAULT_TIMEOUT_SECONDS, json = false, persistCookies = true}) async {
    var client = http.Client();
    var uri = Uri.parse(url);
    String hostname = uri.host;
    headers = await _constructRequestHeaders(hostname, headers);
    String bodyString = "";

    if (body != null) {
      String contentTypeHeader;
      if (body is String) {
        bodyString = body;
        contentTypeHeader = "text/plain";
      } else if (body is Map || body is List) {
        bodyString = Common.toJson(body);
        contentTypeHeader = "application/json";
      }

      if (contentTypeHeader != null && !Common.hasKeyIgnoreCase(headers, "content-type")) {
        headers["content-type"] = contentTypeHeader;
      }
    }

    method = method.toLowerCase();
    Future future;
    switch (method) {
      case HTTP_METHOD_GET:
        future = client.get(uri, headers: headers);
        break;
      case HTTP_METHOD_PUT:
        future = client.put(uri, body: bodyString, headers: headers);
        break;
      case HTTP_METHOD_DELETE:
        future = client.delete(uri, headers: headers);
        break;
      case HTTP_METHOD_POST:
        future = client.post(uri, body: bodyString, headers: headers);
        break;
      case HTTP_METHOD_HEAD:
        future = client.head(uri, headers: headers);
        break;
      case HTTP_METHOD_PATCH:
        future = client.patch(uri, body: bodyString, headers: headers);
        break;
      default:
        throw new Exception('unsupported http method $method"');
    }

    var response = await future.timeout(Duration(seconds: timeoutSeconds));
    return await _handleHttpResponse(url, hostname, response, json, persistCookies);
  }
}