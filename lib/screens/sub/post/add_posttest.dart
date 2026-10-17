// pages/event_screen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ballon/comments.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/multipleImage.dart';
import 'package:ballon/shimmer.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:readmore/readmore.dart';
import 'package:ballon/l10n/app_strings.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<ResultEvent> _allEvents = [];
  List<ResultEvent> _displayedEvents = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  String _currentSort = 'date';
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;
  final ScrollController _scrollController = ScrollController();
  InternetConnectionStatus? _lastConnectionStatus;

  /// The current user's organizer/profile id. Null until loaded.
  int? _currentProfileId;

  /// True once we've finished reading SharedPreferences — we use this
  /// to decide whether `isMine` can be trusted yet.
  bool _profileIdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterEvents);
    _connectionSubscription = InternetConnectionChecker.instance.onStatusChange
        .listen((status) {
          if (_lastConnectionStatus == InternetConnectionStatus.disconnected &&
              status == InternetConnectionStatus.connected) {
            _loadEvents();
          }
          _lastConnectionStatus = status;
        });
  }

  /// Load profile id first, then load events. This ensures `isMine`
  /// is correct on the very first render.
  Future<void> _bootstrap() async {
    await _loadCurrentProfileId();
    await _loadEvents();
  }

  Future<void> _loadCurrentProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    final raw =
        prefs.getInt('profile_id') ??
        int.tryParse(prefs.getString('profile_id') ?? '') ??
        prefs.getInt('user_id') ??
        int.tryParse(prefs.getString('user_id') ?? '');

    if (!mounted) return;
    setState(() {
      _currentProfileId = raw;
      _profileIdLoaded = true;
    });
    debugPrint('[_AddPostScreen] currentProfileId = $_currentProfileId');
  }

  // ============================================================
  // LOAD
  // ============================================================
  Future<void> _loadEvents() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedData = _currentSort == 'date'
          ? await _apiService.fetchEventsByDate(_currentPage)
          : await _apiService.fetchEventsByPopularity(_currentPage);

      if (!mounted) return;
      setState(() {
        if (_currentPage == 1) {
          _allEvents = fetchedData;
        } else {
          _allEvents.addAll(fetchedData);
        }
        _filterEvents();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayedEvents = _allEvents;
      } else {
        _displayedEvents = _allEvents.where((e) {
          return (e.title?.toLowerCase().contains(query) ?? false) ||
              (e.location?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  Future<void> _refresh() async {
    _currentPage = 1;
    await _loadEvents();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading) {
        _currentPage++;
        _loadEvents();
      }
    }
  }

  void _changeSort(String? newSort) {
    if (newSort != null && newSort != _currentSort) {
      setState(() {
        _currentSort = newSort;
        _currentPage = 1;
        _allEvents = [];
        _displayedEvents = [];
      });
      _loadEvents();
    }
  }

  // ============================================================
  // CREATE / EDIT / DELETE
  // ============================================================
  Future<void> _openCreateSheet() async {
    final created = await showModalBottomSheet<ResultEvent>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _EventFormSheet(),
    );

  //   if (created == null || !mounted) return;

  //   setState(() {
  //     _allEvents.insert(0, created);
  //     _filterEvents();
  //   });

  // await Future.delayed(const Duration(milliseconds: 300));
  // if (!mounted) return;
  if (created == null) return;
    if (!mounted) return;

    setState(() =>_allEvents.insert(0, created));
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created')),
    );
// ScaffoldMessenger.of(context)
//   ..hideCurrentSnackBar()
//   ..showSnackBar(
//     const SnackBar(
//       content: Text('Posts created successfully!'),
//       backgroundColor: Colors.green,
//       behavior: SnackBarBehavior.floating,
//     ),
//   );
    
  }

  Future<void> _openEditSheet(ResultEvent event) async {
    final updated = await showModalBottomSheet<ResultEvent>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EventFormSheet(existing: event),
    );

    if (updated == null || !mounted) return;

    setState(() {
      final idx = _allEvents.indexWhere((e) => e.id == updated.id);
      if (idx != -1) {
        _allEvents[idx] = updated;
      } else {
        _allEvents.insert(0, updated);
      }
      _filterEvents();
    });
  await Future.delayed(const Duration(milliseconds: 300));
  if (!mounted) return;

   ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    const SnackBar(
      content: Text('Post updated successfully!'),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
  }

  Future<void> _confirmDelete(ResultEvent event) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete event?'),
        content: Text('Delete "${event.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    try {
      await _apiService.deleteEvent(event.id!);
      if (!mounted) return;

      setState(() {
        _allEvents.removeWhere((e) => e.id == event.id);
        _filterEvents();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void _openComments(ResultEvent r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (_) => CommentsBottomSheet(eventId: r.id!),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          context.tr.events,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Post'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header + sort
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr.events,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _currentSort,
                    dropdownColor: Theme.of(context).cardColor,
                    icon: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).primaryColor,
                    ),
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'date',
                        child: Text(context.tr.byDate),
                      ),
                      DropdownMenuItem(
                        value: 'popularity',
                        child: Text(context.tr.byPopularity),
                      ),
                    ],
                    onChanged: _changeSort,
                  ),
                ],
              ),
            ),

            // Main list
            Expanded(
              child: !_profileIdLoaded || (_isLoading && _allEvents.isEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null && _allEvents.isEmpty
                      ? _buildShimmer()
                      : _displayedEvents.isEmpty
                          ? Center(
                              child: Text(
                                context.tr.noPostsFound,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              color: Theme.of(context).primaryColor,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.separated(
                                controller: _scrollController,
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                itemCount: _displayedEvents.length + 1,
                                separatorBuilder: (_, __) => const Divider(
                                  color: Color.fromARGB(0, 158, 158, 158),
                                  height: 0,
                                  thickness: 0.5,
                                ),
                                itemBuilder: (context, index) {
                                  if (index >= _displayedEvents.length) {
                                    return _isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          )
                                        : const SizedBox(height: 80);
                                  }

                                  final r = _displayedEvents[index];

                                  // ✅ isMine is now reliable because
                                  // _profileIdLoaded gates rendering above.
                                  final isMine =
                                      _currentProfileId != null &&
                                      r.organizer?.pk == _currentProfileId;

                                  return _EventCard(
                                    event: r,
                                    isMine: isMine,
                                    onEdit: () => _openEditSheet(r),
                                    onDelete: () => _confirmDelete(r),
                                    onLike: () => {},
                                    // _toggleLike(r),
                                    onComment: () => _openComments(r),
                                    onShare: () => _share(r),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 270,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).cardColor,
        highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
        enabled: true,
        child: ListView.builder(
          itemCount: 4,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(70),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          height: 30,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  height: 90,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------- like ----------
  // Future<void> _toggleLike(ResultEvent r) async {
  //    bool wasLiked = r.isLiked;
  //   int oldCount = r.likeCount ?? 0;

  //   setState(() {
  //     r.isLiked = !wasLiked;
  //     r.likeCount = wasLiked ? oldCount - 1 : oldCount + 1;
  //   });

  //   try {
  //     bool liked = await toggleEventLike(r.id!);
  //     if (!mounted) return;
  //     setState(() => r.isLiked = liked);
  //   } catch (e) {
  //     if (!mounted) return;
  //     setState(() {
  //       r.isLiked = wasLiked;
  //       r.likeCount = oldCount;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to like: $e')),
  //     );
  //   }
  // }

  // ---------- share ----------
  Future<void> _share(ResultEvent r) async {
    try {
      await shareEvent(r.id!);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}

// ============================================================
// EVENT CARD
// ============================================================
class _EventCard extends StatelessWidget {
  final ResultEvent event;
  final bool isMine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const _EventCard({
    required this.event,
    required this.isMine,
    required this.onEdit,
    required this.onDelete,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  void _openImageViewer(
    BuildContext context, {
    required List<String> images,
    required int initialIndex,
    String title = '',
  }) {
    if (images.isEmpty) return;
    final safeIndex = initialIndex.clamp(0, images.length - 1);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 180),
        pageBuilder: (_, __, ___) => _ImageViewerScreen(
          images: images,
          initialIndex: safeIndex,
          title: title,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  // ---------- the fixed menu ----------
  Future<void> _showMenu(BuildContext context) async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 100, 0, 0),
      items: <PopupMenuEntry<String>>[
        // const PopupMenuItem<String>(
        //   value: 'report',
        //   child: Row(
        //     children: [
        //       Icon(Icons.flag_outlined, size: 18),
        //       SizedBox(width: 8),
        //       Text('Report Post'),
        //     ],
        //   ),
        // ),
        // if (isMine)
          const PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 18),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
        
          const PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
    );

    if (selected == null) return;

    switch (selected) {
      case 'report':
        // TODO: wire report sheet here if you have one
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted')),
        );
        break;
      case 'edit':
        onEdit();
        break;
      case 'delete':
        onDelete();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = event;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                (r.organizer?.picture != null &&
                        r.organizer!.picture!.isNotEmpty)
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(r.organizer!.picture!),
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                    : CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(
                            (r.organizer?.name?.isNotEmpty == true)
                                ? r.organizer!.name![0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.organizer?.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            r.organizer?.typeBusiness?.name ?? '',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ". ${timeago.format(r.createdAt ?? DateTime.now())}",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.public,
                            size: 14,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ---------- MENU ----------
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  tooltip: 'More',
                  onPressed: () => _showMenu(context),
                ),
              ],
            ),
          ),

          // Images
          MultipleImageWidget(
            imageUrls: r.images ?? [],
            mainTitle: r.title ?? '',
            mainSubtitle: r.description ?? '',
            showFeatured: false,
            height: 250,
            spacing: 4,
            borderRadius: 0,
            onImageTap: (index) {
              final urls = (r.images ?? [])
                  .map((img) => img.image ?? '')
                  .where((u) => u.isNotEmpty)
                  .toList();
              _openImageViewer(
                context,
                images: urls,
                initialIndex: index,
                title: r.title ?? '',
              );
            },
          ),

          // Title + description
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (r.title != null && r.title!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      r.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (r.description != null && r.description!.isNotEmpty)
                  ReadMoreText(
                    r.description!,
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                    colorClickableText: Theme.of(context).primaryColor,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ),

          // Engagement stats
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      (r.isLiked ?? false)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: (r.isLiked ?? false)
                          ? Colors.red
                          : Theme.of(context).textTheme.titleMedium?.color,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${r.likeCount ?? 0} ${context.tr.likes}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "${r.commentCount ?? 0} ${context.tr.comments}",
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                Text(
                  "${r.shareCount ?? 0} ${context.tr.shares}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),

          // Action row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: onLike,
                  icon: Icon(
                    (r.isLiked ?? false)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: (r.isLiked ?? false)
                        ? Colors.red
                        : Theme.of(context).textTheme.titleMedium?.color,
                    size: 20,
                  ),
                  label: Text(
                    context.tr.like,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, indent: 8, endIndent: 8),
                TextButton.icon(
                  onPressed: onComment,
                  icon: Icon(
                    Icons.comment_outlined,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    size: 20,
                  ),
                  label: Text(
                    context.tr.comment,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, indent: 8, endIndent: 8),
                TextButton.icon(
                  onPressed: onShare,
                  icon: Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    size: 20,
                  ),
                  label: Text(
                    context.tr.share,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EVENT FORM SHEET (create + edit)
// ============================================================
class _EventFormSheet extends StatefulWidget {
  final ResultEvent? existing;
  const _EventFormSheet({this.existing});

  @override
  State<_EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends State<_EventFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _attendeesCtrl = TextEditingController(text: '0');

  DateTime? _date;
  bool _isFeatured = false;
  bool _submitting = false;

  final List<File> _newImages = [];
  final List<String> _existingImages = [];
  final ImagePicker _picker = ImagePicker();

  final ApiService _api = ApiService();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _titleCtrl.text = e.title ?? '';
      _descCtrl.text = e.description ?? '';
      _locationCtrl.text = e.location ?? '';
      _timeCtrl.text = e.time ?? '';
      _categoryCtrl.text = e.category ?? '';
      _attendeesCtrl.text = (e.attendees ?? 0).toString();
      _date = e.date;
      _isFeatured = e.isFeatured ?? false;
      _existingImages.addAll(
        (e.images ?? []).map((i) => i.image ?? '').where((u) => u.isNotEmpty),
      );
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _timeCtrl.dispose();
    _categoryCtrl.dispose();
    _attendeesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1400,
    );
    if (picked.isEmpty) return;
    setState(() {
      for (final p in picked) {
        _newImages.add(File(p.path));
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
     final navigator = Navigator.of(context);
    try {
      final ResultEvent result;
      if (_isEdit) {
        result = await _api.updateEvent(
          id: widget.existing!.id!,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          time: _timeCtrl.text.trim(),
          attendees: int.tryParse(_attendeesCtrl.text.trim()) ?? 0,
          isFeatured: _isFeatured,
          date: _date,
          newImages: _newImages,
          keepImageUrls: _existingImages,
        );
      } else {
        result = await _api.createEvent(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          time: _timeCtrl.text.trim(),
          attendees: int.tryParse(_attendeesCtrl.text.trim()) ?? 0,
          isFeatured: _isFeatured,
          date: _date,
          imageFiles: _newImages,
        );
      }
      // Navigator.of(context).pop();
      if (!mounted) return;
      Navigator.of(context).pop(result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_isEdit ? "Update" : "Create"} failed: $e',
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isEdit ? 'Edit Post' : 'Add New Post',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _categoryCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Conference, Concert, Workshop...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Featured'),
                  subtitle: const Text('Highlight this event'),
                  value: _isFeatured,
                  activeColor: theme.primaryColor,
                  onChanged: (v) => setState(() => _isFeatured = v),
                ),
                const SizedBox(height: 12),

                // Images
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade600),
                    ),
                    child: (_existingImages.isEmpty && _newImages.isEmpty)
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 28,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Add images',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            itemCount: _existingImages.length +
                                _newImages.length +
                                1,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final total =
                                  _existingImages.length + _newImages.length;
                              if (i == total) {
                                return GestureDetector(
                                  onTap: _pickImages,
                                  child: Container(
                                    width: 84,
                                    decoration: BoxDecoration(
                                      color: theme.scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }
                              final isExisting = i < _existingImages.length;
                              final imageWidget = isExisting
                                  ? Image.network(
                                      _existingImages[i],
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 84,
                                        height: 84,
                                        color: Colors.grey.shade800,
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      _newImages[i - _existingImages.length],
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
                                    );

                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageWidget,
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isExisting) {
                                            _existingImages.removeAt(i);
                                          } else {
                                            _newImages.removeAt(
                                              i - _existingImages.length,
                                            );
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isEdit ? 'Update Event' : 'Create Event',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// API SERVICE
// ============================================================
class ApiService {
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  Future<List<ResultEvent>> fetchEventsByDate(int pageNumber) async {
    final headers = await _authHeaders();
    final url = '${Urls.baseUrl}/prof/api/my-events/?page=$pageNumber';
    final response = await http.get(Uri.parse(url), headers: headers);
    debugPrint('GET $url -> ${response.statusCode}');
    if (response.statusCode == 200) {
      final map = jsonDecode(utf8.decode(response.bodyBytes));
      return EventList.fromJson(map).results!;
    }
    throw Exception("Error: ${response.statusCode}");
  }

  Future<List<ResultEvent>> fetchEventsByPopularity(int pageNumber) async {
    final headers = await _authHeaders();
    final url =
        '${Urls.baseUrl}/prof/api/my-events/?sort_by=likes&page=$pageNumber';
    final response = await http.get(Uri.parse(url), headers: headers);
    debugPrint('GET $url -> ${response.statusCode}');
    if (response.statusCode == 200) {
      final map = jsonDecode(utf8.decode(response.bodyBytes));
      return EventList.fromJson(map).results!;
    }
    throw Exception("Error: ${response.statusCode}");
  }

  Future<ResultEvent> createEvent({
    required String title,
    required String description,
    required String location,
    required String category,
    required String time,
    required int attendees,
    required bool isFeatured,
    DateTime? date,
    List<File> imageFiles = const [],
  }) async {
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/events/create');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _authHeaders());

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['location'] = location;
    request.fields['category'] = category;
    request.fields['time'] = time;
    request.fields['attendees'] = attendees.toString();
    request.fields['is_featured'] = isFeatured.toString();
    if (date != null) {
      request.fields['date'] = DateFormat('yyyy-MM-dd').format(date);
    }

    for (final file in imageFiles) {
      request.files.add(await _imagePart(file));
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    debugPrint('CREATE -> ${res.statusCode}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      final json = jsonDecode(utf8.decode(res.bodyBytes));
      return ResultEvent.fromJson(Map<String, dynamic>.from(json));
    }
    throw Exception('Failed to create (${res.statusCode}): ${res.body}');
  }

  Future<ResultEvent> updateEvent({
    required int id,
    required String title,
    required String description,
    required String location,
    required String category,
    required String time,
    required int attendees,
    required bool isFeatured,
    DateTime? date,
    List<File> newImages = const [],
    List<String> keepImageUrls = const [],
  }) async {
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/posts/update/$id');
    final request = http.MultipartRequest('PATCH', uri);
    request.headers.addAll(await _authHeaders());

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['location'] = location;
    request.fields['category'] = category;
    request.fields['time'] = time;
    request.fields['attendees'] = attendees.toString();
    request.fields['is_featured'] = isFeatured.toString();
    if (date != null) {
      request.fields['date'] = DateFormat('yyyy-MM-dd').format(date);
    }
    request.fields['keep_image_urls'] = jsonEncode(keepImageUrls);

    for (final file in newImages) {
      request.files.add(await _imagePart(file));
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    debugPrint('UPDATE -> ${res.statusCode}');
    if (res.statusCode == 200) {

      final json = jsonDecode(utf8.decode(res.bodyBytes));
      return ResultEvent.fromJson(Map<String, dynamic>.from(json));
    }
    
    throw Exception('Failed to update (${res.statusCode}): ${res.body}');
  }

  /// DELETE — uses the URL your backend actually exposes.
  Future<void> deleteEvent(int id) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/posts/delete/$id');
    final res = await http.delete(uri, headers: headers);
    debugPrint('DELETE $uri -> ${res.statusCode}');
    if (res.statusCode == 200 || res.statusCode == 204) return;

    // Try to parse an error message
    try {
      final body = json.decode(utf8.decode(res.bodyBytes));
      throw Exception(body['error'] ?? 'Delete failed (${res.statusCode})');
    } catch (_) {
      throw Exception('Delete failed (${res.statusCode})');
    }
  }

  Future<http.MultipartFile> _imagePart(File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    final mime = (ext == 'png')
        ? 'png'
        : (ext == 'webp')
            ? 'webp'
            : 'jpeg';
    return http.MultipartFile.fromPath(
      'images',
      file.path,
      contentType: MediaType('image', mime),
    );
  }
}

// ============================================================
// Helper functions
// ============================================================
Future<bool> toggleEventLike(int eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  final response = await http.post(
    Uri.parse('${Urls.baseUrl}/api/events/$eventId/like/'),
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['liked'] == true;
  }
  throw Exception('Failed to toggle like: ${response.statusCode}');
}

Future<void> shareEvent(int eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  if (token == null) throw Exception('User not authenticated.');

  final response = await http.post(
    Uri.parse('${Urls.baseUrl}/api/events/$eventId/share/'),
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    },
    body: json.encode({'platform': 'mobile'}),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body);
    final eventData = data['event'] ?? data;
    final eventTitle = eventData['title'] ?? 'Event';
    final eventDescription =
        eventData['description'] ?? 'Check out this event!';
    final eventDate = eventData['date'] ?? '';
    final eventLocation = eventData['location'] ?? '';
    final eventImage = eventData['image'] ?? '';
    final organizer = eventData['organizer'];
    final organizerName = organizer != null ? organizer['name'] ?? '' : '';
    final shareCount = data['share_count'] ?? 0;

    String shareMessage = '';
    if (eventImage.isNotEmpty) shareMessage += '$eventImage\n\n';
    shareMessage += '📅 $eventTitle\n';
    if (eventDate.isNotEmpty) shareMessage += '📆 Date: $eventDate\n';
    if (eventLocation.isNotEmpty) {
      shareMessage += '📍 Location: $eventLocation\n';
    }
    if (organizerName.isNotEmpty) {
      shareMessage += '👤 Organizer: $organizerName\n';
    }
    shareMessage += '\n$eventDescription\n';
    if (shareCount > 0) shareMessage += '\n🔁 Shared $shareCount times';
    shareMessage += '\n\n🎉 Event ID: $eventId';

    await Share.share(shareMessage, subject: 'Check out: $eventTitle');
  } else {
    final errorBody = json.decode(response.body);
    final errorMessage = errorBody['error'] ?? 'Unknown error occurred';
    throw Exception(
      'Failed to share event: ${response.statusCode} - $errorMessage',
    );
  }
}

// ============================================================
// IMAGE VIEWER (unchanged)
// ============================================================
class _ImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const _ImageViewerScreen({
    required this.images,
    required this.initialIndex,
    this.title = '',
  });

  @override
  State<_ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<_ImageViewerScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int total = widget.images.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: total,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) => _ZoomableImage(
                imageUrl: widget.images[i],
                heroTag: 'event-image-$i-${widget.images[i]}',
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  if (total > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const Spacer(),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            if (widget.title.isNotEmpty)
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (total > 1 && total <= 10)
              Positioned(
                bottom: widget.title.isNotEmpty ? 60 : 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(total, (i) {
                    final active = i == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _ZoomableImage extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;

  const _ZoomableImage({required this.imageUrl, this.heroTag});

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late AnimationController _animController;
  late Animation<Matrix4> _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _animController.addListener(() {
      _controller.value = _animation.value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final position = _doubleTapDetails?.localPosition;
    if (position == null) return;

    final bool zoomedIn = _controller.value.getMaxScaleOnAxis() > 1.5;
    final Matrix4 end;
    if (zoomedIn) {
      end = Matrix4.identity();
    } else {
      const double scale = 2.5;
      end = Matrix4.identity()
        ..translate(-position.dx * (scale - 1), -position.dy * (scale - 1))
        ..scale(scale);
    }

    _animation = Matrix4Tween(begin: _controller.value, end: end).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (d) => _doubleTapDetails = d,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1.0,
        maxScale: 4.0,
        child: Center(
          child: Hero(
            tag: widget.heroTag ?? widget.imageUrl,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                final total = progress.expectedTotalBytes;
                final double? value = total != null
                    ? progress.cumulativeBytesLoaded / total
                    : null;
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: value,
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => const Padding(
                padding: EdgeInsets.all(24),
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 60,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}