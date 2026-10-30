// // lib/screens/chat/chat_screen.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as ws_status;
// import '../../models/chat_models.dart';
// import '../../services/chat_api.dart';

// class ChatScreen extends StatefulWidget {
//   final ChatApi api;
//   final Conversation conversation;
//   final int currentUserId;

//   const ChatScreen({
//     super.key,
//     required this.api,
//     required this.conversation,
//     required this.currentUserId,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _ctrl = TextEditingController();
//   final ScrollController _scrollCtrl = ScrollController();
//   final List<ChatMessage> _messages = [];

//   IOWebSocketChannel? _channel;
//   bool _loading = true;
//   String? _error;
//   bool _sending = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//     _connectSocket();
//   }

//   @override
//   void dispose() {
//     _channel?.sink.close(ws_status.normalClosure);
//     _ctrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _loadHistory() async {
//     try {
//       final history =
//           await widget.api.getMessages(widget.conversation.id);
//       setState(() {
//         _messages
//           ..clear()
//           ..addAll(history);
//         _loading = false;
//       });
//       _scrollToBottom();
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }
// Future<void> _connectSocket() async {
//   final uri = Uri.parse(widget.api.baseUrl);
//   final origin = '${uri.scheme}://${uri.host}:${uri.port}';
//   final wsOrigin = origin.startsWith('https://')
//       ? origin.replaceFirst('https://', 'wss://')
//       : origin.replaceFirst('http://', 'ws://');
//   final url = '$wsOrigin/ws/chat/${widget.conversation.id}/?token=${widget.api.token}';
//   debugPrint('🔌 WebSocket URL: $url');

//   _channel = IOWebSocketChannel.connect(
//     Uri.parse(url),
//     headers: const {'Origin': 'http://192.168.1.115:8000 '},
//   );

//   try {
//     await _channel!.ready;   // ← waits for the upgrade to complete
//     debugPrint('✅ WS connected');
//   } catch (e) {
//     debugPrint('❌ WS connect failed: $e');
//     setState(() => _error = 'Cannot connect to chat');
//   }

//   _channel!.stream.listen(
//     (data) { 
//        try {
//         final json = jsonDecode(data as String) as Map<String, dynamic>;
//         if (json.containsKey('error')) {
//           debugPrint('WS error payload: $json');
//           return;
//         }

//         final msg = ChatMessage(
//           id: json['message_id'] ?? '',
//           conversationId: widget.conversation.id,
//           sender: ChatUser(
//             id: json['user_id'] ?? 0,
//             username: json['username'] ?? 'Unknown',
//           ),
//           text: json['message'] ?? '',
//           isRead: true,
//           createdAt: json['created_at'] != null
//               ? DateTime.parse(json['created_at'])
//               : DateTime.now(),
//         );

//         setState(() => _messages.add(msg));
//         _scrollToBottom();
//       } catch (e) {
//         debugPrint('WS parse error: $e');
//       }
//      },
//     onError: (e) => debugPrint('WS error: $e'),
//     onDone: () => debugPrint('WS closed'),
//   );
// }
// void _connectSocketx() {
//   // 1. Strip everything after the host: /api, /api/chat, /api/chat/, etc.
//   final uri = Uri.parse(widget.api.baseUrl);
//   final origin = '${uri.scheme}://${uri.host}:${uri.port}';

//   // 2. http → ws, https → wss
//   final wsOrigin = origin.startsWith('https://')
//       ? origin.replaceFirst('https://', 'wss://')
//       : origin.replaceFirst('http://', 'ws://');

//   // 3. Clean path
//   final url =
//       '$wsOrigin/ws/chat/${widget.conversation.id}/?token=${widget.api.token}';

//   debugPrint('🔌 WebSocket URL: $url');

//   _channel = IOWebSocketChannel.connect(
//     Uri.parse(url),
//     headers: const {'Origin': 'http://192.168.1.115:8000 '},
//   );

//   _channel!.stream.listen(
//     (data) {
//       try {
//         final json = jsonDecode(data as String) as Map<String, dynamic>;
//         if (json.containsKey('error')) {
//           debugPrint('WS error payload: $json');
//           return;
//         }

