import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_qtec/features/home_screen/models/product_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../main_app/failure/app_error.dart';
import '../../../main_app/resource/urls.dart';
import '../../../main_app/utils/api_client.dart';

class ProductListRepository {
  Future<Either<AppError, ProductListModel>> fetchProducts(
      {String? searchValue, int offset = 10}) async {
    BotToast.showLoading();
    var response = await ApiClient().getRequest(
        "${Urls.productsUrl}&offset=$offset&search=${searchValue ?? ""}");
    debugPrint('products ${response.body}');
    try {
      if (response.statusCode == 200) {
        BotToast.closeAllLoading();
        ProductListModel data =
            productListModelFromJson(utf8.decode(response.bodyBytes));
        return Right(data);
      } else {
        BotToast.closeAllLoading();
        return const Left(AppError.serverError);
      }
    } catch (c) {
      return const Left(AppError.networkError);
    }
  }
}
