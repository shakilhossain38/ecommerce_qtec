// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) =>
    ProductListModel.fromJson(json.decode(str));

class ProductListModel {
  ProductListModel({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.categories,
    this.products,
  });

  List<dynamic>? categories;
  Products? products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: json["categories"] == null
            ? null
            : List<dynamic>.from(json["categories"].map((x) => x)),
        products: json["products"] == null
            ? null
            : Products.fromJson(json["products"]),
      );
}

class Products {
  Products({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  String? next;
  String? previous;
  List<Result>? results;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    this.id,
    this.brand,
    this.image,
    this.charge,
    this.images,
    this.slug,
    this.productName,
    this.model,
    this.commissionType,
    this.amount,
    this.tag,
    this.description,
    this.note,
    this.embaddedVideoLink,
    this.maximumOrder,
    this.stock,
    this.isBackOrder,
    this.specification,
    this.warranty,
    this.preOrder,
    this.productReview,
    this.isSeller,
    this.isPhone,
    this.willShowEmi,
    this.badge,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.language,
    this.seller,
    this.combo,
    this.createdBy,
    this.updatedBy,
    this.category,
    this.relatedProduct,
    this.filterValue,
  });

  int? id;
  Brand? brand;
  String? image;
  Charge? charge;
  List<ImagesList>? images;
  String? slug;
  String? productName;
  String? model;
  String? commissionType;
  String? amount;
  String? tag;
  String? description;
  String? note;
  String? embaddedVideoLink;
  int? maximumOrder;
  int? stock;
  bool? isBackOrder;
  String? specification;
  String? warranty;
  bool? preOrder;
  int? productReview;
  bool? isSeller;
  bool? isPhone;
  bool? willShowEmi;
  dynamic badge;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic language;
  String? seller;
  dynamic combo;
  String? createdBy;
  dynamic updatedBy;
  List<int>? category;
  List<dynamic>? relatedProduct;
  List<dynamic>? filterValue;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        image: json["image"],
        charge: json["charge"] == null ? null : Charge.fromJson(json["charge"]),
        images: json["images"] == null
            ? null
            : List<ImagesList>.from(json["images"].map((x) => ImagesList.fromJson(x))),
        slug: json["slug"],
        productName: json["product_name"],
        model: json["model"],
        commissionType: json["commission_type"],
        amount: json["amount"],
        tag: json["tag"],
        description: json["description"],
        note: json["note"],
        embaddedVideoLink: json["embadded_video_link"],
        maximumOrder: json["maximum_order"],
        stock: json["stock"],
        isBackOrder: json["is_back_order"],
        specification: json["specification"],
        warranty: json["warranty"],
        preOrder: json["pre_order"],
        productReview: json["product_review"],
        isSeller: json["is_seller"],
        isPhone: json["is_phone"],
        willShowEmi: json["will_show_emi"],
        badge: json["badge"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        language: json["language"],
        seller: json["seller"],
        combo: json["combo"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        category: json["category"] == null
            ? null
            : List<int>.from(json["category"].map((x) => x)),
        relatedProduct: json["related_product"] == null
            ? null
            : List<dynamic>.from(json["related_product"].map((x) => x)),
        filterValue: json["filter_value"] == null
            ? null
            : List<dynamic>.from(json["filter_value"].map((x) => x)),
      );
}

class Brand {
  Brand({
    this.name,
    this.image,
    this.headerImage,
    this.slug,
  });

  String? name;
  String? image;
  dynamic headerImage;
  String? slug;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        name: json["name"],
        image: json["image"],
        headerImage: json["header_image"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image ?? null,
        "header_image": headerImage,
        "slug": slug,
      };
}

class Charge {
  Charge({
    this.bookingPrice,
    this.currentCharge,
    this.discountCharge,
    this.sellingPrice,
    this.profit,
    this.isEvent,
    this.eventId,
    this.highlight,
    this.highlightId,
    this.groupping,
    this.grouppingId,
    this.campaignSectionId,
    this.campaignSection,
    this.message,
  });

  double? bookingPrice;
  double? currentCharge;
  dynamic discountCharge;
  double? sellingPrice;
  double? profit;
  bool? isEvent;
  dynamic eventId;
  bool? highlight;
  dynamic highlightId;
  bool? groupping;
  dynamic grouppingId;
  dynamic campaignSectionId;
  bool? campaignSection;
  dynamic message;

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
        bookingPrice: json["booking_price"],
        currentCharge: json["current_charge"],
        discountCharge: json["discount_charge"],
        sellingPrice: json["selling_price"],
        profit: json["profit"],
        isEvent: json["is_event"],
        eventId: json["event_id"],
        highlight: json["highlight"],
        highlightId: json["highlight_id"],
        groupping: json["groupping"],
        grouppingId: json["grouping_id"],
        campaignSectionId: json["campaign_section_id"],
        campaignSection: json["campaign_section"],
        message: json["message"],
      );
}

class ImagesList {
  ImagesList({
    this.id,
    this.image,
    this.isPrimary,
    this.product,
  });

  int? id;
  String? image;
  bool? isPrimary;
  int? product;

  factory ImagesList.fromJson(Map<String, dynamic> json) => ImagesList(
        id: json["id"],
        image: json["image"],
        isPrimary: json["is_primary"],
        product: json["product"],
      );
}