//         final msg = ChatMessage(
//           id: json['message_id'] ?? '',
//           conversationId: widget.conversation.id,
//           sender: ChatUser(
//             id: json['user_id'] ?? 0,
//             username: json['username'] ?? 'Unknown',
//           ),
//           text: json['message'] ?? '',
//           isRead: true,
//           createdAt: json['created_at'] != null
//               ? DateTime.parse(json['created_at'])
//               : DateTime.now(),
//         );

//         setState(() => _messages.add(msg));
//         _scrollToBottom();
//       } catch (e) {
//         debugPrint('WS parse error: $e');
//       }
//     },
//     onError: (e) {
//       debugPrint('WS error: $e');
//       setState(() => _error = 'Socket error: $e');
//     },
//     onDone: () => debugPrint('WS closed'),
//   );
// }

// Future<void> _send() async {
//   final text = _ctrl.text.trim();
//   if (text.isEmpty || _sending) return;
//   setState(() => _sending = true);
//   _ctrl.clear();

//   bool sentOverSocket = false;

//   if (_channel != null) {
//     try {
//       _channel!.sink.add(jsonEncode({'message': text}));
//       sentOverSocket = true;
//     } catch (e) {
//       debugPrint('WS send failed, falling back to HTTP: $e');
//     }
//   }

//   if (!sentOverSocket) {
//     try {
//       final saved =
//           await widget.api.sendMessage(widget.conversation.id, text);
//       setState(() => _messages.add(saved));
//       _scrollToBottom();
//     } catch (e) {
//       setState(() => _error = e.toString());
//     }
//   }

//   if (mounted) setState(() => _sending = false);
// }

  

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           _scrollCtrl.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

 

//   @override
//   Widget build(BuildContext context) {
//     final other =
//         widget.conversation.otherUser(widget.currentUserId);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(other?.displayName ?? 'Chat'),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _error != null && _messages.isEmpty
//                     ? Center(child: Text(_error!))
//                     : ListView.builder(
//                         controller: _scrollCtrl,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         itemCount: _messages.length,
//                         itemBuilder: (context, i) {
//                           final m = _messages[i];
//                           final isMine =
//                               m.sender?.id == widget.currentUserId;
//                           return _bubble(m, isMine);
//                         },
//                       ),
//           ),
//           SafeArea(
//             top: false,
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 8,
//               ),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 6,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _ctrl,
//                       textInputAction: TextInputAction.send,
//                       onSubmitted: (_) => _send(),
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         filled: true,
//                         fillColor:
//                             Theme.of(context).scaffoldBackgroundColor,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 10,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(24),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   CircleAvatar(
//                     backgroundColor: Theme.of(context).primaryColor,
//                     child: IconButton(
//                       icon: const Icon(Icons.send, color: Colors.white),
//                       onPressed: _send,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _bubble(ChatMessage m, bool isMine) {
//     return Align(
//       alignment:
//           isMine ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 8,
//         ),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         decoration: BoxDecoration(
//           color: isMine
//               ? Theme.of(context).primaryColor
//               : Theme.of(context).cardColor,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(14),
//             topRight: const Radius.circular(14),
//             bottomLeft: Radius.circular(isMine ? 14 : 2),
//             bottomRight: Radius.circular(isMine ? 2 : 14),
//           ),
//         ),
//         child: Text(
//           m.text,
//           style: TextStyle(
//             color: isMine
//                 ? Colors.white
//                 : Theme.of(context).textTheme.bodyLarge?.color,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/screens/chat/chat_screen.dart
// lib/screens/chat/chat_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import '../../models/chat_models.dart';
import '../../services/chat_api.dart';

class ChatScreen extends StatefulWidget {
  final ChatApi api;
  final Conversation conversation;
  final int currentUserId;

