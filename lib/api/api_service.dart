import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wanandroid_learning_flutter/api/dio_util.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/model/article_category_bean.dart';
import 'package:wanandroid_learning_flutter/model/banner_data.dart';
import 'package:wanandroid_learning_flutter/model/coin_bean.dart';
import 'package:wanandroid_learning_flutter/model/coin_list_bean.dart';
import 'package:wanandroid_learning_flutter/model/coin_rank_bean.dart';
import 'package:wanandroid_learning_flutter/model/collect_article_bean.dart';
import 'package:wanandroid_learning_flutter/model/user_bean.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

class ApiService {
  static const String BASE_URL = "https://www.wanandroid.com";

  void getHomeBanner(Function callback) async {
    Response response = await DioUtil().get("$BASE_URL/banner/json");
    callback(BannerData.fromJson(json.decode(response.data)));
  }

  void getHomeArticleList(int pageNumber, Function callback) async {
    Response response =
        await DioUtil().get("$BASE_URL/article/list/$pageNumber/json");
    callback(ArticleBean.fromJson(json.decode(response.data)));
  }

  void collectArticle(int articleId, Function callback) async {
    Response response =
        await DioUtil().post("$BASE_URL/lg/collect/$articleId/json");
    callback(CollectArticleBean.fromJson(json.decode(response.data)));
  }

  void uncollectedArticle(int articleId, Function callback) async {
    Response response =
        await DioUtil().post("$BASE_URL/lg/uncollect_originId/$articleId/json");
    callback(CollectArticleBean.fromJson(json.decode(response.data)));
  }

  void getProjectArticleCategory(Function callback) async {
    Response response = await DioUtil().get("$BASE_URL/project/tree/json");
    callback(ArticleCategoryBean.fromJson(json.decode(response.data)));
  }

  void getProjectArticleData(
      int pageNumber, int projectCategoryId, Function callback) async {
    Response response = await DioUtil()
        .get("$BASE_URL/project/list/$pageNumber/json?cid=$projectCategoryId");
    print("getCompleteProjectArticle response = $response");
    callback(ArticleBean.fromJson(json.decode(response.data)));
  }

  void getWeChatArticleCategory(Function callback) async {
    Response response =
        await DioUtil().get("$BASE_URL/wxarticle/chapters/json");
    callback(ArticleCategoryBean.fromJson(json.decode(response.data)));
  }

  void getWeChatArticleData(
      int bloggerId, int pageNumber, Function callback) async {
    Response response = await DioUtil()
        .get("$BASE_URL/wxarticle/list/$bloggerId/$pageNumber/json");
    callback(ArticleBean.fromJson(json.decode(response.data)));
  }

  void getKnowledgeSystemArticleCategory(Function callback) async {
    Response response = await DioUtil().get("$BASE_URL/tree/json");
    callback(ArticleCategoryBean.fromJson(json.decode(response.data)));
  }

  void getKnowledgeSystemArticleData(
      int pageNumber, int knowledgeSystemCategoryId, Function callback) async {
    Response response = await DioUtil().get(
        "$BASE_URL/article/list/$pageNumber/json?cid=$knowledgeSystemCategoryId");
    callback(ArticleBean.fromJson(json.decode(response.data)));
  }

  void login(Map<String, dynamic> data, Function callback) async {
    Response response =
        await DioUtil().post("$BASE_URL/user/login?", data: data);
    List<String> cookieStringList = response.headers["Set-Cookie"];
    print("cookieStringList = $cookieStringList");
    SpUtil().putStringList(Constant.cookieListKey, cookieStringList);
    callback(UserBean.fromJson(json.decode(response.data)));
  }

  void logout(Function callback) async {
    Response response = await DioUtil().get("$BASE_URL/user/logout/json");
    callback(UserBean.fromJson(json.decode(response.data)));
  }

  void register(Map<String, dynamic> data, Function callback) async {
    Response response =
        await DioUtil().post("$BASE_URL/user/register?", data: data);
    List<String> cookieStringList = response.headers["Set-Cookie"];
    print("cookieStringList = $cookieStringList");
    SpUtil().putStringList(Constant.cookieListKey, cookieStringList);
    callback(UserBean.fromJson(json.decode(response.data)));
  }

  void getPersonalCoinData(Function callback) async {
    Response response = await DioUtil().get("$BASE_URL/lg/coin/userinfo/json");
    callback(CoinBean.fromJson(json.decode(response.data)));
  }

  void getPersonalCoinListData(int pageNumber, Function callback) async {
    Response response =
        await DioUtil().get("$BASE_URL/lg/coin/list/$pageNumber/json");
    callback(CoinListBean.fromJson(json.decode(response.data)));
  }

  void getCoinRankData(int pageNumber, Function callback) async {
    Response response =
        await DioUtil().get("$BASE_URL/coin/rank/$pageNumber/json");
    callback(CoinRankBean.fromJson(json.decode(response.data)));
  }
}
