// lib/models/chat_models.dart
class ChatUser {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;

  ChatUser({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
  });

  String get displayName {
    final full = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return full.isEmpty ? username : full;
  }

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        id: json['id'],
        username: json['username'] ?? '',
        firstName: json['first_name'],
        lastName: json['last_name'],
      );
}
// class ChatBusiness {
//   final int id;
//   final String name;
//   final bool isOpen;

//   ChatBusiness({
//     required this.id,
//     required this.name,
//     required this.isOpen,
//   });

//   String get displayName => name.trim().isEmpty ? 'Business #$id' : name;

//   factory ChatBusiness.fromJson(Map<String, dynamic> json) => ChatBusiness(
//         id: json['id'] as int? ?? 0,
//         name: json['name'] as String? ?? '',
//         isOpen: json['is_open'] as bool? ?? false,
//       );
// }

// class ChatUser {
//   final int id;
//   final String username;
//   final String? firstName;
//   final String? lastName;
//   final ChatBusiness? business;   // 👈 new

//   ChatUser({
//     required this.id,
//     required this.username,
//     this.firstName,
//     this.lastName,
//     this.business,
//   });

//   String get displayName {
//     final full = '${firstName ?? ''} ${lastName ?? ''}'.trim();
//     if (full.isNotEmpty) return full;
//     // Fall back to the business name if the user has no personal name
//     if (business != null && business!.name.isNotEmpty) return business!.name;
//     return username;
//   }

//   factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
//         id: json['id'] as int? ?? 0,
//         username: json['username'] as String? ?? '',
//         firstName: json['first_name'] as String?,
//         lastName: json['last_name'] as String?,
//         business: json['business'] != null
//             ? ChatBusiness.fromJson(json['business'] as Map<String, dynamic>)
//             : null,
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'username': username,
//         'first_name': firstName,
//         'last_name': lastName,
//         'business': business == null
//             ? null
//             : {
//                 'id': business!.id,
//                 'name': business!.name,
//                 'is_open': business!.isOpen,
//               },
//       };
// }
class Conversation {
  final String id;
  final List<ChatUser> participants;
  final int? business;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  Conversation({
    required this.id,
    required this.participants,
    this.business,
    required this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
    required this.createdAt,
  });

  ChatUser? otherUser(int currentUserId) {
    try {
      return participants.firstWhere((u) => u.id != currentUserId);
    } catch (_) {
      return participants.isNotEmpty ? participants.first : null;
    }
  }

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'],
        participants: (json['participants'] as List? ?? [])
            .map((e) => ChatUser.fromJson(e))
            .toList(),
        business: json['business'],
        lastMessage: json['last_message_preview'] ?? '',
        lastMessageAt: json['last_message_at'] != null
            ? DateTime.parse(json['last_message_at'])
            : null,
        unreadCount: json['unread_count'] ?? 0,
        createdAt: DateTime.parse(json['created_at']),
      );
}

// class ChatMessage {
//   final String id;
//   final String conversationId;
//   final ChatUser? sender;
//   final String text;
//   final String? attachment;
//   final bool isRead;
//   final DateTime createdAt;

//   ChatMessage({
//     required this.id,
//     required this.conversationId,
//     this.sender,
//     required this.text,
//     this.attachment,
//     required this.isRead,
//     required this.createdAt,
//   });

//   factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
//         id: json['id'],
//         conversationId: json['conversation'] ?? '',
//         sender: json['sender'] != null
//             ? ChatUser.fromJson(json['sender'])
//             : null,
//         text: json['text'] ?? '',
//         attachment: json['attachment'],
//         isRead: json['is_read'] ?? false,
//         createdAt: DateTime.parse(json['created_at']),
//       );
// }
class ChatMessage {
  final String id;
  final String conversationId;
  final ChatUser? sender;
  final String text;
  final String? attachment;       // raw URL from server (back-compat)
  final String? attachmentName;   // display filename
  final String? attachmentType;   // mime type
  final bool isRead;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime? editedAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    this.sender,
    required this.text,
    this.attachment,
    this.attachmentName,
    this.attachmentType,
    required this.isRead,
    this.isDeleted = false,
    required this.createdAt,
    this.editedAt,
  });

  /// True when the message has any attachment (URL present).
  bool get hasAttachment => attachment != null && attachment!.isNotEmpty;

  ChatMessage copyWith({
    String? text,
    bool? isRead,
    bool? isDeleted,
    DateTime? editedAt,
  }) {
    return ChatMessage(
      id: id,
      conversationId: conversationId,
      sender: sender,
      text: text ?? this.text,
      attachment: attachment,
      attachmentName: attachmentName,
      attachmentType: attachmentType,
      isRead: isRead ?? this.isRead,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'].toString(),
        conversationId: json['conversation']?.toString() ?? '',
        sender: json['sender'] != null
            ? ChatUser.fromJson(json['sender'] as Map<String, dynamic>)
            : null,
        text: json['text'] ?? '',
        attachment: json['attachment'],
        attachmentName: json['attachment_name'],
        attachmentType: json['attachment_type'],
        isRead: json['is_read'] ?? false,
        isDeleted: json['is_deleted'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        editedAt: json['edited_at'] != null
            ? DateTime.parse(json['edited_at'])
            : null,
      );
}

