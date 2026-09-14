import 'dart:convert';

import 'package:ballon/models/resturants.dart';

class Restaurant {
  final int id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String country;
  final String logo;
  final String banner;
  final double? latitude;
  final double? longitude;
  final String phone;
  final double rating;
  final int ratingCount;
  final bool isOpen;
  final bool hasDelivery;
  final bool hasPickup;
  final bool hasDineIn;
  final String slug;
  final String category;
  final List<MenuCategoryModel> categories;
  final List<FoodItemModel> foods;
  final TableModel? table;

  Restaurant({
    required this.id,
    required this.name,
    this.description = '',
    this.address = '',
    this.city = '',
    this.country = '',
    this.logo = '',
    this.banner = '',
    this.latitude,
    this.longitude,
    this.phone = '',
    this.rating = 0,
    this.ratingCount = 0,
    this.isOpen = true,
    this.hasDelivery = true,
    this.hasPickup = true,
    this.hasDineIn = true,
    required this.slug,
    this.category = '',
    this.categories = const [],
    this.foods = const [],
    this.table,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      logo: json['logo'] ?? '',
      banner: json['banner'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse('${json['latitude']}') : null,
      longitude: json['longitude'] != null ? double.tryParse('${json['longitude']}') : null,
      phone: json['phone'] ?? '',
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
      ratingCount: json['rating_count'] ?? 0,
      isOpen: json['is_open'] ?? true,
      hasDelivery: json['has_delivery'] ?? true,
      hasPickup: json['has_pickup'] ?? true,
      hasDineIn: json['has_dine_in'] ?? true,
      slug: json['slug'] ?? '',
      category: json['category'] ?? '',
      categories: (json['categories'] as List? ?? [])
          .map((e) => MenuCategoryModel.fromJson(e))
          .toList(),
      foods: (json['foods'] as List? ?? [])
          .map((e) => FoodItemModel.fromJson(e))
          .toList(),
      table: json['table'] != null ? TableModel.fromJson(json['table']) : null,
    );
  }
}

class MenuCategoryModel {
  final int id;
  final String name;

  MenuCategoryModel({required this.id, required this.name});

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class FoodItemModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double? discountPrice;
  final String ingredients;
  final String nutrition;
  final int spiceLevel;
  final bool isAvailable;
  final bool isVeg;
  final int stock;
  final double rating;
  final String category;
  final List<VariantModel> variants;
  final List<ExtraModel> extras;

  FoodItemModel({
    required this.id,
    required this.name,
    this.description = '',
    this.image = '',
    required this.price,
    this.discountPrice,
    this.ingredients = '',
    this.nutrition = '',
    this.spiceLevel = 0,
    this.isAvailable = true,
    this.isVeg = false,
    this.stock = 0,
    this.rating = 0,
    this.category = '',
    this.variants = const [],
    this.extras = const [],
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: double.tryParse('${json['price'] ?? 0}') ?? 0,
      discountPrice: json['discount_price'] != null
          ? double.tryParse('${json['discount_price']}')
          : null,
      ingredients: json['ingredients'] ?? '',
      nutrition: json['nutrition'] ?? '',
      spiceLevel: json['spice_level'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      isVeg: json['is_veg'] ?? false,
      stock: json['stock'] ?? 0,
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
      variants: (json['variants'] as List? ?? [])
          .map((e) => VariantModel.fromJson(e))
          .toList(),
      extras: (json['extras'] as List? ?? [])
          .map((e) => ExtraModel.fromJson(e))
          .toList(),
    );
  }
}

class VariantModel {
  final int id;
  final String name;
  final double priceDelta;

  VariantModel({required this.id, required this.name, required this.priceDelta});

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      priceDelta: double.tryParse('${json['price_delta'] ?? 0}') ?? 0,
    );
  }
}

class ExtraModel {
  final int id;
  final String name;
  final double price;

  ExtraModel({required this.id, required this.name, required this.price});

  factory ExtraModel.fromJson(Map<String, dynamic> json) {
    return ExtraModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse('${json['price'] ?? 0}') ?? 0,
    );
  }
}

class TableModel {
  final int id;
  final String name;
  final int capacity;

  TableModel({required this.id, required this.name, required this.capacity});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 4,
    );
  }
}

class CartItem {
  final Food food;
  int quantity;
  String? variant;
  List<String> extras;

  CartItem({required this.food, this.quantity = 1, this.variant, this.extras = const []});

  double get unitPrice {
    double p = food.price! as double;
    if (food.discountPrice != null) p = food.discountPrice!;
    return p;
  }

  double get total => unitPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'food': jsonEncode({
        'id': food.id,
        'name': food.name,
        'price': food.price,
        'image': food.image,
      }),
      'quantity': quantity,
      'variant': variant,
      'extras': extras,
    };
  }
}

