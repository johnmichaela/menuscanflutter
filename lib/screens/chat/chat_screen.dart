// lib/screens/chat/chat_screen.dart
import 'dart:async';
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
  // ──────────────── Controllers & state ────────────────
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final List<ChatMessage> _messages = [];

  IOWebSocketChannel? _channel;
  StreamSubscription? _socketSub;

  bool _wsReady = false;
  bool _wsConnecting = false;
  bool _loadingHistory = true;
  bool _sending = false;
  bool _disposed = false;
  String? _error;

  ChatMessage? _editing;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  // ──────────────── Lifecycle ────────────────
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _loadHistory();
    if (!_disposed) _connectSocket();
  }

  @override
  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _socketSub?.cancel();
    _channel?.sink.close(ws_status.normalClosure);
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ──────────────── History ────────────────
  Future<void> _loadHistory() async {
    try {
      final history = await widget.api.getMessages(widget.conversation.id);
      if (_disposed) return;

      // Preserve any messages that arrived over socket while loading
      final existingIds = _messages.map((m) => m.id).toSet();
      final merged = [
        ...history.where((m) => !existingIds.contains(m.id)),
        ..._messages,
      ];
      merged.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      setState(() {
        _messages
          ..clear()
          ..addAll(merged);
        _loadingHistory = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (_disposed) return;
      setState(() {
        _error = e.toString();
        _loadingHistory = false;
      });
    }
  }

  Future<void> _refreshHistory() async {
    await _loadHistory();
  }

  // ──────────────── WebSocket ────────────────
  Future<void> _connectSocket() async {
    if (_disposed || _wsConnecting || _wsReady || _channel != null) return;

    _wsConnecting = true;

    final url = _buildSocketUrl();
    debugPrint('🔌 WS URL: $url');

    final channel = IOWebSocketChannel.connect(
      Uri.parse(url),
      headers: const {'Origin': 'http://192.168.1.115:8000 '},
      pingInterval: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 10),
    );
    _channel = channel;

    try {
      await channel.ready;
      if (_disposed) {
        await channel.sink.close(ws_status.normalClosure);
        _channel = null;
        _wsConnecting = false;
        return;
      }
      _wsReady = true;
      _wsConnecting = false;
      _reconnectAttempts = 0;
      _error = null;
      debugPrint('✅ WS connected');
    } catch (e) {
      debugPrint('❌ WS connect failed: $e');
      _channel = null;
      _wsReady = false;
      _wsConnecting = false;
      _scheduleReconnect();
      return;
    }

    _socketSub = channel.stream.listen(
      _onSocketData,
      onError: (e) {
        debugPrint('WS error: $e');
        _handleSocketDown();
      },
      onDone: () {
        debugPrint('WS closed (code: ${channel.closeCode})');
        _handleSocketDown();
      },
      cancelOnError: true,
    );
  }

  String _buildSocketUrl() {
    final uri = Uri.parse(widget.api.baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final port = uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80);
    final origin = '$wsScheme://${uri.host}:$port';

    // ⚠️ Adjust this path to match your Django `routing.py` EXACTLY.
    // If your channels routes are under /api/, use '/api/ws/chat/...'
    return '$origin/ws/chat/${widget.conversation.id}/?token=${widget.api.token}';
  }

  void _handleSocketDown() {
    if (_disposed) return;
    _wsReady = false;
    _channel = null;
    _socketSub?.cancel();
    _socketSub = null;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _reconnectAttempts++;
    // Backoff: 2s, 4s, 8s, 16s, capped at 30s
    final seconds = (2 * _reconnectAttempts).clamp(2, 30);
    debugPrint('🔁 Reconnecting in ${seconds}s (attempt $_reconnectAttempts)');
    _reconnectTimer = Timer(Duration(seconds: seconds), () {
      if (!_disposed) _connectSocket();
    });
  }

  void _onSocketData(dynamic data) {
    if (_disposed) return;
    try {
      final json = jsonDecode(data as String) as Map<String, dynamic>;
      debugPrint('📩 WS incoming: $json');

      if (json.containsKey('error')) {
        debugPrint('WS error payload: $json');
        return;
      }

      switch (json['event']) {
        case 'message_edited':
          _applyEdit(json['message_id']?.toString(), json['message'] ?? '');
          return;
        case 'message_deleted':
          _applyDelete(json['message_id']?.toString());
          return;
        case 'message_read':
          return; // hook if you want read receipts
        default:
          break;
      }

      // Normal message
      final msg = ChatMessage.fromJson({
        'id': json['message_id']?.toString(),
        'conversation': widget.conversation.id,
        'sender': {
          'id': json['user_id'] ?? 0,
          'username': json['username'] ?? 'Unknown',
          'first_name': json['first_name'],
          'last_name': json['last_name'],
          'business': json['business'],
        },
        'text': json['message'] ?? '',
        'attachment': json['attachment_url'],
        'attachment_name': json['attachment_name'],
        'attachment_type': json['attachment_type'],
        'is_read': true,
        'created_at': json['created_at'],
      });

      _appendMessage(msg);
    } catch (e) {
      debugPrint('WS parse error: $e');
    }
  }

  // ──────────────── Message list helpers ────────────────
  void _appendMessage(ChatMessage msg) {
    if (_messages.any((m) => m.id == msg.id)) return;
    setState(() => _messages.add(msg));
    _scrollToBottom();
  }

  void _applyEdit(String? id, String newText) {
    if (id == null) return;
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    setState(() {
      _messages[idx] = _messages[idx]
          .copyWith(text: newText, editedAt: DateTime.now());
    });
  }

  void _applyDelete(String? id) {
    if (id == null) return;
    final idx = _messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    setState(() => _messages[idx] = _messages[idx].copyWith(isDeleted: true));
  }

  // ──────────────── Send / Edit / Delete ────────────────
  Future<void> _send() async {
    final text = _ctrl.text.trim();

    if (_editing != null) {
      await _commitEdit(text);
      return;
    }

    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _ctrl.clear();

    bool sentOverSocket = false;
    if (_wsReady && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'message': text}));
        sentOverSocket = true;
      } catch (e) {
        debugPrint('WS send failed, falling back to HTTP: $e');
      }
    }

    if (!sentOverSocket) {
      try {
        final saved =
            await widget.api.sendMessage(widget.conversation.id, text);
        _appendMessage(saved);
      } catch (e) {
        _showSnack('Send failed: $e');
      }
    }

    if (!_disposed) setState(() => _sending = false);
  }

  Future<void> _commitEdit(String text) async {
    final editing = _editing!;
    if (text.isEmpty) {
      _cancelEdit();
      return;
    }

    try {
      final updated = await widget.api.editMessage(editing.id, text);
      _applyEdit(editing.id, updated.text);

      if (_wsReady && _channel != null) {
        try {
          _channel!.sink.add(jsonEncode({
            'action': 'edit',
            'message_id': editing.id,
            'message': text,
          }));
        } catch (_) {}
      }
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
    if (_disposed) return;
    setState(() => _editing = null);
    _ctrl.clear();
  }

  Future<void> _deleteMessage(ChatMessage m) async {
    final ok = await _confirm('Delete message?', 'This cannot be undone.');
    if (!ok) return;

    try {
      await widget.api.deleteMessage(m.id);
      _applyDelete(m.id);

      if (_wsReady && _channel != null) {
        try {
          _channel!.sink.add(jsonEncode({
            'action': 'delete',
            'message_id': m.id,
          }));
        } catch (_) {}
      }
    } catch (e) {
      _showSnack('Delete failed: $e');
    }
  }

  // ──────────────── Attachments ────────────────
  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // close sheet

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 2048,
    );
    if (picked == null) return;

    final file = File(picked.path);
    if (!_disposed) setState(() => _sending = true);

    try {
      final caption = _ctrl.text.trim();
      final saved = await widget.api.uploadAttachment(
        widget.conversation.id,
        file,
        caption: caption.isEmpty ? null : caption,
      );
      _appendMessage(saved);
      _ctrl.clear();
      _scrollToBottom();
    } catch (e) {
      _showSnack('Upload failed: $e');
    } finally {
      if (!_disposed) setState(() => _sending = false);
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
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
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

  // ──────────────── Helpers ────────────────
  void _showSnack(String msg) {
    if (_disposed) return;
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
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  // ──────────────── UI ────────────────
  @override
  Widget build(BuildContext context) {
    final other = widget.conversation.otherUser(widget.currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text(other?.displayName ?? 'Chat')),
            if (!_wsReady)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.cloud_off, size: 16, color: Colors.orange),
              ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loadingHistory
                ? const Center(child: CircularProgressIndicator())
                : _error != null && _messages.isEmpty
                    ? _buildErrorState()
                    : RefreshIndicator(
                        onRefresh: _refreshHistory,
                        child: ListView.builder(
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
          ),

          if (_editing != null) _buildEditingBanner(),

          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() => _error = null);
                _bootstrap();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
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
                onPressed: _sending ? null : _send,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(ChatMessage m, bool isMine) {
    final deleted = m.isDeleted;
    final fg =
        isMine ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color;

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
                      fontStyle: deleted ? FontStyle.italic : FontStyle.normal,
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
}