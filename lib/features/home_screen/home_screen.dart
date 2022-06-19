import 'package:ecommerce_qtec/main_app/views/common_text_field.dart';
import 'package:flutter/material.dart';

import '../home_view_model/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = ProductsViewModel.watch(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: const [
          SizedBox(
            height: 20,
          ),
          CommonTextField(
            hintText: "Search Product",
            suffixIcon: Icon(Icons.search),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          vm.add(GetProductList());
        },
      ),
    );
  }
}
