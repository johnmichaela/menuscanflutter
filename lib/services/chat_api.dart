// // lib/services/chat_api.dart
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../models/chat_models.dart';

// class ChatApi {
//   /// e.g. http://192.168.1.115:8000 /api
//   final String baseUrl;

//   /// DRF token (without the "Token " prefix).
//   final String token;

//   ChatApi({required this.baseUrl, required this.token});

//   // ─────────────────────────── Headers ───────────────────────────
//   Map<String, String> get _headers => {
//         'Content-Type': 'application/json',
//         'Authorization': 'Token $token',
//       };

//   /// Headers for multipart requests — must NOT set Content-Type so
//   /// http adds the multipart boundary automatically.
//   Map<String, String> get _multipartHeaders => {
//         'Authorization': 'Token $token',
//       };

//   // ─────────────────────────── Helpers ───────────────────────────
//   /// Throws a descriptive [Exception] for any non-2xx response.
//   void _check(http.Response res) {
//     if (res.statusCode >= 200 && res.statusCode < 300) return;
//     String body = '';
//     try {
//       body = utf8.decode(res.bodyBytes);
//     } catch (_) {}
//     throw Exception(
//       'HTTP ${res.statusCode} ${res.request?.method ?? ''} '
//       '${res.request?.url.path ?? ''}: $body',
//     );
//   }

//   Map<String, dynamic> _decodeObject(http.Response res) =>
//       jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

//   // ─────────────────────── Conversations ─────────────────────────
//   Future<List<Conversation>> getConversations() async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/chat/conversations/'),
//       headers: _headers,
//     );
//     if (res.statusCode != 200) {
//       throw Exception('Failed to load conversations');
//     }
//     final data = jsonDecode(utf8.decode(res.bodyBytes)) as List;
//     return data
//         .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   Future<Conversation> startConversation({
//     required int otherUserId,
//     int? businessId,
//   }) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/chat/conversations/'),
//       headers: _headers,
//       body: jsonEncode({
//         'other_user_id': otherUserId,
//         if (businessId != null) 'business_id': businessId,
//       }),
//     );
//     if (res.statusCode != 200 && res.statusCode != 201) {
//       throw Exception('Failed to start conversation');
//     }
//     return Conversation.fromJson(_decodeObject(res));
//   }

//   /// DELETE /api/chat/conversations/<id>/
//   Future<void> deleteConversation(String conversationId) async {
//     final res = await http.delete(
//       Uri.parse('$baseUrl/chat/conversations/$conversationId/'),
//       headers: _headers,
//     );
//     _check(res);
//   }

//   // ────────────────────────── Messages ───────────────────────────
//   Future<List<ChatMessage>> getMessages(String conversationId) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/chat/conversations/$conversationId/messages/'),
//       headers: _headers,
//     );
//     print("urls......$res ...${res.body} ...${res.statusCode}");
//     if (res.statusCode != 200) {
//       throw Exception('Failed to load messages');
//     }
//     final data = jsonDecode(utf8.decode(res.bodyBytes)) as List;
//     print(data);
//     return data
//         .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   /// POST /api/chat/conversations/<id>/messages/send/
//   Future<ChatMessage> sendMessage(
//     String conversationId,
//     String text,
//   ) async {
//     final res = await http.post(
//       Uri.parse(
//         '$baseUrl/chat/conversations/$conversationId/messages/send/',
//       ),
//       headers: _headers,
//       body: jsonEncode({'text': text}),
//     );
//     if (res.statusCode != 201) {
//       throw Exception('Failed to send message');
//     }
//     return ChatMessage.fromJson(_decodeObject(res));
//   }

//   /// PATCH /api/chat/messages/<id>/  body: {"text": "new text"}
//   Future<ChatMessage> editMessage(
//     String messageId,
//     String newText,
//   ) async {
//     final res = await http.patch(
//       Uri.parse('$baseUrl/chat/messages/$messageId/'),
//       headers: _headers,
//       body: jsonEncode({'text': newText}),
//     );
//     _check(res);
//     return ChatMessage.fromJson(_decodeObject(res));
//   }

//   /// DELETE /api/chat/messages/<id>/
//   Future<void> deleteMessage(String messageId) async {
//     final res = await http.delete(
//       Uri.parse('$baseUrl/chat/messages/$messageId/'),
//       headers: _headers,
//     );
//     _check(res);
//   }

//   // ───────────────────────── Attachments ─────────────────────────
//   /// POST /api/chat/conversations/<id>/messages/upload/
//   /// multipart form-data:
//   ///   file    → the binary
//   ///   text    → optional caption
//   Future<ChatMessage> uploadAttachment(
//     String conversationId,
//     File file, {
//     String? caption,
//   }) async {
//     final req = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//         '$baseUrl/chat/conversations/$conversationId/messages/upload/',
//       ),
//     )..headers.addAll(_multipartHeaders);

//     if (caption != null && caption.trim().isNotEmpty) {
//       req.fields['text'] = caption.trim();
//     }

//     req.files.add(
//       await http.MultipartFile.fromPath('file', file.path),
//     );

//     final streamed = await req.send();
//     final res = await http.Response.fromStream(streamed);
//     _check(res);
//     return ChatMessage.fromJson(_decodeObject(res));
//   }
// }

// lib/services/chat_api.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/chat_models.dart';

class ChatApi {
  /// e.g. http://192.168.1.115:8000 /api
  final String baseUrl;

  /// DRF token (without the "Token " prefix).
  final String token;

