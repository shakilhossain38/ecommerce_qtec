import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_qtec/features/home_screen/models/product_list_model.dart';
import 'package:ecommerce_qtec/main_app/views/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../main_app/resource/colors.dart';
import '../view_model/home_view_model.dart';

class ProductDetailsWidget extends StatefulWidget {
  final Result? product;
  const ProductDetailsWidget({Key? key, this.product}) : super(key: key);

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
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
              const Text("প্রোডাক্ট ডিটেইল",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
    var searchBox = CommonTextField(
      // readOnly: true,
      isFilled: true,
      margin: EdgeInsets.all(8),
      hintText: "কাঙ্ক্ষিত পণ্যটি খুঁজুন",
      fillColor: Colors.white,
      onFieldSubmitted: (v) {
        Navigator.pop(context);
        ProductsViewModel.read(context).add(GetProductsList(searchValue: v));
      },
      // onTap: () {
      //
      // },
    );
    var productDetails = widget.product;
    var slider = CarouselSlider.builder(
      itemCount: widget.product?.images?.length,
      itemBuilder: (BuildContext context, int a, int i) {
        return Container(
          margin: EdgeInsets.all(5.0),
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
        //onPageChanged: onPageChange,
        //autoPlay: true,
      ),
      //carouselController: _controller,
    );
    var productName = Text(productDetails?.productName ?? "",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
    var brandDetails = Row(
      children: [
        Text("ব্রান্ডঃ ",
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
        Text("ডিস্ট্রিবিউটরঃ ",
            style: TextStyle(fontSize: 16, color: AppTheme.greyColor)),
        Text(
            productDetails?.model == "" || productDetails?.model == null
                ? "QTec"
                : productDetails?.model ?? "",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
    var cartPolygon = productDetails?.stock == 0
        ? const SizedBox()
        : Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
                    children: const [
                      Text(
                        "এটি",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "কিনুন",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                )),
          );
    var buyRate = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("ক্রয়মূল্যঃ",
            style: TextStyle(
                fontSize: 20,
                color: AppTheme.secondaryPinkColor,
                fontWeight: FontWeight.w600)),
        Text("৳ ${productDetails?.charge?.currentCharge.toString() ?? ""}",
            style: TextStyle(
                fontSize: 20,
                color: AppTheme.secondaryPinkColor,
                fontWeight: FontWeight.w600)),
      ],
    );
    var sellRate = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("বিক্রয়মূল্যঃ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Text("৳ ${productDetails?.charge?.sellingPrice.toString() ?? ""}",
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
        Text("৳ ${productDetails?.charge?.profit.toString() ?? ""}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
    var detailsTitleText = const Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Text("বিস্তারিত",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
    var priceBox = SizedBox(
      height: 200,
      child: Stack(
        children: [
          SizedBox(
            height: 140,
            child: Container(
              // height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    buyRate,
                    spaceBetween,
                    sellRate,
                    spaceBetween,
                    divider,
                    spaceBetween,
                    profit,
                  ],
                ),
              ),
            ),
          ),
          cartPolygon,
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
