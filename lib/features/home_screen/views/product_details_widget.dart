import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_qtec/features/home_screen/models/product_list_model.dart';
import 'package:ecommerce_qtec/main_app/resource/string_resources.dart';
import 'package:ecommerce_qtec/main_app/views/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../main_app/resource/colors.dart';
import '../view_model/counter_bloc.dart';
import '../view_model/home_view_model.dart';

class ProductDetailsWidget extends StatefulWidget {
  final Result? product;
  final int? index;
  final int? cartValue;
  const ProductDetailsWidget(
      {Key? key, this.product, this.index, this.cartValue})
      : super(key: key);

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    var counterVm = CounterBloc.watch(context);
    var spaceBetween = const SizedBox(
      height: 10,
    );
    var spaceAround = const SizedBox(
      width: 5,
    );
    var appBar = Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
      child: Row(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(StringResources.productDetailsText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
    var searchBox = CommonTextField(
      // readOnly: true,
      isFilled: true,
      margin: EdgeInsets.all(8),
      hintText: StringResources.searchProductText,
      fillColor: Colors.white,
      onFieldSubmitted: (v) {
        counterVm.cartValue = 0;
        counterVm.add(CartReset());
        Navigator.pop(context);
        ProductsViewModel.read(context).add(GetProductsList(searchValue: v));
      },
    );
    var productDetails = widget.product;
    var slider = CarouselSlider.builder(
      itemCount: widget.product?.images?.length,
      itemBuilder: (BuildContext context, int a, int i) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Container(
              width: 1000,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        productDetails?.images![a].image ?? ""),
                    fit: BoxFit.fitHeight),
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 180,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        disableCenter: false,
      ),
    );
    var productName = Text(productDetails?.productName ?? "",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
    var brandDetails = Row(
      children: [
        Text("${StringResources.brandText} ",
            style: TextStyle(fontSize: 16, color: AppTheme.greyColor)),
        spaceAround,
        SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: Text(productDetails?.brand?.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        spaceAround,
        spaceAround,
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              color: AppTheme.secondaryPinkColor,
              borderRadius: BorderRadius.circular(50)),
        ),
        spaceAround,
        Text("${StringResources.distributorText} ",
            style: TextStyle(fontSize: 16, color: AppTheme.greyColor)),
        Text(productDetails?.seller ?? StringResources.qtecrText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
    var cartNumber = widget.index != counterVm.index
        ? const SizedBox()
        : Positioned(
            bottom: 50,
            left: 75,
            right: 0,
            child: Center(
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: AppTheme.babyPinkColor,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(50)),
                child: Center(
                  child: Text(
                    counterVm.cartValue.toString(),
                    style: TextStyle(
                        color: AppTheme.secondaryPinkColor, fontSize: 13),
                  ),
                ),
              ),
            ),
          );
    var cartPolygon = productDetails?.stock == 0
        ? const SizedBox()
        : Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (widget.index != counterVm.index) {
                  counterVm.add(CartIndex(index: widget.index!));
                  counterVm.cartValue = 0;
                  counterVm.add(CounterIncrementPressed());
                }
              },
              child: Container(
                  height: 90,
                  width: 90,
                  // alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      // color: Colors.red,
                      image: DecorationImage(
                          image: AssetImage("assets/polygon.png"))),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.index == counterVm.index
                            ? const Icon(
                                Icons.add_shopping_cart_sharp,
                                color: Colors.white,
                              )
                            : Text(
                                StringResources.thisText,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                        SizedBox(
                          height: widget.index == counterVm.index ? 5 : 0,
                        ),
                        Text(
                          widget.index == counterVm.index
                              ? StringResources.cartText
                              : StringResources.boughtText,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  )),
            ),
          );
    var width = MediaQuery.of(context).size.width;
    var buyPrice = widget.index != counterVm.index
        ? productDetails?.charge?.currentCharge
        : ((productDetails?.charge?.currentCharge ?? 0) * counterVm.cartValue);
    var sellPrice = widget.index != counterVm.index
        ? productDetails?.charge?.sellingPrice
        : ((productDetails?.charge?.sellingPrice ?? 0) * counterVm.cartValue);
    var totalProfit = widget.index != counterVm.index
        ? productDetails?.charge?.profit
        : ((productDetails?.charge?.profit ?? 0) * counterVm.cartValue);
    var buyRate = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(StringResources.buyRateText,
            style: TextStyle(
                fontSize: 20,
                color: AppTheme.secondaryPinkColor,
                fontWeight: FontWeight.w600)),
        Text("৳ $buyPrice",
            style: TextStyle(
                fontSize: 20,
                color: AppTheme.secondaryPinkColor,
                fontWeight: FontWeight.w600)),
      ],
    );
    var sellRate = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(StringResources.sellRateText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        widget.index != counterVm.index
            ? const SizedBox()
            : Center(
                child: Container(
                  width: width * .4,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppTheme.lightPinkColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (counterVm.cartValue == 1) {
                              counterVm.add(CartReset());
                            }
                            counterVm.add(CounterDecrementPressed());
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                                color: AppTheme.babyPinkColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Center(
                                child: Icon(Icons.remove, color: Colors.white)),
                          ),
                        ),
                        Text(
                          "${counterVm.cartValue} ${StringResources.pieceText}",
                          style: TextStyle(color: AppTheme.secondaryPinkColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (counterVm.cartValue <
                                (productDetails?.maximumOrder ?? 0)) {
                              counterVm.add(CounterIncrementPressed());
                            } else {
                              BotToast.showText(
                                  text:
                                      "${StringResources.maxOrderText} ${productDetails?.maximumOrder} ${StringResources.pieceText}");
                            }
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(50)),
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
              ),
        Text("৳ $sellPrice",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
    var divider = Row(
      children: List.generate(
          150 ~/ 4,
          (index) => Expanded(
                child: Container(
                  color: index % 2 != 0 ? Colors.transparent : Colors.grey,
                  height: 1,
                ),
              )),
    );
    var profit = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("লাভঃ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Text("৳ $totalProfit",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
    var detailsTitleText = Positioned(
      bottom: 15,
      left: 0,
      right: 0,
      child: Text(StringResources.detailText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
    var priceBox = SizedBox(
      height: widget.index != counterVm.index ? 200 : 210,
      child: Stack(
        children: [
          SizedBox(
            height: widget.index != counterVm.index ? 140 : 150,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buyRate,
                        spaceBetween,
                        sellRate,
                        spaceBetween,
                      ],
                    ),
                  ),
                  divider,
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        spaceBetween,
                        profit,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          cartPolygon,
          cartNumber,
          detailsTitleText,
        ],
      ),
    );
    var description = Html(
      data: productDetails?.description,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar,
              spaceBetween,
              spaceBetween,
              searchBox,
              spaceBetween,
              slider,
              spaceBetween,
              spaceBetween,
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productName,
                    spaceBetween,
                    brandDetails,
                    spaceBetween,
                    priceBox,
                    spaceBetween,
                    description,
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
