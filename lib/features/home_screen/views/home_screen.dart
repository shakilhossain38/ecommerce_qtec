import 'package:ecommerce_qtec/features/home_screen/models/product_list_model.dart';
import 'package:ecommerce_qtec/main_app/views/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    ProductsViewModel.read(context).add(GetProductsList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = ProductsViewModel.watch(context);
    Widget _buildProductsCard(
        BuildContext context, ProductListModel model, List<Result>? list) {
      return Expanded(
        child: ListView.builder(
            itemCount: vm.productsList?.length,
            itemBuilder: (context, index) {
              var data = vm.productsList![index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text("Name: ${data.productName}"),
                        Text("id: ${data.id}"),
                        Text("brand: ${data.brand}"),
                        Text("amount: ${data.amount}"),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CommonTextField(
              hintText: "Search Product",
              onFieldSubmitted: (v) {
                ProductsViewModel.read(context)
                    .add(GetProductsList(searchValue: v));
              },
              suffixIcon: const Icon(Icons.search),
            ),
            vm.products == null || vm.products?.data?.products == null
                ? const SizedBox()
                : _buildProductsCard(context, vm.products!, vm.productsList),
          ],
        ),
      ),
    );
  }
}
