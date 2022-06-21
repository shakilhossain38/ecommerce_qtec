// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
//
// import '../models/product_list_model.dart';
//
// class CounterEvent {}
//
// class ProductsStates extends CounterEvent {
//   ProductListModel? listModel;
//   ProductsStates({this.listModel});
// }
//
// class ProductsViewModel extends Bloc<CounterEvent, void> {
//   static ProductsViewModel read(BuildContext context) =>
//       context.read<ProductsViewModel>();
//   static ProductsViewModel watch(BuildContext context) =>
//       context.watch<ProductsViewModel>();
//
//   ProductsViewModel() : super(0) {
//     on<ProductsStates>((event, emit) async {
//       var response = await http.get(Uri.parse(
//           "https://panel.supplyline.network/api/product/search-suggestions/?limit=10&offset=10&search=rice"));
//       ProductListModel data = productListModelFromJson(response.body);
//       ProductsStates().listModel = data;
//       print("reponse body ${response.body}");
//     });
//
//     List abcd = [];
//     // on<CounterDecrementPressed>((event, emit) => emit(state - 1));
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:ecommerce_qtec/features/home_screen/models/product_list_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/producty_list_repository.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class GetProductsList extends ProductsEvent {
  String? searchValue;
  int? offset;
  GetProductsList({this.searchValue, this.offset = 0});
}

abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final ProductListModel products;
  final List<Result>? productList;
  const ProductsLoaded(this.products, this.productList);
}

class ProductsViewModel extends Bloc<ProductsEvent, ProductsState> {
  static ProductsViewModel read(BuildContext context) =>
      context.read<ProductsViewModel>();
  static ProductsViewModel watch(BuildContext context) =>
      context.watch<ProductsViewModel>();
  final TextEditingController searchController = TextEditingController();
  List<Result>? productsList = [];
  ProductListModel? products;
  bool? isLoading = false;

  ProductsViewModel() : super(ProductsInitial()) {
    on<GetProductsList>((event, emit) async {
      if (event.offset != 0) {
        isLoading = true;
      }
      emit(ProductsLoading());
      var res = await ProductListRepository()
          .fetchProducts(searchValue: event.searchValue, offset: event.offset!);
      res.fold((l) {
        isLoading = false;
      }, (r) {
        if (event.offset != 0) {
          products = r;
          isLoading = false;
          searchController.text = event.searchValue ?? "";
          productsList = [...?productsList, ...?r.data?.products?.results];
          emit(ProductsLoaded(r, r.data?.products?.results));
        } else {
          isLoading = false;
          products = r;
          searchController.text = event.searchValue ?? "";
          productsList = r.data?.products?.results;
          emit(ProductsLoaded(r, r.data?.products?.results));
        }
      });
    });
  }
}
