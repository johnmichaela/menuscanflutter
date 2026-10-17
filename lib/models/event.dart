// To parse this JSON data, do
//
//     final eventList = eventListFromJson(jsonString);

import 'dart:convert';

EventList eventListFromJson(String str) => EventList.fromJson(json.decode(str));

String eventListToJson(EventList data) => json.encode(data.toJson());

class EventList {
    final List<ResultEvent>? results;

    EventList({
        this.results,
    });

    factory EventList.fromJson(Map<String, dynamic> json) => EventList(
        results: json["results"] == null ? [] : List<ResultEvent>.from(json["results"]!.map((x) => ResultEvent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class ResultEvent {
    final int? id;
    final String? title;
    final String? description;
    final String? location;
    final DateTime? date;
    final String? time;
    final String? image;
    final String? category;
    final int? attendees;
    final bool? isFeatured;
    final Organizer? organizer;
    final int? commentCount;
    final int? likeCount;
    final int? shareCount;
    final int? attendeeCount;
    final bool? isLiked;
    final bool? isAttending;
    final List<Comment>? comments;
    final DateTime? createdAt;
    final List<Images>? images;

    ResultEvent({
        this.id,
        this.title,
        this.description,
        this.location,
        this.date,
        this.time,
        this.image,
        this.category,
        this.attendees,
        this.isFeatured,
        this.organizer,
        this.commentCount,
        this.likeCount,
        this.shareCount,
        this.attendeeCount,
        required this.isLiked,
        this.isAttending,
        this.comments,
        this.createdAt,
        this.images,
    });

    factory ResultEvent.fromJson(Map<String, dynamic> json) => ResultEvent(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        location: json["location"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        image: json["image"],
        category: json["category"],
        attendees: json["attendees"],
        isFeatured: json["is_featured"],
        organizer: json["organizer"] == null ? null : Organizer.fromJson(json["organizer"]),
        commentCount: json["comment_count"],
        likeCount: json["like_count"],
        shareCount: json["share_count"],
        attendeeCount: json["attendee_count"],
        isLiked: json["is_liked"]??false,
        isAttending: json["is_attending"],
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        images: json["images"] == null ? [] : List<Images>.from(json["images"]!.map((x) => Images.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "location": location,
        "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "image": image,
        "category": category,
        "attendees": attendees,
        "is_featured": isFeatured,
        "organizer": organizer?.toJson(),
        "comment_count": commentCount,
        "like_count": likeCount,
        "share_count": shareCount,
        "attendee_count": attendeeCount,
        "is_liked": isLiked,
        "is_attending": isAttending,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    };
}

class Comment {
    final int? id;
    final int? event;
    final String? author;
    final String? authorPicture;
    final String? authorName;
    final String? text;
    final DateTime? createdAt;

    Comment({
        this.id,
        this.event,
        this.author,
        this.authorPicture,
        this.authorName,
        this.text,
        this.createdAt,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        event: json["event"],
        author: json["author"],
        authorPicture: json["author_picture"],
        authorName: json["author_name"],
        text: json["text"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "event": event,
        "author": author,
        "author_picture": authorPicture,
        "author_name": authorName,
        "text": text,
        "created_at": createdAt?.toIso8601String(),
    };
}

class Images {
    final int? id;
    final String? image;

    Images({
        this.id,
        this.image,
    });

    factory Images.fromJson(Map<String, dynamic> json) => Images(
        id: json["id"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
    };
}

class Organizer {
    final int? pk;
    final int? user;
    final String? name;
    final String? activity;
    final String? place;
    final String? picture;
    final int? phoneNumber;
    final String? email;
    final String? bio;
    final dynamic birthday;
    final TypeBusiness? typeBusiness;

    Organizer({
        this.pk,
        this.user,
        this.name,
        this.activity,
        this.place,
        this.picture,
        this.phoneNumber,
        this.email,
        this.bio,
        this.birthday,
        this.typeBusiness,
    });

    factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
        pk: json["pk"],
        user: json["user"],
        name: json["name"],
        activity: json["activity"],
        place: json["place"],
        picture: json["picture"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        bio: json["bio"],
        birthday: json["birthday"],
        typeBusiness: json["type_business"] == null ? null : TypeBusiness.fromJson(json["type_business"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "user": user,
        "name": name,
        "activity": activity,
        "place": place,
        "picture": picture,
        "phone_number": phoneNumber,
        "email": email,
        "bio": bio,
        "birthday": birthday,
        "type_business": typeBusiness?.toJson(),
    };
}

class TypeBusiness {
    final int? id;
    final String? name;
    final String? color;
    final String? textColor;
    final String? icon;
    final String? description;

    TypeBusiness({
        this.id,
        this.name,
        this.color,
        this.textColor,
        this.icon,
        this.description,
    });

    factory TypeBusiness.fromJson(Map<String, dynamic> json) => TypeBusiness(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        textColor: json["text_color"],
        icon: json["icon"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "text_color": textColor,
        "icon": icon,
        "description": description,
    };
}
