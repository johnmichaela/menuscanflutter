// // To parse this JSON data, do
// //
// //     final profilebytype = profilebytypeFromJson(jsonString);

// import 'dart:convert';

// Profilebytype profilebytypeFromJson(String str) => Profilebytype.fromJson(json.decode(str));

// String profilebytypeToJson(Profilebytype data) => json.encode(data.toJson());

// class Profilebytype {
//     final String? status;
//     final String? message;
//     final Data? data;

//     Profilebytype({
//         this.status,
//         this.message,
//         this.data,
//     });

//     factory Profilebytype.fromJson(Map<String, dynamic> json) => Profilebytype(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data?.toJson(),
//     };
// }

// class Data {
//     final List<Result>? results;
//     final Pagination? pagination;
//     final Filters? filters;

//     Data({
//         this.results,
//         this.pagination,
//         this.filters,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
//         pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
//         filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
//         "pagination": pagination?.toJson(),
//         "filters": filters?.toJson(),
//     };
// }

// class Filters {
//     final String? typeId;
//     final dynamic typeSlug;
//     final Type? typeInfo;
//     final dynamic search;
//     final int? minRating;
//     final int? minReviews;
//     final dynamic isOpen;
//     final String? sortBy;

//     Filters({
//         this.typeId,
//         this.typeSlug,
//         this.typeInfo,
//         this.search,
//         this.minRating,
//         this.minReviews,
//         this.isOpen,
//         this.sortBy,
//     });

//     factory Filters.fromJson(Map<String, dynamic> json) => Filters(
//         typeId: json["type_id"],
//         typeSlug: json["type_slug"],
//         typeInfo: json["type_info"] == null ? null : Type.fromJson(json["type_info"]),
//         search: json["search"],
//         minRating: json["min_rating"],
//         minReviews: json["min_reviews"],
//         isOpen: json["is_open"],
//         sortBy: json["sort_by"],
//     );

//     Map<String, dynamic> toJson() => {
//         "type_id": typeId,
//         "type_slug": typeSlug,
//         "type_info": typeInfo?.toJson(),
//         "search": search,
//         "min_rating": minRating,
//         "min_reviews": minReviews,
//         "is_open": isOpen,
//         "sort_by": sortBy,
//     };
// }

// class Type {
//     final int? id;
//     final String? name;
//     final String? description;
//     final DateTime? timestamp;

//     Type({
//         this.id,
//         this.name,
//         this.description,
//         this.timestamp,
//     });

//     factory Type.fromJson(Map<String, dynamic> json) => Type(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "timestamp": timestamp?.toIso8601String(),
//     };
// }

// class Pagination {
//     final int? currentPage;
//     final int? totalPages;
//     final int? totalCount;
//     final int? pageSize;
//     final bool? hasNext;
//     final bool? hasPrevious;

//     Pagination({
//         this.currentPage,
//         this.totalPages,
//         this.totalCount,
//         this.pageSize,
//         this.hasNext,
//         this.hasPrevious,
//     });

//     factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
//         currentPage: json["current_page"],
//         totalPages: json["total_pages"],
//         totalCount: json["total_count"],
//         pageSize: json["page_size"],
//         hasNext: json["has_next"],
//         hasPrevious: json["has_previous"],
//     );

//     Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "total_pages": totalPages,
//         "total_count": totalCount,
//         "page_size": pageSize,
//         "has_next": hasNext,
//         "has_previous": hasPrevious,
//     };
// }

// class Result {
//     final int? id;
//     final int? user;
//     final String? name;
//     final int? typeBusiness;
//     final String? typeBusinessName;
//     final Type? typeBusinessDetails;
//     final String? place;
//     final String? bio;
//     final String? activity;
//     final String? picture;
//     final String? rating;
//     final int? reviews;
//     final bool? isOpen;
//     final bool? isVisible;
//     final String? latitude;
//     final String? longitude;
//     final dynamic distance;
//     final String? slug;
//     final int? phoneNumber;
//     final String? email;
//     final int? views;
//     final DateTime? timestamp;

//     Result({
//         this.id,
//         this.user,
//         this.name,
//         this.typeBusiness,
//         this.typeBusinessName,
//         this.typeBusinessDetails,
//         this.place,
//         this.bio,
//         this.activity,
//         this.picture,
//         this.rating,
//         this.reviews,
//         this.isOpen,
//         this.isVisible,
//         this.latitude,
//         this.longitude,
//         this.distance,
//         this.slug,
//         this.phoneNumber,
//         this.email,
//         this.views,
//         this.timestamp,
//     });

//     factory Result.fromJson(Map<String, dynamic> json) => Result(
//         id: json["id"],
//         user: json["user"],
//         name: json["name"],
//         typeBusiness: json["type_business"],
//         typeBusinessName: json["type_business_name"],
//         typeBusinessDetails: json["type_business_details"] == null ? null : Type.fromJson(json["type_business_details"]),
//         place: json["place"],
//         bio: json["bio"],
//         activity: json["activity"],
//         picture: json["picture"],
//         rating: json["rating"],
//         reviews: json["reviews"],
//         isOpen: json["is_open"],
//         isVisible: json["is_visible"],
//         latitude: json["latitude"],
//         longitude: json["longitude"],
//         distance: json["distance"],
//         slug: json["slug"],
//         phoneNumber: json["phone_number"],
//         email: json["email"],
//         views: json["views"],
//         timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "user": user,
//         "name": name,
//         "type_business": typeBusiness,
//         "type_business_name": typeBusinessName,
//         "type_business_details": typeBusinessDetails?.toJson(),
//         "place": place,
//         "bio": bio,
//         "activity": activity,
//         "picture": picture,
//         "rating": rating,
//         "reviews": reviews,
//         "is_open": isOpen,
//         "is_visible": isVisible,
//         "latitude": latitude,
//         "longitude": longitude,
//         "distance": distance,
//         "slug": slug,
//         "phone_number": phoneNumber,
//         "email": email,
//         "views": views,
//         "timestamp": timestamp?.toIso8601String(),
//     };
// }

