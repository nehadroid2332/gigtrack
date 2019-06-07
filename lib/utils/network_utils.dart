import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,
      {Map body, encoding, Map<String, String> headers}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception(json.decode(response?.body ??
            {"message": "Error while fetching data", "status": statusCode}));
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> upload(
      String apiUrl,
      String fileKey,
      File file,
      Map<String, String> fields,
      Map<String, String> headers,
      String type) async {
    var contentType;

    String name = basename(file.path);
    if (name.contains(".jpg") ||
        name.contains(".jpeg") ||
        name.contains(".png"))
      contentType =
          "image/${basename(file.path).replaceAll(basenameWithoutExtension(file.path), '').replaceAll('.', '').replaceAll("jpg", "jpeg")}";
    else
      contentType =
          "application/${basename(file.path).replaceAll(basenameWithoutExtension(file.path), '').replaceAll('.', '')}";

    contentType = lookupMimeType(file.path);

    final files = <http.MultipartFile>[];
    if (await file.exists()) {
      final length = await file.length();
      if (contentType != null)
        files.add(new http.MultipartFile(fileKey, file.openRead(), length,
            contentType: MediaType.parse(contentType),
            filename: basename(file.path)));
      else
        files.add(new http.MultipartFile(fileKey, file.openRead(), length,
            filename: basename(file.path)));
    }

    final request = new http.MultipartRequest(type, Uri.parse(apiUrl))
      ..fields.addAll(fields)
      ..files.addAll(files)
      ..headers.addAll(headers);

    // http.Response response =
    //     await http.Response.fromStream(await request.send());

    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient client = new IOClient(httpClient);

    try {
      final response =
          await http.Response.fromStream(await client.send(request));
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception(json.decode(response?.body ??
            {"message": "Error while fetching data", "status": statusCode}));
      }
      return _decoder.convert(res);
    } catch (e) {
      client.close();
      return e;
    }
  }
}
