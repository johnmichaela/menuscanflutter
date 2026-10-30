import 'dart:io';

import 'package:ballon/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================
// 2. COMMENTS BOTTOM SHEET
// ============================================
class CommentsBottomSheet extends StatefulWidget {
  final int eventId;
  final String? token; // Pass token if needed

  const CommentsBottomSheet({
    Key? key,
    required this.eventId,
    this.token,
  }) : super(key: key);

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ResultComment> comments = [];
  bool isLoading = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  // ============================================
  // FETCH COMMENTS FROM API
  // ============================================
 Future<void> _fetchComments() async {
  setState(() => isLoading = true);
   final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
  try {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.115:8000 /api/events/${widget.eventId}/comments/'),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': '*/*',
        'Allow': 'GET, OPTIONS',      // This header is unusual for a request; consider removing
        'Accept-Encoding': 'gzip, deflate, br',
        if (token != null) 'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<ResultComment> fetchedComments = [];

      if (decoded is Map<String, dynamic> && decoded.containsKey('results')) {
        // Paginated response: { "results": [...] }
        final commentList = CommentList.fromJson(decoded);
        fetchedComments = commentList.results ?? [];
      } else if (decoded is List) {
        // Direct list response: [ ... ]
        fetchedComments = decoded
            .map((item) => ResultComment.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }

      setState(() {
        comments = fetchedComments;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load comments');
    }
  } catch (e) {
    print('Error fetching comments: $e');
    setState(() => isLoading = false);
    _showErrorSnackBar('Failed to load comments');
  }
}

  // ============================================
  // ADD COMMENT TO API
  // ============================================
  // Future<void> _addComment() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   if (_commentController.text.trim().isEmpty) return;
  //   if (isSubmitting) return;

  //   setState(() => isSubmitting = true);

  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           'http://192.168.1.115:8000 /api/events/${widget.eventId}/comments/'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: 'Token$token',
  //         'Content-Type': 'application/json;charset=UTF-8',
  //         'Accept': '*/*',
  //         'Allow': 'GET, OPTIONS',
  //         'Accept-Encoding': 'gzip, deflate, br',
  //         },
  //       body: json.encode({
  //         'text': _commentController.text.trim(),
  //         'event': widget.eventId,
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       // Comment added successfully
  //       Map<String, dynamic> newCommentData = json.decode(response.body);
  //       ResultComment newComment = ResultComment.fromJson(newCommentData);

  //       setState(() {
  //         comments.insert(0, newComment);
  //         _commentController.clear();
  //         isSubmitting = false;
  //       });

  //       // Scroll to top to see new comment
  //       _scrollController.animateTo(
  //         0,
  //         duration: Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     } else {
  //       print('Failed to add comment: ${response.body} $token'); 
  //       throw Exception('Failed to add comment');
  //     }
  //   } catch (e) {
  //     print('Error adding comment: $e');
  //     setState(() => isSubmitting = false);
  //     _showErrorSnackBar('Failed to add comment');
  //   }
  // }
  Future<void> _addComment() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (_commentController.text.trim().isEmpty) return;
  if (isSubmitting) return;

  if (token == null || token.isEmpty) {
    _showErrorSnackBar('Please login first');
    return;
  }

  setState(() => isSubmitting = true);

  try {
    final response = await http.post(
      Uri.parse(
        'http://192.168.1.115:8000 /api/events/${widget.eventId}/comments/',
      ),
      headers: {
        'Authorization': 'Token $token', // IMPORTANT: space after Token
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'text': _commentController.text.trim(),
        'event': widget.eventId,
      }),
    );

    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');
    print('TOKEN = [$token]');
print('AUTH = [Token $token]');

    if (response.statusCode == 201) {
      final Map<String, dynamic> newCommentData =
          jsonDecode(response.body);

      final ResultComment newComment =
          ResultComment.fromJson(newCommentData);

      setState(() {
        comments.insert(0, newComment);
        _commentController.clear();
        isSubmitting = false;
      });

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (response.statusCode == 401) {
      setState(() => isSubmitting = false);
      _showErrorSnackBar('Session expired. Please login again.');
    } else if (response.statusCode == 403) {
      setState(() => isSubmitting = false);
      _showErrorSnackBar('You are not allowed to comment.');
    } else {
      print('Failed to add comment: ${response.body}');
      print('TOKEN = [$token]');
print('AUTH = [Token $token]');
      setState(() => isSubmitting = false);
      _showErrorSnackBar('Failed to add comment');
    }
  } catch (e) {
    print('Error adding comment: $e');

    setState(() => isSubmitting = false);
    _showErrorSnackBar('Network error. Please try again.');
  }
}

  // ============================================
  // DELETE COMMENT
  // ============================================
  Future<void> _deleteComment(int commentId) async {
     final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.delete(
        Uri.parse(
            'http://192.168.1.115:8000 /api/events/${widget.eventId}/comments/$commentId/'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json;charset=UTF-8',
          if (widget.token != null) HttpHeaders.authorizationHeader: 'Token ${token}',
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          comments.removeWhere((comment) => comment.id == commentId);
        });
        _showSuccessSnackBar('Comment deleted');
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      print('Error deleting comment: $e');
      _showErrorSnackBar('Failed to delete comment');
    }
  }

