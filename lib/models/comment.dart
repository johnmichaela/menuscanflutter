// To parse this JSON data, do
//
//     final commentList = commentListFromJson(jsonString);

import 'dart:convert';

CommentList commentListFromJson(String str) => CommentList.fromJson(json.decode(str));

String commentListToJson(CommentList data) => json.encode(data.toJson());

class CommentList {
    final List<ResultComment>? results;

    CommentList({
        this.results,
    });

    factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
        results: json["results"] == null ? [] : List<ResultComment>.from(json["results"]!.map((x) => ResultComment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class ResultComment {
    final int? id;
    final int? event;
    final String? author;
    final String? authorPicture;
    final String? authorName;
    final String? text;
    final DateTime? createdAt;

    ResultComment({
        this.id,
        this.event,
        this.author,
        this.authorPicture,
        this.authorName,
        this.text,
        this.createdAt,
    });

    factory ResultComment.fromJson(Map<String, dynamic> json) => ResultComment(
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