class Offer {
  final int id;
  final String title;
  final String description;
  final String code;
  final double discount;
  final int restaurantId;
  final String restaurantName;
  final double radiusKm;
  final String? image;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discount,
    required this.restaurantId,
    required this.restaurantName,
    required this.radiusKm,
    this.image,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      discount: double.tryParse('${json['discount'] ?? 0}') ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
      restaurantName: json['restaurant_name'] ?? '',
      radiusKm: double.tryParse('${json['radius_km'] ?? 5}') ?? 5,
      image: json['image'],
    );
  }
}

class OrderStatus {
  final String status;
  final String time;
  final bool isCompleted;

  OrderStatus({required this.status, required this.time, required this.isCompleted});
}

class EventCommentModel {
  final int id;
  final String author;
  final String authorName;
  final String authorPicture;
  final String text;
  final String createdAt;

  EventCommentModel({
    required this.id,
    this.author = '',
    this.authorName = '',
    this.authorPicture = '',
    this.text = '',
    this.createdAt = '',
  });

  factory EventCommentModel.fromJson(Map<String, dynamic> json) {
    return EventCommentModel(
      id: json['id'] ?? 0,
      author: json['author'] ?? '',
      authorName: json['author_name'] ?? '',
      authorPicture: json['author_picture'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class EventModel {
  final int id;
  final String title;
  final String description;
  final String location;
  final String? date;
  final String time;
  final String image;
  final String category;
  final int attendees;
  final bool isFeatured;
    final OrganizerModel organizer;
  final int commentCount;
  final int likeCount;
  final int shareCount;
  final int attendeeCount;
  final bool isLiked;
  final bool isAttending;
  final List<EventCommentModel> comments;

  EventModel({
    required this.id,
    required this.title,
    this.description = '',
    this.location = '',
    this.date,
    this.time = '',
    this.image = '',
    this.category = '',
    this.attendees = 0,
    this.isFeatured = false,
    required this.organizer,
    this.commentCount = 0,
    this.likeCount = 0,
    this.shareCount = 0,
    this.attendeeCount = 0,
    this.isLiked = false,
    this.isAttending = false,
    this.comments = const [],
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: json['date'],
      time: json['time'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      attendees: json['attendees'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      organizer: json['organizer'] != null
          ? OrganizerModel.fromJson(json['organizer'] as Map<String, dynamic>)
          : OrganizerModel(
              pk: 0,
              user: 0,
              name: json['organizer_name'] ?? 'Unknown',
              activity: '',
              place: '',
              picture: '',
              phoneNumber: 0,
              email: '',
              bio: '',
              birthday: null,
            ),
      commentCount: json['comment_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      attendeeCount: json['attendee_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isAttending: json['is_attending'] ?? false,
      comments: (json['comments'] as List? ?? [])
          .map((e) => EventCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': date,
      'time': time,
      'image': image,
      'category': category,
    };
  }

  EventModel copyWith({
    int? commentCount,
    int? likeCount,
    int? shareCount,
    int? attendeeCount,
    bool? isLiked,
    bool? isAttending,
    List<EventCommentModel>? comments,
  }) {
    return EventModel(
      id: id,
      title: title,
      description: description,
      location: location,
      date: date,
      time: time,
      image: image,
      category: category,
      attendees: attendees,
      isFeatured: isFeatured,
      organizer: organizer,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      shareCount: shareCount ?? this.shareCount,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      isLiked: isLiked ?? this.isLiked,
      isAttending: isAttending ?? this.isAttending,
      comments: comments ?? this.comments,
    );
  }

  /// Day-of-month string for the event card (e.g. "24").
  String get dateDay {
    if (date == null || date!.isEmpty) return '--';
    final parts = date!.split('-');
    if (parts.length >= 3) return parts[2];
    return '--';
  }

  /// Month abbreviation for the event card (e.g. "MAY").
  String get dateMonth {
    if (date == null || date!.isEmpty) return '';
    final parts = date!.split('-');
    if (parts.length >= 2) {
      const months = ['', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
      final m = int.tryParse(parts[1]) ?? 0;
      if (m >= 1 && m <= 12) return months[m];
    }
    return '';
  }
}
class OrganizerModel {
  final int pk;
  final int user;
  final String name;
  final String activity;
  final String place;
  final String picture;
  final int phoneNumber;
  final String email;
  final String bio;
  final DateTime? birthday;

  OrganizerModel({
    required this.pk,
    required this.user,
    required this.name,
    required this.activity,
    required this.place,
    required this.picture,
    required this.phoneNumber,
    required this.email,
    required this.bio,
    this.birthday,
  });

  factory OrganizerModel.fromJson(Map<String, dynamic> json) {
    return OrganizerModel(
      pk: json['pk'] ?? 0,
      user: json['user'] ?? 0,
      name: json['name'] ?? '',
      activity: json['activity'] ?? '',
      place: json['place'] ?? '',
      picture: json['picture'] ?? '',
      phoneNumber: json['phone_number'] ?? 0,
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday']) : null,
    );
  }
}