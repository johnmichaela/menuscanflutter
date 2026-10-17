// To parse this JSON data, do
//
//     final resturants = resturantsFromJson(jsonString);

import 'dart:convert';

double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
}
Resturants resturantsFromJson(String str) => Resturants.fromJson(json.decode(str));

String resturantsToJson(Resturants data) => json.encode(data.toJson());

class Resturants {
    final String? status;
    final String? message;
    final Data? data;

    Resturants({
        this.status,
        this.message,
        this.data,
    });

    factory Resturants.fromJson(Map<String, dynamic> json) => Resturants(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final List<Result>? results;
    final Pagination? pagination;
    final Filters? filters;

    Data({
        this.results,
        this.pagination,
        this.filters,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
        filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
    );

    Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
        "filters": filters?.toJson(),
    };
}

class Filters {
    final dynamic search;
    final double? minRating;
    final int? minReviews;
    final dynamic isOpen;
    final String? sortBy;

    Filters({
        this.search,
        this.minRating,
        this.minReviews,
        this.isOpen,
        this.sortBy,
    });

    factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        search: json["search"],
        minRating: _parseDouble(json["min_rating"]),  
        minReviews: json["min_reviews"],
        isOpen: json["is_open"],
        sortBy: json["sort_by"],
    );

    Map<String, dynamic> toJson() => {
        "search": search,
        "min_rating": minRating,
        "min_reviews": minReviews,
        "is_open": isOpen,
        "sort_by": sortBy,
    };
}

class Pagination {
    final int? currentPage;
    final int? totalPages;
    final int? totalCount;
    final int? pageSize;
    final bool? hasNext;
    final bool? hasPrevious;

    Pagination({
        this.currentPage,
        this.totalPages,
        this.totalCount,
        this.pageSize,
        this.hasNext,
        this.hasPrevious,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
        totalCount: json["total_count"],
        pageSize: json["page_size"],
        hasNext: json["has_next"],
        hasPrevious: json["has_previous"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total_pages": totalPages,
        "total_count": totalCount,
        "page_size": pageSize,
        "has_next": hasNext,
        "has_previous": hasPrevious,
    };
}

class Result {
    final int? id;
    final String? name;
    final String? place;
    final String? bio;
    final String? picture;
    final String? banner;
    final List<Food>? foods;
    final double? rating;
    final int? reviews;
    final bool? isOpen;
    final dynamic distance;
    final double? averageRating;
    final int? totalReviews;
    final String? slug;
    final double? latitude;
    final double? longitude;
    final TypeBusiness? typeBusiness;

    Result({
        this.id,
        this.name,
        this.place,
        this.bio,
        this.picture,
        this.banner,
        this.foods,
        this.rating,
        this.reviews,
        this.isOpen,
        this.distance,
        this.averageRating,
        this.totalReviews,
        this.slug,
        this.latitude,
        this.longitude,
        this.typeBusiness,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        place: json["place"],
        bio: json["bio"],
        picture: json["picture"],
        banner: json["banner"],
        foods: json["foods"] == null ? [] : List<Food>.from(json["foods"]!.map((x) => Food.fromJson(x))),
        rating: _parseDouble(json["rating"]), 
        reviews: json["reviews"],
        isOpen: json["is_open"],
        distance: json["distance"],
        averageRating: _parseDouble(json["average_rating"]),  
        totalReviews: json["total_reviews"],
        slug: json["slug"],
        latitude: _parseDouble(json["latitude"]),
        longitude: _parseDouble(json["longitude"]),
        typeBusiness: json["type_business"] == null ? null : TypeBusiness.fromJson(json["type_business"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "place": place,
        "bio": bio,
        "picture": picture,
        "banner": banner,
        "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
        "rating": rating,
        "reviews": reviews,
        "is_open": isOpen,
        "distance": distance,
        "average_rating": averageRating,
        "total_reviews": totalReviews,
        "slug": slug,
        "latitude": latitude,
        "longitude": longitude,
        "type_business": typeBusiness?.toJson(),
    };
}

class Food {
    final int? id;
    final String? name;
    final String? description;
    final String? image;
    final double? price;
    final String? currency;
    final double? discountPrice;
    final bool? isAvailable;
    final bool? isVeg;
    final double? rating;
    final int? ratingCount;
    final List<dynamic>? variants;
    final List<dynamic>? extras;
    final Category? category;

    Food({
        this.id,
        this.name,
        this.category,
        this.description,
        this.image,
        this.price,
        this.currency,
        this.discountPrice,
        this.isAvailable,
        this.isVeg,
        this.rating,
        this.ratingCount,
        this.variants,
        this.extras,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"],
        name: json["name"],
         category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
        description: json["description"],
        image: json["image"],
         price: _parseDouble(json["price"]),           // ✅ Parse String to double
        currency: json["currency"],
        discountPrice: _parseDouble(json["discount_price"]),  // ✅ Parse String to double
        isAvailable: json["is_available"],
        isVeg: json["is_veg"],
        rating: _parseDouble(json["rating"]),         // ✅ Parse String to double
        
        ratingCount: json["rating_count"],
        variants: json["variants"] == null ? [] : List<dynamic>.from(json["variants"]!.map((x) => x)),
        extras: json["extras"] == null ? [] : List<dynamic>.from(json["extras"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "currency": currency,
        "discount_price": discountPrice,
        "is_available": isAvailable,
        "is_veg": isVeg,
        "rating": rating,
        "rating_count": ratingCount,
        "variants": variants == null ? [] : List<dynamic>.from(variants!.map((x) => x)),
        "extras": extras == null ? [] : List<dynamic>.from(extras!.map((x) => x)),
    };
}

class TypeBusiness {
    final int? id;
    final String? name;
    final String? description;
    final String? color;
    final String? textColor;
    final String? icon;
    final DateTime? timestamp;

    TypeBusiness({
        this.id,
        this.name,
        this.description,
        this.color,
        this.textColor,
        this.icon,
        this.timestamp,
    });

    factory TypeBusiness.fromJson(Map<String, dynamic> json) => TypeBusiness(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        color: json["color"],
        textColor: json["text_color"],
        icon: json["icon"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "color": color,
        "text_color": textColor,
        "icon": icon,
        "timestamp": timestamp?.toIso8601String(),
    };
}

class Category {
  final int id;
  final String name;
  final int sortOrder;
  final String createdAt;
  final int profile;

  Category({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
    required this.profile,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
      createdAt: json['created_at'] ?? '',
      profile: json['profile'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'profile': profile,
    };
  }
}