  ChatApi({required this.baseUrl, required this.token});

  // ─────────────────────────── Headers ───────────────────────────
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };

  Map<String, String> get _multipartHeaders => {
        'Authorization': 'Token $token',
      };

  // ─────────────────────────── Helpers ───────────────────────────
  /// Decode body safely, regardless of charset.
  String _body(http.Response res) {
    try {
      return utf8.decode(res.bodyBytes);
    } catch (_) {
      return res.body;
    }
  }

  /// Throw a descriptive error including status + server body.
  Never _fail(http.Response res, String what) {
    throw ChatApiException(
      what: what,
      statusCode: res.statusCode,
      method: res.request?.method ?? '',
      path: res.request?.url.path ?? '',
      body: _body(res),
    );
  }

  void _expect(http.Response res, int code, String what) {
    if (res.statusCode != code) _fail(res, what);
  }

  Map<String, dynamic> _decodeObject(http.Response res) =>
      jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

  /// DRF may return a bare list, or a paginated {"results": [...]}.
  List<dynamic> _decodeList(http.Response res) {
    final decoded = jsonDecode(utf8.decode(res.bodyBytes));
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic> && decoded['results'] is List) {
      return decoded['results'] as List;
    }
    throw ChatApiException(
      what: 'Expected a list but got ${decoded.runtimeType}',
      statusCode: res.statusCode,
      method: res.request?.method ?? '',
      path: res.request?.url.path ?? '',
      body: _body(res),
    );
  }

  // ─────────────────────── Conversations ─────────────────────────
  Future<List<Conversation>> getConversations() async {
    final res = await http.get(
      Uri.parse('$baseUrl/chat/conversations/'),
      headers: _headers,
    );
    _expect(res, 200, 'load conversations');
    return _decodeList(res)
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Conversation> startConversation({
    required int otherUserId,
    int? businessId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chat/conversations/'),
      headers: _headers,
      body: jsonEncode({
        'other_user_id': otherUserId,
        if (businessId != null) 'business_id': businessId,
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      _fail(res, 'start conversation');
    }
    return Conversation.fromJson(_decodeObject(res));
  }

  Future<Conversation> getConversation(String conversationId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/chat/conversations/$conversationId/'),
      headers: _headers,
    );
    _expect(res, 200, 'load conversation $conversationId');
    return Conversation.fromJson(_decodeObject(res));
  }

  Future<void> deleteConversation(String conversationId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/chat/conversations/$conversationId/'),
      headers: _headers,
    );
    _expect(res, 204, 'delete conversation $conversationId');
  }

  // ────────────────────────── Messages ───────────────────────────
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final uri = Uri.parse(
      '$baseUrl/chat/conversations/$conversationId/messages/',
    );
    final res = await http.get(uri, headers: _headers);
    // CRITICAL: do NOT return [] on error — surface it.
    print(res);
    print(uri);
    _expect(res, 200, 'load messages for $conversationId ($uri)');
    markConversationRead(conversationId); 

    return _decodeList(res)
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/chat/conversations/<id>/read/
  Future<void> markConversationRead(String conversationId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chat/conversations/$conversationId/read/'),
      headers: _headers,
    );
    print(res);
    _expect(res, 200, 'mark conversation $conversationId read');
  }

  /// POST /api/chat/conversations/<id>/messages/send/
  Future<ChatMessage> sendMessage(
    String conversationId,
    String text,
  ) async {
    final res = await http.post(
      Uri.parse(
        '$baseUrl/chat/conversations/$conversationId/messages/send/',
      ),
      headers: _headers,
      body: jsonEncode({'text': text}),
    );
    _expect(res, 201, 'send message');
    // getMessages(conversationId);
    return ChatMessage.fromJson(_decodeObject(res));
  }

  /// PATCH /api/chat/messages/<id>/
  Future<ChatMessage> editMessage(
    String messageId,
    String newText,
  ) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/chat/messages/$messageId/'),
      headers: _headers,
      body: jsonEncode({'text': newText}),
    );
    _expect(res, 200, 'edit message $messageId');
    return ChatMessage.fromJson(_decodeObject(res));
  }

  /// DELETE /api/chat/messages/<id>/
  Future<void> deleteMessage(String messageId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/chat/messages/$messageId/'),
      headers: _headers,
    );
    _expect(res, 204, 'delete message $messageId');
  }

  // ───────────────────────── Attachments ─────────────────────────
  Future<ChatMessage> uploadAttachment(
    String conversationId,
    File file, {
    String? caption,
  }) async {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse(
        '$baseUrl/chat/conversations/$conversationId/messages/upload/',
      ),
    )..headers.addAll(_multipartHeaders);
print(req);
    if (caption != null && caption.trim().isNotEmpty) {
      req.fields['text'] = caption.trim();
    }
    req.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    _expect(res, 201, 'upload attachment');
    print(res);
    //  getMessages(conversationId);
    // print(ChatMessage.fromJson(_decodeObject(res)));
    return ChatMessage.fromJson(_decodeObject(res));
  }
}

/// Rich exception so you can log/display exactly what the server said.
class ChatApiException implements Exception {
  final String what;
  final int statusCode;
  final String method;
  final String path;
  final String body;

  ChatApiException({
    required this.what,
    required this.statusCode,
    required this.method,
    required this.path,
    required this.body,
  });

  @override
  String toString() =>
      'ChatApiException($what): HTTP $statusCode $method $path -> $body';
}