import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class GetProductList {}

class ProductsViewModel extends Bloc<GetProductList, void> {
  static ProductsViewModel read(BuildContext context) =>
      context.read<ProductsViewModel>();
  static ProductsViewModel watch(BuildContext context) =>
      context.watch<ProductsViewModel>();
  ProductsViewModel() : super(0) {
    on<GetProductList>((event, emit) async {
      var response = await http.get(Uri.parse(
          "https://panel.supplyline.network/api/product/search-suggestions/?limit=10&offset=10&search=rice"));
      print("reponse body ${response.body}");
    });
    // on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}
