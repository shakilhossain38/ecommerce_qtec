import 'package:cached_network_image/cached_network_image.dart';
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
                (vm.productsList?.length ?? 0) &&
            !vm.isLoading!) {
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

  int offset = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var vm = ProductsViewModel.watch(context);
    var spaceBetween = const SizedBox(
      height: 10,
    );
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
                mainAxisExtent: 270),
            itemBuilder: (BuildContext context, int index) {
              var data = vm.productsList![index];
              double? price =
                  (vm.productsList![index].charge?.currentCharge ?? 0) * .9;
              return Stack(
                children: [
                  SizedBox(
                    height: 250,
                    // width: 200,
                    //color: Colors.red,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            spaceBetween,
                            data.stock == 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: const Color(0xffFFCCCC)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text("স্টকে নেই",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                : const Text(""),
                            // spaceBetween,
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: data.image!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              data.productName ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("ক্রয় "),
                                    Text(
                                      "৳${data.charge?.currentCharge}",
                                      style: const TextStyle(
                                          color: Color(0xffDA2079),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(
                                  "৳${price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Color(0xffDA2079),
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                data.charge?.sellingPrice == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          const Text("বিক্রয় ",
                                              style: TextStyle(
                                                color: Color(0xff646464),
                                              )),
                                          Text(
                                            "৳${data.charge?.sellingPrice ?? ""}",
                                            style: const TextStyle(
                                                color: Color(0xff646464),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                data.charge?.profit == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          const Text("লাভ ",
                                              style: TextStyle(
                                                color: Color(0xff646464),
                                              )),
                                          Text(
                                            "৳${data.charge?.profit ?? ""}",
                                            style: const TextStyle(
                                                color: Color(0xff646464),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            spaceBetween,
                          ],
                        ),
                      ),
                    ),
                  ),
                  data.stock == 0
                      ? const SizedBox()
                      : const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Color(0xff6210E1),
                            radius: 20,
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                ],
              );
            }),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            children: [
              spaceBetween,
              spaceBetween,
              CommonTextField(
                hintText: "খুঁজুন",
                controller: _searchController,
                fillColor: Colors.white,
                isFilled: true,
                onFieldSubmitted: (v) {
                  offset = 0;
                  ProductsViewModel.read(context)
                      .add(GetProductsList(searchValue: v));
                },
                suffixIcon: const Icon(Icons.search),
              ),
              spaceBetween,
              vm.products == null || vm.products?.data?.products == null
                  ? const SizedBox()
                  : _buildProductsCard(context, vm.products!, vm.productsList),
              vm.isLoading!
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: CircularProgressIndicator(),
                    ))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