  // ============================================
  // TOGGLE LIKE
  // ============================================
  // Future<void> _toggleLike(ResultComment comment) async {
  //   // Optimistic update
  //   setState(() {
  //     comment.isLiked = !comment.isLiked;
  //     comment.likes += comment.isLiked ? 1 : -1;
  //   });

  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           'http://192.168.1.115:8000 /api/events/${widget.eventId}/comments/${comment.id}/like/'),
  //       headers: {
  //         'Content-Type': 'application/json;charset=UTF-8',
  //         if (widget.token != null) 'Authorization': 'Token ${widget.token}',
  //       },
  //     );

  //     if (response.statusCode != 200) {
  //       // Revert if failed
  //       setState(() {
  //         comment.isLiked = !comment.isLiked;
  //         comment.likes += comment.isLiked ? 1 : -1;
  //       });
  //       throw Exception('Failed to toggle like');
  //     }
  //   } catch (e) {
  //     print('Error toggling like: $e');
  //     _showErrorSnackBar('Failed to like comment');
  //   }
  // }

  // ============================================
  // HELPER METHODS
  // ============================================
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================
  // BUILD UI
  // ============================================
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildHeader(),
          Divider(height: 1, thickness: 0.5),
          Expanded(
            child: isLoading
                ? _buildLoadingIndicator()
                : comments.isEmpty
                    ? _buildEmptyState()
                    : _buildCommentList(),
          ),
          _buildCommentInput(),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  // ============================================
  // UI WIDGETS
  // ============================================

  Widget _buildDragHandle() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.comment_outlined, color: Colors.grey.shade600),
              SizedBox(width: 8),
              Text(
                'Comments (${comments.length})',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _fetchComments, // Refresh
                icon: Icon(Icons.refresh, color: Colors.grey.shade600, size: 22),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.grey.shade600, size: 24),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return _buildCommentCard(comments[index]);
      },
    );
  }

  Widget _buildCommentCard(ResultComment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(comment),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author ?? 'Unknown User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _getTimeAgo(comment.createdAt ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // _buildLikeButton(comment),
            ],
          ),
          SizedBox(height: 8),
          ReadMoreText(
            comment.text ?? '',
            trimMode: TrimMode.Line,
            trimLines: 2,
            colorClickableText: Theme.of(context).primaryColor,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          
          // Delete option - only for own comments
          if (comment.author == 'current_user_id') // Replace with actual user ID check
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => _showDeleteDialog(comment.id!),
                icon: Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarx(ResultComment comment) {
    String avatarText = comment.author?.isNotEmpty == true
        ? comment.author![0].toUpperCase()
        : '?';

    return CircleAvatar(
      backgroundColor: Colors.primaries[
          (comment.author ?? 'U').hashCode % Colors.primaries.length],
      radius: 18,
      child: Text(
        avatarText,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
  Widget _buildAvatar(ResultComment comment) {
  final String? authorPicture = comment.authorPicture;
  final String author = comment.author ?? 'U';

  if (authorPicture != null && authorPicture.isNotEmpty) {
    // Try to load the image; show text avatar on error
    return ClipOval(
      child: Image.network(
        authorPicture,
        width: 36,          // radius 18 → diameter 36
        height: 36,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to text avatar if image fails
          return _buildTextAvatar(author);
        },
      ),
    );
  } else {
    return _buildTextAvatar(author);
  }
}

// Helper to build the text-based avatar (original logic)
Widget _buildTextAvatar(String author) {
  String avatarText = author.isNotEmpty ? author[0].toUpperCase() : '?';
  return CircleAvatar(
    backgroundColor: Colors.primaries[author.hashCode % Colors.primaries.length],
    radius: 18,
    child: Text(
      avatarText,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

  // Widget _buildLikeButton(ResultComment comment) {
  //   return InkWell(
  //     onTap: () => _toggleLike(comment),
  //     child: Row(
  //       children: [
  //         Icon(
  //           comment.isLiked ? Icons.favorite : Icons.favorite_border,
  //           size: 16,
  //           color: comment.isLiked ? Colors.red : Colors.grey,
  //         ),
  //         SizedBox(width: 4),
  //         Text(
  //           comment.likes.toString(),
  //           style: TextStyle(
  //             fontSize: 12,
  //             color: Colors.grey.shade600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _commentController,
                enabled: !isSubmitting,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                maxLines: null,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addComment(),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: isSubmitting ? Colors.grey : Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: isSubmitting ? null : _addComment,
              icon: isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.send, color: Colors.white, size: 20),
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Loading comments...',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.comment_outlined, size: 60, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text(
            'No Comments Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to comment!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Comment'),
        content: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteComment(commentId);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ============================================
  // HELPER: Time Ago
  // ============================================
  String _getTimeAgo(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);

    if (diff.inDays > 365) return DateFormat('d MMM yyyy').format(dateTime);
    if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() > 1 ? 's' : ''} ago';
    }
    if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()} week${(diff.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    }
    if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }
}

// ============================================
// 3. HOW TO USE IN YOUR CARD
// ============================================
// In your buildCard function:

void _showComments(BuildContext context, int eventId, {String? token}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CommentsBottomSheet(
      eventId: eventId,
      token: token, // Optional: pass token if needed
    ),
  );
}

// Call it from your comment button:
// TextButton.icon(
//   onPressed: () => _showComments(context, data.id!, token: yourToken),
//   icon: const Icon(Icons.comment_outlined, color: Color(0xFFD32F2F), size: 20),
//   label: const Text("Comment", style: TextStyle(color: Color(0xFFD32F2F))),
// ),