// To parse this JSON data, do
//
//     final profilebytype = profilebytypeFromJson(jsonString);

import 'dart:convert';
double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
}
Profilebytype profilebytypeFromJson(String str) => Profilebytype.fromJson(json.decode(str));

String profilebytypeToJson(Profilebytype data) => json.encode(data.toJson());

class Profilebytype {
    final String? status;
    final String? message;
    final Data? data;

    Profilebytype({
        this.status,
        this.message,
        this.data,
    });

    factory Profilebytype.fromJson(Map<String, dynamic> json) => Profilebytype(
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
    final String? typeId;
    final dynamic typeSlug;
    final TypeBusinessDetails? typeInfo;
    final dynamic search;
    final int? minRating;
    final int? minReviews;
    final dynamic isOpen;
    final String? sortBy;

    Filters({
        this.typeId,
        this.typeSlug,
        this.typeInfo,
        this.search,
        this.minRating,
        this.minReviews,
        this.isOpen,
        this.sortBy,
    });

    factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        typeId: json["type_id"],
        typeSlug: json["type_slug"],
        typeInfo: json["type_info"] == null ? null : TypeBusinessDetails.fromJson(json["type_info"]),
        search: json["search"],
        minRating: json["min_rating"],
        minReviews: json["min_reviews"],
        isOpen: json["is_open"],
        sortBy: json["sort_by"],
    );

    Map<String, dynamic> toJson() => {
        "type_id": typeId,
        "type_slug": typeSlug,
        "type_info": typeInfo?.toJson(),
        "search": search,
        "min_rating": minRating,
        "min_reviews": minReviews,
        "is_open": isOpen,
        "sort_by": sortBy,
    };
}

// Dedicated class for TypeBusinessDetails (used in both TypeBusinessDetails and Filter.typeInfo)
class TypeBusinessDetails {
    final int? id;
    final String? name;
    final String? color;
    final String? textColor;
    final String? icon;
    final String? description;
    final DateTime? timestamp;

    TypeBusinessDetails({
        this.id,
        this.name,
        this.color,
        this.textColor,
        this.icon,
        this.description,
        this.timestamp,
    });

    factory TypeBusinessDetails.fromJson(Map<String, dynamic> json) => TypeBusinessDetails(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        textColor: json["text_color"],
        icon: json["icon"],
        description: json["description"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "text_color": textColor,
        "icon": icon,
        "description": description,
        "timestamp": timestamp?.toIso8601String(),
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
    final int? user;
    final String? name;
    final List<Food>? food;
    final int? typeBusiness;
    final String? typeBusinessName;
    final TypeBusinessDetails? typeBusinessDetails;
    final String? place;
    final String? bio;
    final String? activity;
    final String? picture;
    final String? banner;
    final double? rating;
    final int? reviews;
    final bool? isOpen;
    final bool? isVisible;
    final String? latitude;
    final String? longitude;
    final dynamic distance;
    final String? slug;
    final int? phoneNumber;
    final String? email;
    final int? views;
    final DateTime? timestamp;

    Result({
        this.id,
        this.user,
        this.name,
        this.food,
        this.banner,
        this.typeBusiness,
        this.typeBusinessName,
        this.typeBusinessDetails,
        this.place,
        this.bio,
        this.activity,
        this.picture,
        this.rating,
        this.reviews,
        this.isOpen,
        this.isVisible,
        this.latitude,
        this.longitude,
        this.distance,
        this.slug,
        this.phoneNumber,
        this.email,
        this.views,
        this.timestamp,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        user: json["user"],
        name: json["name"],
        food: json["food"] == null ? null : List<Food>.from(json["food"].map((x) => Food.fromJson(x))),
        banner: json["banner"],
        typeBusiness: json["type_business"],
        typeBusinessName: json["type_business_name"],
        typeBusinessDetails: json["type_business_details"] == null ? null : TypeBusinessDetails.fromJson(json["type_business_details"]),
        place: json["place"],
        bio: json["bio"],
        activity: json["activity"],
        picture: json["picture"],
        rating: _parseDouble(json["rating"]), 
        reviews: json["reviews"],
        isOpen: json["is_open"],
        isVisible: json["is_visible"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"],
        slug: json["slug"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        views: json["views"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name": name,
        "food": food?.map((x) => x.toJson()).toList(),
        "banner": banner,
        "type_business": typeBusiness,
        "type_business_name": typeBusinessName,
        "type_business_details": typeBusinessDetails?.toJson(),
        "place": place,
        "bio": bio,
        "activity": activity,
        "picture": picture,
        "rating": rating,
        "reviews": reviews,
        "is_open": isOpen,
        "is_visible": isVisible,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "slug": slug,
        "phone_number": phoneNumber,
        "email": email,
        "views": views,
        "timestamp": timestamp?.toIso8601String(),
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

    Food({
        this.id,
        this.name,
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
