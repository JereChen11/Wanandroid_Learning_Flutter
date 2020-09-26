import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

import 'constant.dart';

@deprecated
class MyInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) {
    print("MyInterceptor: onRequest");
    List<String> cookieStringList = SpUtil().getStringList(Constant.cookieListKey);
    print("cookieStringList = ${cookieStringList.toString()}");

    options.headers[HttpHeaders.cookieHeader] = cookieStringList.toString();
    cookieStringList.forEach((element) {
      print("cookieStringList element = $element");
      options.headers[HttpHeaders.cookieHeader] = element;
    });
    return super.onRequest(options);
  }

  @override
  Future onError(DioError err) {
    print("MyInterceptor: onError");
    return super.onError(err);
  }

  @override
  Future onResponse(Response response) {
    print("MyInterceptor: onResponse response.data = ${response.data}");
    return super.onResponse(response);
  }

}
