import 'dart:developer';
import 'package:dio/dio.dart';
import 'dio_controller.dart';

/// Middleware to check access and refresh token and test data from server if contain errors
class RequestInterceptor extends Interceptor {
  DioController dioController;
  RequestInterceptor({required this.dioController});
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    log("Start RequestInterceptor");
    // await dioController
    //     .checkToken(url: options.path)
    //     .then((value) => options.headers['Authorization'] = 'Bearer $value');
    log(
      '---------------------------------------------------------------------------------------------"\n#Start Request#\n@path:${options.uri}\n@headers:${options.headers}\n@data:${options.data}\n@queryParameters:${options.queryParameters}\n#End Request#\n"---------------------------------------------------------------------------------------------',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path.contains(".json")) {
      log(
        '---------------------------------------------------------------------------------------------"\n#Start Response#\n@path:${response.requestOptions.path}\n@statusCode:${response.statusCode}\n@data:Json File\n#End Response#\n"---------------------------------------------------------------------------------------------',
      );
    } else {
      log(
        '---------------------------------------------------------------------------------------------"\n#Start Response#\n@path:${response.requestOptions.path}\n@statusCode:${response.statusCode}\n@data:${response.data}\n#End Response#\n"---------------------------------------------------------------------------------------------',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      // CustomToast.closeLoading();
      log(
        '---------------------------------------------------------------------------------------------"\n#Start Error#\n@path:${err.requestOptions.path}\n@message:${err.response!.data}\n@code:${err.response!.statusCode}\n@type:${err.type}\n#End Error#\n"---------------------------------------------------------------------------------------------',
      );
      if (err.response!.statusCode == 403) {
        // await dioController.checkToken(
        //     url: "shouldRefresh", shouldRefresh: true);
      }
      log("shouldRefresh (403 Token is expired)");
    } else {
      log(
        '---------------------------------------------------------------------------------------------"\n#Start Error#\n@path:${err.requestOptions.path}\n@message:${err.message}\n@code:UnKnown\n@type:${err.type}\n#End Error#\n"---------------------------------------------------------------------------------------------',
      );
    }
    super.onError(err, handler);
  }
}
