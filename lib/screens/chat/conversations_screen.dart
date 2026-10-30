
import 'package:ballon/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../models/chat_models.dart';
import '../../services/chat_api.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  final ChatApi? api;                 // optional — built from prefs if null
  final int? currentUserId;           // optional — read from prefs if null
  final ValueChanged<int>? onUnreadChanged;

  const ConversationsScreen({
    super.key,
    this.api,
    this.currentUserId,
    this.onUnreadChanged,
  });

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  static const _baseUrl = 'http://192.168.1.115:8000 /api';

  ChatApi? _api;
  int? _currentUserId;
  Future<List<Conversation>>? _future;
  String? _sessionError;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // 1. Prefer what the parent provided.
    var api = widget.api;
    var userId = widget.currentUserId;

    // 2. Otherwise read from prefs (null-safe).
    if (api == null || userId == null) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      // userid = User PK; profid = Profile PK. Chat needs the USER id.
      final id = prefs.getInt('userid') ?? prefs.getInt('profid');

      if (token == null || token.isEmpty || id == null) {
        if (!mounted) return;
        setState(() {
          _sessionError = 'Please log in to view messages.';
        });
        return;
      }
      api ??= ChatApi(baseUrl: _baseUrl, token: token);
      userId ??= id;
    }

    if (!mounted) return;
    setState(() {
      _api = api;
      _currentUserId = userId;
      _sessionError = null;
      _future = _load();
    });
  }

  Future<List<Conversation>> _load() async {
    final api = _api;
    if (api == null) return const [];

    final list = await api.getConversations();

    // Report total unread to the shell (badge).
    final total = list.fold<int>(0, (sum, c) => sum + c.unreadCount);
    widget.onUnreadChanged?.call(total);

    return list;
  }

  Future<void> _refresh() async {
    if (_api == null) return;
    setState(() => _future = _load());
    await _future;
  }

  // ───────────────────── Delete conversation ─────────────────────
  Future<void> _deleteConversation(Conversation c) async {
    final api = _api;
    if (api == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete conversation?'),
        content: const Text(
          'The conversation and its messages will be removed. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await api.deleteConversation(c.id);
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  void _showConversationMenu(Conversation c) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                _openConversation(c);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteConversation(c);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openConversation(Conversation c) {
    final api = _api;
    final userId = _currentUserId;
    if (api == null || userId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          api: api,
          conversation: c,
          currentUserId: userId,
        ),
      ),
    ).then((_) => _refresh());
  }

  // ─────────────────────────── UI ────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages',style: TextStyle(fontSize: 16),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // No session → prompt to log in.
    if (_sessionError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(_sessionError!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  onPressed: () {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  },
  child: const Text('Log in'),
),
//               FilledButton(
//                                 style: ButtonStyle(
//                   backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
//                   shape: WidgetStateProperty.all(
//                     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//                 onPressed: () =>
//                     Navigator.of(context).pushAndRemoveUntil(
//   MaterialPageRoute(builder: (_) => const LoginScreen()),
//   (route) => false,
// );
//                 ),
                // child: const Text('Log in'),
            //   ),
            ],
          ),
        ),
      );
    }

    final future = _future;
    if (future == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Conversation>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return ListView(
              children: [
                const SizedBox(height: 120),
                Center(child: Text('${snap.error}')),
                Center(
                  child: TextButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ),
              ],
            );
          }

          final items = snap.data ?? const <Conversation>[];
          if (items.isEmpty) {
            return ListView(
              children: [
                const SizedBox(height: 120),
                const Icon(LucideIcons.messageCircleDashed,
                    size: 76, color: Colors.grey),
                const SizedBox(height: 12),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No conversations yet'),
                      const SizedBox(width: 6),
                      Text(
                        'Try',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = items[i];
              return Dismissible(
                key: ValueKey(c.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await _deleteConversation(c);
                  return false;
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: _ConversationTile(
                  conversation: c,
                  currentUserId: _currentUserId ?? 0,
                  onTap: () => _openConversation(c),
                  onLongPress: () => _showConversationMenu(c),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ───────────────────────── Tile widget ─────────────────────────
class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final int currentUserId;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final other = conversation.otherUser(currentUserId);
    final time = conversation.lastMessageAt ?? conversation.createdAt;
    final preview = conversation.lastMessage;
    final initial = (other?.username.isNotEmpty == true)
        ? other!.username[0].toUpperCase()
        : '?';

    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: CircleAvatar(
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(0.15),
        child: Text(
          initial,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        other?.displayName ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13,),
      ),
      subtitle: Text(
        preview.isEmpty ? 'Start the conversation' : preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat('HH:mm').format(time.toLocal()),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          if (conversation.unreadCount > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}