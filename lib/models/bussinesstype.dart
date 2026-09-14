// To parse this JSON data, do
//
//     final bussinestype = bussinestypeFromJson(jsonString);

import 'dart:convert';

double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
}

Bussinestype bussinestypeFromJson(String str) => Bussinestype.fromJson(json.decode(str));

String bussinestypeToJson(Bussinestype data) => json.encode(data.toJson());

class Bussinestype {
    final String? status;
    final List<Datum>? data;
    final int? totalTypes;

    Bussinestype({
        this.status,
        this.data,
        this.totalTypes,
    });

    factory Bussinestype.fromJson(Map<String, dynamic> json) => Bussinestype(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        totalTypes: json["total_types"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_types": totalTypes,
    };
}

class Datum {
    final int? id;
    final String? name;
    final String? color;
    final String? icon;
    final String? textColor;
    final String? description;
    final int? profileCount;
    final double? avgRating;
    final int? totalReviews;

    Datum({
        this.id,
        this.name,
        this.color,
        this.icon,
        this.textColor,
        this.description,
        this.profileCount,
        this.avgRating,
        this.totalReviews,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        icon: json["icon"],
        textColor: json["text_color"],
        description: json["description"],
        profileCount: json["profile_count"],
        avgRating: _parseDouble(json["avg_rating"]), 
        totalReviews: json["total_reviews"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "icon": icon,
        "text_color": textColor,
        "description": description,
        "profile_count": profileCount,
        "avg_rating": avgRating,
        "total_reviews": totalReviews,
    };
}
