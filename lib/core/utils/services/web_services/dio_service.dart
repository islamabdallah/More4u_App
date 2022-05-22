import 'dart:io';

import 'package:dio/dio.dart';
import 'package:more4u/core/constants/api_path.dart';

enum HttpMethod { GET, POST, PUT, DELETE, PATCH }


///using dio client instead of http client has some advantages
/// First, The default value is `JSON`, dio will parse response string to json
/// object automatically, so you don't need to decode response to json.
/// Second, When a error occurs, Dio will wrap the Error/Exception to a DioError
/// this DioError has a type for each error, so you don't need to make conditions
/// to check which type of error depends on error status code.
class DioService {
// you can use baseurl with queryParameters instead of full url
  static Future<Response> request(
      {required String url,
      required HttpMethod method,
      dynamic data,
      Map<String, dynamic>? queryParameters}) async {
// Get the response from the server
//     try {
      Response response;
      switch (method) {
        case HttpMethod.GET:
          response = await Dio().get(
            url,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.POST:
          response = await Dio().post(url,
              data: data,
              queryParameters: queryParameters,
              options: Options(
                // validateStatus: (status) {
                //   return status! <= 500;
                // },
                // headers: {
                //   'Content_Type': 'application/json',
                // },
              ));
          break;
        case HttpMethod.PUT:
          response = await Dio().put(
            url,
            data: data,
            queryParameters: queryParameters,
            // cancelToken: cancelToken,
          );
          break;
        case HttpMethod.DELETE:
          response = await Dio().delete(
            url,
            data: data,
            queryParameters: queryParameters,
            // cancelToken: cancelToken,
          );
          break;
        case HttpMethod.PATCH:
          response = await Dio().patch(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }

      return response;

  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       print(e.response!.statusCode);
  //       print(e.response!.data);
  //     }
  //     print(e.type);
  //     rethrow;
  //   } catch (e) {
  //     throw Exception("Something wen't wrong");
  //   }
  }
}
