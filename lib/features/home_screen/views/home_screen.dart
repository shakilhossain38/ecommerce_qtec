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
    var vm = ProductsViewModel.read(context);
    vm.add(GetProductsList());
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        if ((vm.products?.data?.products?.count! ?? 0) >
            (vm.productsList?.length ?? 0)) {
          offset = offset + 10;
          vm.add(GetProductsList(
              searchValue:
                  _searchController.text.isEmpty ? "" : _searchController.text,
              offset: offset));
        }
      }
    });
    super.initState();
  }

  int offset = 10;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var vm = ProductsViewModel.watch(context);
    Widget _buildProductsCard(
        BuildContext context, ProductListModel model, List<Result>? list) {
      return Expanded(
        child: GridView.builder(
          itemCount: list?.length,
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              mainAxisExtent: 132),
          itemBuilder: (BuildContext context, int index) {
            var data = vm.productsList![index];
            return GestureDetector(
                onTap: () {},
                child: Container(
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
                ));
          },
        ),
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
              controller: _searchController,
              onFieldSubmitted: (v) {
                offset = 10;
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
