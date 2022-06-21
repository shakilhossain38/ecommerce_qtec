import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_qtec/features/home_screen/models/product_list_model.dart';
import 'package:ecommerce_qtec/features/home_screen/views/product_details_widget.dart';
import 'package:ecommerce_qtec/main_app/resource/colors.dart';
import 'package:ecommerce_qtec/main_app/resource/string_resources.dart';
import 'package:ecommerce_qtec/main_app/views/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/counter_bloc.dart';
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
              searchValue: vm.searchController.text.isEmpty
                  ? ""
                  : vm.searchController.text,
              offset: offset));
        }
      }
    });
    super.initState();
  }

  int offset = 0;
  TextEditingController _search = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var vm = ProductsViewModel.watch(context);
    var counterVm = CounterBloc.watch(context);
    var spaceBetween = const SizedBox(
      height: 10,
    );
    var width = MediaQuery.of(context).size.width;
    Widget _buildProductsCard(
        BuildContext context, ProductListModel model, List<Result>? list) {
      return vm.products?.data?.products?.count == 0
          ? Center(child: Text(StringResources.noProductText))
          : Expanded(
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
                        (vm.productsList![index].charge?.currentCharge ?? 0) *
                            .9;
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => ProductDetailsWidget(
                                          product: list![index],
                                          index: index,
                                          cartValue: counterVm.cartValue,
                                        )))
                                .then((value) {
                              offset = 0;
                            });
                          },
                          child: SizedBox(
                            height: 250,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, right: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    spaceBetween,
                                    data.stock == 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: const Color(
                                                          0xffFFCCCC)),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(4.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text("${StringResources.buyText} "),
                                            Text(
                                              "৳${data.charge?.currentCharge}",
                                              style: TextStyle(
                                                  color: AppTheme
                                                      .secondaryPinkColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "৳${price.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: AppTheme.secondaryPinkColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        data.charge?.sellingPrice == null
                                            ? const SizedBox()
                                            : Row(
                                                children: [
                                                  Text(
                                                      "${StringResources.sellText} ",
                                                      style: TextStyle(
                                                        color:
                                                            AppTheme.greyColor,
                                                      )),
                                                  Text(
                                                    "৳${data.charge?.sellingPrice ?? ""}",
                                                    style: TextStyle(
                                                        color:
                                                            AppTheme.greyColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                        data.charge?.profit == null
                                            ? const SizedBox()
                                            : Row(
                                                children: [
                                                  Text(
                                                      "${StringResources.profitText} ",
                                                      style: TextStyle(
                                                        color:
                                                            AppTheme.greyColor,
                                                      )),
                                                  Text(
                                                    "৳${data.charge?.profit ?? ""}",
                                                    style: TextStyle(
                                                        color:
                                                            AppTheme.greyColor,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                        ),
                        data.stock == 0
                            ? const SizedBox()
                            : BlocBuilder<CounterBloc, int>(
                                builder: (context, count) {
                                  return Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: index == counterVm.index
                                        ? Center(
                                            child: Container(
                                              width: width * .4,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: AppTheme.lightPinkColor,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (counterVm
                                                                .cartValue ==
                                                            1) {
                                                          counterVm
                                                              .add(CartReset());
                                                        }
                                                        counterVm.add(
                                                            CounterDecrementPressed());
                                                      },
                                                      child: Container(
                                                        height: 28,
                                                        width: 28,
                                                        decoration: BoxDecoration(
                                                            color: AppTheme
                                                                .babyPinkColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        child: const Center(
                                                            child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${counterVm.cartValue} ${StringResources.pieceText}",
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .secondaryPinkColor),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (counterVm
                                                                .cartValue <
                                                            (vm
                                                                    .productsList![
                                                                        index]
                                                                    .maximumOrder ??
                                                                0)) {
                                                          counterVm.add(
                                                              CounterIncrementPressed());
                                                        } else {
                                                          BotToast.showText(
                                                              text:
                                                                  "${StringResources.maxOrderText} ${vm.productsList![index].maximumOrder} ${StringResources.pieceText}");
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 28,
                                                        width: 28,
                                                        decoration: BoxDecoration(
                                                            color: AppTheme
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        child: const Center(
                                                            child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              if (counterVm.cartValue !=
                                                  index) {
                                                counterVm.cartValue = 0;
                                              }
                                              counterVm.add(
                                                  CounterIncrementPressed());
                                              counterVm
                                                  .add(CartIndex(index: index));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppTheme.primaryColor,
                                                radius: 20,
                                                child: const ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                          ),
                                  );
                                },
                              ),
                      ],
                    );
                  }),
            );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            children: [
              spaceBetween,
              spaceBetween,
              CommonTextField(
                hintText: StringResources.searchText,
                controller: vm.searchController,
                fillColor: Colors.white,
                isFilled: true,
                onFieldSubmitted: (v) {
                  counterVm.cartValue = 0;
                  counterVm.add(CartReset());
                  Future.delayed(Duration.zero, () async {
                    offset = 0;
                    ProductsViewModel.read(context).add(GetProductsList(
                        searchValue: vm.searchController.text.isEmpty
                            ? ""
                            : vm.searchController.text,
                        offset: offset));
                  });
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
