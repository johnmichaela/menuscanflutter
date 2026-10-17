// To parse this JSON data, do
//
//     final resturants = resturantsFromJson(jsonString);

import 'dart:convert';

// --- Helper for safe double parsing ---
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

// --- Helper for safe int parsing (handles String like "1") ---
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

Resturants resturantsFromJson(String str) =>
    Resturants.fromJson(json.decode(str));

String resturantsToJson(Resturants data) => json.encode(data.toJson());

// ============================================================
//  ROOT
// ============================================================
class Resturants {
  final String? status;
  final String? message;
  final Data? data;

  Resturants({this.status, this.message, this.data});

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

// ============================================================
//  DATA
// ============================================================
class Data {
  final List<Result>? results;
  final Pagination? pagination;
  final Filters? filters;

  Data({this.results, this.pagination, this.filters});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        filters:
            json["filters"] == null ? null : Filters.fromJson(json["filters"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
        "filters": filters?.toJson(),
      };
}

// ============================================================
//  FILTERS
// ============================================================
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
        minReviews: _parseInt(json["min_reviews"]),
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

// ============================================================
//  PAGINATION
// ============================================================
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
        currentPage: _parseInt(json["current_page"]),
        totalPages: _parseInt(json["total_pages"]),
        totalCount: _parseInt(json["total_count"]),
        pageSize: _parseInt(json["page_size"]),
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

// ============================================================
//  RESULT (Restaurant / Profile)
// ============================================================
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

  /// ✅ NEW: list of events organized by this profile's user
  final List<EventOrganizer>? organizer;

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
    this.organizer,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: _parseInt(json["id"]),
        name: json["name"],
        place: json["place"],
        bio: json["bio"],
        picture: json["picture"],
        banner: json["banner"],
        foods: json["foods"] == null
            ? []
            : List<Food>.from(json["foods"]!.map((x) => Food.fromJson(x))),
        rating: _parseDouble(json["rating"]),
        reviews: _parseInt(json["reviews"]),
        isOpen: json["is_open"],
        distance: json["distance"],
        averageRating: _parseDouble(json["average_rating"]),
        totalReviews: _parseInt(json["total_reviews"]),
        slug: json["slug"],
        latitude: _parseDouble(json["latitude"]),
        longitude: _parseDouble(json["longitude"]),
        typeBusiness: json["type_business"] == null
            ? null
            : TypeBusiness.fromJson(json["type_business"]),

        // ✅ NEW: parse organizer list
        organizer: json["organizer"] == null
            ? []
            : List<EventOrganizer>.from(
                json["organizer"]!.map((x) => EventOrganizer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "place": place,
        "bio": bio,
        "picture": picture,
        "banner": banner,
        "foods": foods == null
            ? []
            : List<dynamic>.from(foods!.map((x) => x.toJson())),
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
        "organizer": organizer == null
            ? []
            : List<dynamic>.from(organizer!.map((x) => x.toJson())),
      };
}

// ============================================================
//  EVENT ORGANIZER  (the nested "organizer" objects)
// ============================================================
class EventOrganizer {
  final int? id;
  final String? title;
  final String? description;
  final int? category;
  final EventCategoryDetails? categoryDetails;
  final int? venue;
  final VenueDetails? venueDetails;
  final int? organizer;
  final OrganizerDetails? organizerDetails;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? attendanceType;
  final String? status;
  final int? maxAttendees;
  final DateTime? registrationDeadline;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isFull;
  final bool? canAttend;
  final List<EventSession>? sessions;

  EventOrganizer({
    this.id,
    this.title,
    this.description,
    this.category,
    this.categoryDetails,
    this.venue,
    this.venueDetails,
    this.organizer,
    this.organizerDetails,
    this.startTime,
    this.endTime,
    this.attendanceType,
    this.status,
    this.maxAttendees,
    this.registrationDeadline,
    this.createdAt,
    this.updatedAt,
    this.isFull,
    this.canAttend,
    this.sessions,
  });