  const ChatScreen({
    super.key,
    required this.api,
    required this.conversation,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();

  IOWebSocketChannel? _channel;
  bool _loading = true;
  String? _error;
  bool _sending = false;

  /// Currently-editing message (null = not editing).
  ChatMessage? _editing;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _connectSocket();
  }

  @override
  void dispose() {
    _channel?.sink.close(ws_status.normalClosure);
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────── History ───────────────────────────
  Future<void> _loadHistory() async {
    try {
      final history = await widget.api.getMessages(widget.conversation.id);
      setState(() {
        _messages
          ..clear()
          ..addAll(history);
        _loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // ─────────────────────────── WebSocket ─────────────────────────
  
  Future<void> _connectSocket() async {
    final uri = Uri.parse(widget.api.baseUrl);
    final origin = '${uri.scheme}://${uri.host}:${uri.port}';
    final wsOrigin = origin.startsWith('https://')
        ? origin.replaceFirst('https://', 'wss://')
        : origin.replaceFirst('http://', 'ws://');
    final url =
        '$wsOrigin/ws/chat/${widget.conversation.id}/?token=${widget.api.token}';
    debugPrint('🔌 WebSocket URL: $url');
    print('🔌 WebSocket URL: $url');

    _channel = IOWebSocketChannel.connect(
      Uri.parse(url),
      headers: const {'Origin': 'http://192.168.1.115:8000 '},
    );

    try {
      await _channel!.ready;
      debugPrint('✅ WS connected');
      print('✅ WS connected');
    } catch (e) {
      debugPrint('❌ WS connect failed: $e');
      print('❌ WS connect failed: $e');
      setState(() => _error = 'Cannot connect to chat');
    }

    _channel!.stream.listen(
      (data) {
        try {
          final json = jsonDecode(data as String) as Map<String, dynamic>;

          if (json.containsKey('error')) {
            debugPrint('WS error payload: $json');
            print('WS error payload: $json');
            return;
          }

          // Realtime edit / delete events
          if (json['event'] == 'message_edited') {
            _applyEdit(json['message_id'], json['message']);
            return;
          }
          if (json['event'] == 'message_deleted') {
            _applyDelete(json['message_id']);
            return;
          }

          // Normalize to the ChatMessage shape used by HTTP endpoints.
          final msg = ChatMessage.fromJson({
            'id': json['message_id'],
            'conversation': widget.conversation.id,
            'sender': {
              'id': json['user_id'] ?? 0,
              'username': json['username'] ?? 'Unknown',
            },
            'text': json['message'] ?? '',
            'attachment': json['attachment_url'],
            'attachment_name': json['attachment_name'],
            'attachment_type': json['attachment_type'],
            'is_read': true,
            'created_at': json['created_at'],
          });

          setState(() => _messages.add(msg));
          _scrollToBottom();
        } catch (e) {
          debugPrint('WS parse error: $e');
          print('WS parse error: $e');
        }
      },
      onError: (e) => debugPrint('WS error: $e'),
      onDone: () => debugPrint('WS closed'),
    );
  }

  // ─────────────────────────── Send / Edit ───────────────────────
  Future<void> _send() async {
    final text = _ctrl.text.trim();
    // _connectSocket();
   print(text);
    if (_editing != null) {
      await _commitEdit(text);
      return;
    }

    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _ctrl.clear();

    bool sentOverSocket = false;
    if (_channel != null) {
      try {
        print('passed ---text  $text');
        _channel!.sink.add(jsonEncode({'message': text}));
        sentOverSocket = true;
      } catch (e) {
        debugPrint('WS send failed, falling back to HTTP: $e');
        print('WS send failed, falling back to HTTP: $e');
      }
    }

    if (!sentOverSocket) {
      try {
        final saved =
            await widget.api.sendMessage(widget.conversation.id, text);
        setState(() => _messages.add(saved));
        _scrollToBottom();
      } catch (e) {
        setState(() => _error = e.toString());
      }
    }

    if (mounted) setState(() => _sending = false);
  }

  Future<void> _commitEdit(String text) async {
    final editing = _editing!;
    // _connectSocket();
    if (text.isEmpty) {
      _cancelEdit();
      return;
    }
    try {
      final updated = await widget.api.editMessage(editing.id, text);
      _applyEdit(editing.id, updated.text);
      _channel?.sink.add(jsonEncode({
        'action': 'edit',
        'message_id': editing.id,
        'message': text,
      }));
    } catch (e) {
      _showSnack('Edit failed: $e');
    }
    _cancelEdit();
  }

  void _startEdit(ChatMessage m) {
    setState(() => _editing = m);
    _ctrl.text = m.text;
    _ctrl.selection =
        TextSelection(baseOffset: 0, extentOffset: m.text.length);
  }

  void _cancelEdit() {
    setState(() => _editing = null);
    _ctrl.clear();
  }

  void _applyEdit(String id, String newText) {
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    setState(() {
      _messages[idx] = _messages[idx]
          .copyWith(text: newText, editedAt: DateTime.now());
    });
  }

  // ─────────────────────────── Delete ────────────────────────────
  Future<void> _deleteMessage(ChatMessage m) async {
    final confirm =
        await _confirm('Delete message?', 'This cannot be undone.');
    if (!confirm) return;
    try {
      await widget.api.deleteMessage(m.id);
      _applyDelete(m.id);
      _channel?.sink.add(jsonEncode({
        'action': 'delete',
        'message_id': m.id,
      }));
    } catch (e) {
      _showSnack('Delete failed: $e');
    }
  }

  void _applyDelete(String id) {
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    setState(() =>
        _messages[idx] = _messages[idx].copyWith(isDeleted: true));
  }

  // ─────────────────── Image attachments (image_picker) ──────────
  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // close the source sheet
    
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80, // keep uploads reasonable
      maxWidth: 2048,
    );
    if (picked == null) return;

    final file = File(picked.path);
    setState(() => _sending = true);
    try {
      
      final saved = await widget.api.uploadAttachment(
        widget.conversation.id,
        file,
        caption: _ctrl.text.trim().isEmpty ? null : _ctrl.text.trim(),
      );
      setState(() => _messages.add(saved));
      _ctrl.clear();
      // await widget.api.getMessage();
      _loadHistory();
      _scrollToBottom();
    } catch (e) {
      // _showSnack('Upload failed: $e');

    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _showAttachSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── Helpers ───────────────────────────
  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> _confirm(String title, String body) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─────────────────────────── UI ────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final other = widget.conversation.otherUser(widget.currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(other?.displayName ?? 'Chat'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null && _messages.isEmpty
                    ? Center(child: Text(_error!))
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final m = _messages[i];
                          final isMine =
                              m.sender?.id == widget.currentUserId;
                          return _bubble(m, isMine);
                        },
                      ),
          ),

          if (_editing != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Editing message')),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: _cancelEdit,
                  ),
                ],
              ),
            ),

          SafeArea(
            top: false,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _sending ? null : _showAttachSheet,
                    tooltip: 'Send image',
                  ),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: _editing != null
                            ? 'Edit message...'
                            : 'Type a message...',
                        filled: true,
                        fillColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: Icon(
                        _editing != null ? Icons.check : Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(ChatMessage m, bool isMine) {
    final deleted = m.isDeleted;
    final fg = isMine
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge?.color;

    return GestureDetector(
      onLongPress: isMine && !deleted ? () => _showMessageMenu(m) : null,
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMine
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(isMine ? 14 : 2),
              bottomRight: Radius.circular(isMine ? 2 : 14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image thumbnail
              if (m.hasAttachment && !deleted)
                GestureDetector(
                  onTap: () => _openImage(m.attachment!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      m.attachment!,
                      width: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          width: 200,
                          height: 140,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        width: 200,
                        height: 140,
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),

              if (m.hasAttachment && !deleted && m.text.isNotEmpty)
                const SizedBox(height: 4),

              // Text (or deleted placeholder)
              if (m.text.isNotEmpty || deleted)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    deleted ? 'This message was deleted' : m.text,
                    style: TextStyle(
                      color: deleted
                          ? (isMine ? Colors.white70 : Colors.grey)
                          : fg,
                      fontSize: 14,
                      fontStyle:
                          deleted ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),

              if (m.editedAt != null && !deleted)
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4),
                  child: Text(
                    'edited',
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                      color: isMine ? Colors.white60 : Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImage(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageMenu(ChatMessage m) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _startEdit(m);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.red),
              title:
                  const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(m);
              },
            ),
          ],
        ),
      ),
    );
  }
}