  factory EventOrganizer.fromJson(Map<String, dynamic> json) => EventOrganizer(
        id: _parseInt(json["id"]),
        title: json["title"],
        description: json["description"],
        category: _parseInt(json["category"]),
        categoryDetails: json["category_details"] == null
            ? null
            : EventCategoryDetails.fromJson(json["category_details"]),
        venue: _parseInt(json["venue"]),
        venueDetails: json["venue_details"] == null
            ? null
            : VenueDetails.fromJson(json["venue_details"]),
        organizer: _parseInt(json["organizer"]),
        organizerDetails: json["organizer_details"] == null
            ? null
            : OrganizerDetails.fromJson(json["organizer_details"]),
        startTime: json["start_time"] == null
            ? null
            : DateTime.tryParse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.tryParse(json["end_time"]),
        attendanceType: json["attendance_type"],
        status: json["status"],
        maxAttendees: _parseInt(json["max_attendees"]),
        registrationDeadline: json["registration_deadline"] == null
            ? null
            : DateTime.tryParse(json["registration_deadline"]),
        createdAt:
            json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
        updatedAt:
            json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"]),
        isFull: json["is_full"],
        canAttend: json["can_attend"],
        sessions: json["sessions"] == null
            ? []
            : List<EventSession>.from(
                json["sessions"]!.map((x) => EventSession.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "category": category,
        "category_details": categoryDetails?.toJson(),
        "venue": venue,
        "venue_details": venueDetails?.toJson(),
        "organizer": organizer,
        "organizer_details": organizerDetails?.toJson(),
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "attendance_type": attendanceType,
        "status": status,
        "max_attendees": maxAttendees,
        "registration_deadline": registrationDeadline?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_full": isFull,
        "can_attend": canAttend,
        "sessions": sessions == null
            ? []
            : List<dynamic>.from(sessions!.map((x) => x.toJson())),
      };
}

// ============================================================
//  EVENT CATEGORY DETAILS
// ============================================================
class EventCategoryDetails {
  final int? id;
  final String? name;
  final String? description;

  EventCategoryDetails({this.id, this.name, this.description});

  factory EventCategoryDetails.fromJson(Map<String, dynamic> json) =>
      EventCategoryDetails(
        id: _parseInt(json["id"]),
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}

// ============================================================
//  VENUE DETAILS
// ============================================================
class VenueDetails {
  final int? id;
  final String? name;
  final String? address;
  final int? capacity;

  VenueDetails({this.id, this.name, this.address, this.capacity});

  factory VenueDetails.fromJson(Map<String, dynamic> json) => VenueDetails(
        id: _parseInt(json["id"]),
        name: json["name"],
        address: json["address"],
        capacity: _parseInt(json["capacity"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "capacity": capacity,
      };
}

// ============================================================
//  ORGANIZER DETAILS  (the user who created the event)
// ============================================================
class OrganizerDetails {
  final int? id;
  final String? username;
  final String? email;
  final String? fullName;

  OrganizerDetails({this.id, this.username, this.email, this.fullName});

  factory OrganizerDetails.fromJson(Map<String, dynamic> json) =>
      OrganizerDetails(
        id: _parseInt(json["id"]),
        username: json["username"],
        email: json["email"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "full_name": fullName,
      };
}

// ============================================================
//  EVENT SESSION
// ============================================================
class EventSession {
  final int? id;
  final int? event;
  final String? title;
  final String? description;
  final String? speaker;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;

  EventSession({
    this.id,
    this.event,
    this.title,
    this.description,
    this.speaker,
    this.location,
    this.startTime,
    this.endTime,
  });

  factory EventSession.fromJson(Map<String, dynamic> json) => EventSession(
        id: _parseInt(json["id"]),
        event: _parseInt(json["event"]),
        title: json["title"],
        description: json["description"],
        speaker: json["speaker"],
        location: json["location"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.tryParse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.tryParse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event": event,
        "title": title,
        "description": description,
        "speaker": speaker,
        "location": location,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
      };
}

// ============================================================
//  FOOD
// ============================================================
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
        id: _parseInt(json["id"]),
        name: json["name"],
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
        description: json["description"],
        image: json["image"],
        price: _parseDouble(json["price"]),
        currency: json["currency"],
        discountPrice: _parseDouble(json["discount_price"]),
        isAvailable: json["is_available"],
        isVeg: json["is_veg"],
        rating: _parseDouble(json["rating"]),
        ratingCount: _parseInt(json["rating_count"]),
        variants: json["variants"] == null
            ? []
            : List<dynamic>.from(json["variants"]!.map((x) => x)),
        extras: json["extras"] == null
            ? []
            : List<dynamic>.from(json["extras"]!.map((x) => x)),
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
        "variants":
            variants == null ? [] : List<dynamic>.from(variants!.map((x) => x)),
        "extras":
            extras == null ? [] : List<dynamic>.from(extras!.map((x) => x)),
      };
}

// ============================================================
//  TYPE BUSINESS
// ============================================================
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
        id: _parseInt(json["id"]),
        name: json["name"],
        description: json["description"],
        color: json["color"],
        textColor: json["text_color"],
        icon: json["icon"],
        timestamp:
            json["timestamp"] == null ? null : DateTime.tryParse(json["timestamp"]),
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

// ============================================================
//  FOOD CATEGORY
// ============================================================
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
      id: _parseInt(json['id']) ?? 0,
      name: json['name'] ?? '',
      sortOrder: _parseInt(json['sort_order']) ?? 0,
      createdAt: json['created_at'] ?? '',
      profile: _parseInt(json['profile']) ?? 0,
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