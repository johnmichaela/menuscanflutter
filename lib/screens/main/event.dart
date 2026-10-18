import 'dart:async';
import 'dart:convert';
import 'package:ballon/comments.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/multipleImage.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:readmore/readmore.dart';
import 'package:ballon/l10n/app_strings.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<ResultEvent> _allEvents = []; // Keeps all API data
  List<ResultEvent> _displayedEvents = []; // Shows filtered list

  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  String _currentSort = 'date'; // Default sort
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;
  final ScrollController _scrollController = ScrollController();
  InternetConnectionStatus? _lastConnectionStatus;
  // final ScrollController _scrollController = ScrollController();
// Optimistic like tracking — eventId -> true/false
final Map<int, bool> _optimisticLikes = {};
// Optimistic like counts
final Map<int, int> _optimisticLikeCounts = {};
// ---------- LIKE HELPERS ----------
bool _isLiked(ResultEvent r) {
  return _optimisticLikes[r.id!] ?? (r.isLiked!);
}

int _likeCount(ResultEvent r) {
  return _optimisticLikeCounts[r.id!] ?? (r.likeCount ?? 0);
}

Future<void> _onLikeTapped(ResultEvent r) async {
  final int id = r.id!;
  final bool currentlyLiked = _isLiked(r);
  final int currentCount = _likeCount(r);

  // 1. Optimistic update — instant UI feedback
  setState(() {
    _optimisticLikes[id] = !currentlyLiked;
    _optimisticLikeCounts[id] =
        currentlyLiked ? (currentCount - 1).clamp(0, 1 << 31) : currentCount + 1;
  });

  // 2. Fire API in background
  try {
    final bool serverLiked = await toggleEventLike(id);

    if (!mounted) return;

    // Sync with server truth
    setState(() {
      if (serverLiked == currentlyLiked) {
        // Server disagrees with our optimistic flip → roll back
        _optimisticLikes[id] = serverLiked;
        _optimisticLikeCounts[id] = currentCount;
      } else {
        _optimisticLikes[id] = serverLiked;
      }
    });
  } catch (e) {
    if (!mounted) return;

    // 3. Roll back on failure + show snackbar
    setState(() {
      _optimisticLikes[id] = currentlyLiked;
      _optimisticLikeCounts[id] = currentCount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not update like. Check your connection.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
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
void _openImageViewerx(
  BuildContext context, {
  required List<String> images,
  required int initialIndex,
  String title = '',
}) {
  if (images.isEmpty) return;

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, __, ___) => _ImageViewerScreen(
        images: images,
        initialIndex: initialIndex,
        title: title,
      ),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ),
  );
}
  @override
  void initState() {
    super.initState();
    _loadEvents();
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

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<ResultEvent> fetchedData;
      if (_currentSort == 'date') {
        fetchedData = await _apiService.fetchEventsByDate(_currentPage);
      } else {
        fetchedData = await _apiService.fetchEventsByPopularity(_currentPage);
      }

      setState(() {
        if (_currentPage == 1) {
          _allEvents = fetchedData;
        } else {
          _allEvents.addAll(fetchedData);
        }
        _filterEvents(); // Apply current search filter after loading
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Filter logic based on search bar
  void _filterEvents() {
    String query = _searchController.text.toLowerCase();
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

  // Mock QR Scanner placeholder
  void _openQrScanner() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "Scan QR Code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Integrate your mobile_scanner package here",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(
//         context,
//       ).scaffoldBackgroundColor, // Dark theme matching restaurant page

//       // drawer: _buildSidebar(),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // --- SEARCH BAR AND QR ICON ---
//             // Padding(
//             //   padding: const EdgeInsets.all(12.0),
//             //   child: Row(
//             //     children: [
//             //       // Search Input
//             //       Expanded(
//             //         child: Container(
//             //           height: 50,
//             //           padding: const EdgeInsets.symmetric(horizontal: 12),
//             //           decoration: BoxDecoration(
//             //             color: Theme.of(context).cardColor,
//             //             borderRadius: BorderRadius.circular(10),
//             //           ),
//             //           child: Row(
//             //             children: [
//             //               const Icon(Icons.search, color: Colors.grey),
//             //               const SizedBox(width: 10),
//             //               Expanded(
//             //                 child: TextField(
//             //                   controller: _searchController,
//             //                   style: TextStyle(color: Colors.grey),
//             //                   decoration: InputDecoration(
//             //                     hintText: context.tr.searchPostsOrPlaces,
//             //                     hintStyle: TextStyle(
//             //                       color: Colors.grey,
//             //                       fontSize: 16,
//             //                     ),
//             //                     border: InputBorder.none,
//             //                   ),
//             //                 ),
//             //               ),
//             //               if (_searchController.text.isNotEmpty)
//             //                 GestureDetector(
//             //                   onTap: () => _searchController.clear(),
//             //                   child: const Icon(
//             //                     Icons.close,
//             //                     color: Colors.grey,
//             //                     size: 20,
//             //                   ),
//             //                 ),
//             //             ],
//             //           ),
//             //         ),
//             //       ),
//             //       const SizedBox(width: 12),
//             //       // QR Scanner Button
//             //       GestureDetector(
//             //         onTap: () => Navigator.push(
//             //           context,
//             //           MaterialPageRoute(
//             //             builder: (_) => const QrScannerScreen(),
//             //           ),
//             //         ),
//             //         child: Container(
//             //           height: 50,
//             //           width: 50,
//             //           decoration: BoxDecoration(
//             //             color: Theme.of(context).primaryColor,
//             //             borderRadius: BorderRadius.circular(10),
//             //           ),
//             //           child: const Icon(
//             //             Icons.qr_code_scanner,
//             //             color: Colors.white,
//             //             size: 28,
//             //           ),
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),

//             // --- FILTER DROPDOWN ---
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 12.0,
//                 vertical: 8.0,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     context.tr.events,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   DropdownButton<String>(
//                     value: _currentSort,
//                     dropdownColor: Theme.of(context).cardColor,
//                     icon: Icon(
//                       Icons.filter_list,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     underline: const SizedBox(),
//                     style: TextStyle(
//                       color: Theme.of(context).textTheme.bodyMedium?.color,
//                       fontSize: 14,
//                     ),
//                     items: [
//                       DropdownMenuItem(
//                         value: 'date',
//                         child: Text(context.tr.byDate),
//                       ),
//                       DropdownMenuItem(
//                         value: 'popularity',
//                         child: Text(context.tr.byPopularity),
//                       ),
//                     ],
//                     onChanged: _changeSort,
//                   ),
//                 ],
//               ),
//             ),

//             // --- MAIN LIST ---
//             Expanded(
//               child: _isLoading && _allEvents.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : _errorMessage != null && _allEvents.isEmpty
//                   ? Container(
//                       margin: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 5,
//                       ),
//                       height: 270,
//                       child: Shimmer.fromColors(
//                         baseColor: Theme.of(context).cardColor,
//                         highlightColor: Theme.of(
//                           context,
//                         ).cardColor.withOpacity(0.5),
//                         enabled: true,
//                         child: ListView.builder(
//                           itemCount: 4,
//                           physics: const NeverScrollableScrollPhysics(),
//                           scrollDirection: Axis.vertical,
//                           itemBuilder: ((context, index) {
//                             return Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       margin: EdgeInsets.symmetric(
//                                         horizontal: 5,
//                                         vertical: 10,
//                                       ),
//                                       height: 60,
//                                       width: 60,
//                                       decoration: BoxDecoration(
//                                         color: Theme.of(context).cardColor,
//                                         borderRadius: BorderRadius.circular(70),
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Container(
//                                           margin: EdgeInsets.symmetric(
//                                             horizontal: 5,
//                                             vertical: 10,
//                                           ),
//                                           height: 30,
//                                           width: 180,
//                                           decoration: BoxDecoration(
//                                             color: Theme.of(context).cardColor,
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   margin: EdgeInsets.symmetric(
//                                     horizontal: 5,
//                                     vertical: 10,
//                                   ),
//                                   height: 90,
//                                   width: 250,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).cardColor,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }),
//                         ),
//                       ),
//                     )
//                   : _displayedEvents.isEmpty
//                   ? Center(
//                       child: Text(
//                         context.tr.noPostsFound,
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     )
//                   : RefreshIndicator(
//                       onRefresh: _refresh,
//                       color: Theme.of(context).primaryColor,
//                       backgroundColor: Theme.of(
//                         context,
//                       ).scaffoldBackgroundColor,
//                       child: ListView.separated(
//                         controller: _scrollController,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         itemCount: _displayedEvents.length + 1,
//                         separatorBuilder: (ctx, i) => const Divider(
//                           color: Color.fromARGB(0, 158, 158, 158),
//                           height: 0,
//                           thickness: 0.5,
//                         ),
//                         itemBuilder: (context, index) {
//                           if (index >= _displayedEvents.length) {
//                             return _isLoading
//                                 ? const Padding(
//                                     padding: EdgeInsets.all(16.0),
//                                     child: Center(
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                   )
//                                 : const SizedBox(height: 50);
//                           }

//                           final r = _displayedEvents[index];
//                           return Container(
//                             margin: const EdgeInsets.symmetric(
//                               vertical: 2,
//                               horizontal: 9,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).cardColor,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                               children: [
//                                 // Header (Organizer)
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16.0,
//                                     vertical: 8.0,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       r.organizer!.picture != null &&
//                                               r.organizer!.picture!.isNotEmpty
//                                           ? CircleAvatar(
//                                               radius: 25,
//                                               backgroundImage: NetworkImage(
//                                                 r.organizer!.picture!,
//                                               ),
//                                               backgroundColor: Theme.of(
//                                                 context,
//                                               ).primaryColor,
//                                             )
//                                           : CircleAvatar(
//                                               radius: 25,
//                                               backgroundColor: Theme.of(
//                                                 context,
//                                               ).primaryColor,
//                                               child: Center(
//                                                 child: Text(
//                                                   r
//                                                               .organizer!
//                                                               .name
//                                                               ?.isNotEmpty ==
//                                                           true
//                                                       ? r.organizer!.name![0]
//                                                             .toUpperCase()
//                                                       : '?',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 20,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               r.organizer!.name!,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18,
//                                                 color: Theme.of(
//                                                   context,
//                                                 ).textTheme.titleMedium?.color,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 4),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   r
//                                                       .organizer!
//                                                       .typeBusiness!
//                                                       .name!,
//                                                   style: TextStyle(
//                                                     color: Theme.of(context)
//                                                         .textTheme
//                                                         .bodyMedium
//                                                         ?.color,
//                                                     fontSize: 14,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   ". ${timeago.format(r.createdAt!)}",
//                                                   style: TextStyle(
//                                                     color: Theme.of(context)
//                                                         .textTheme
//                                                         .bodyMedium
//                                                         ?.color,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 8),
//                                                 Icon(
//                                                   Icons.public,
//                                                   size: 14,
//                                                   color: Theme.of(
//                                                     context,
//                                                   ).textTheme.bodyMedium?.color,
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.more_vert,
//                                           color: Theme.of(
//                                             context,
//                                           ).textTheme.bodyMedium?.color,
//                                         ),
//                                         onPressed: () async {
//                                           final selected =
//                                               await showMenu<String>(
//                                                 context: context,
//                                                 position:
//                                                     const RelativeRect.fromLTRB(
//                                                       1000,
//                                                       100,
//                                                       0,
//                                                       0,
//                                                     ),
//                                                 items: const [
//                                                   PopupMenuItem(
//                                                     value: 'report',
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.flag_outlined,
//                                                           size: 18,
//                                                         ),
//                                                         SizedBox(width: 8),
//                                                         Text('Report Post'),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               );

//                                           if (selected == 'report') {
//                                             await bottomshetReportPost(context, r.id!);
//                                           }
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 // Images
//                                 // MultipleImageWidget(
//                                 //   imageUrls: r.images ?? [],
//                                 //   mainTitle: r.title!,
//                                 //   mainSubtitle: r.description!,
//                                 //   showFeatured: false,
//                                 //   height: 250,
//                                 //   spacing: 4,
//                                 //   borderRadius: 0,
//                                 // ),
//                                MultipleImageWidget(
//                                     imageUrls: r.images ?? [],
//                                     mainTitle: r.title ?? '',
//                                     mainSubtitle: r.description ?? '',
//                                     showFeatured: false,
//                                     height: 250,
//                                     spacing: 4,
//                                     borderRadius: 0,
//                                     onImageTap: (index) {
//                                       final urls = (r.images ?? [])
//                                           .map((img) => img.image ?? '')
//                                           .where((u) => u.isNotEmpty)
//                                           .toList();
//                                       _openImageViewer(
//                                         context,
//                                         images: urls,
//                                         initialIndex: index,
//                                         title: r.title ?? '',
//                                       );
//                                     },
//                                   ),

//                                 // Event Text Details
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 16.0,
//                                     right: 16.0,
//                                     top: 16.0,
//                                   ),
//                                   child: ReadMoreText(
//                                     r.description!,
//                                     trimMode: TrimMode.Line,
//                                     trimLines: 2,
//                                     colorClickableText: Theme.of(
//                                       context,
//                                     ).primaryColor,
//                                     trimCollapsedText: 'Show more',
//                                     trimExpandedText: 'Show less',
//                                     moreStyle: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   ),
//                                 ),

//                                 // Engagement Stats
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16.0,
//                                     vertical: 16.0,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       // Row(
//                                       //   children: [
//                                       //     r.isLiked
//                                       //         ? Icon(
//                                       //             Icons.favorite,
//                                       //             color: Colors.red,
//                                       //             size: 20,
//                                       //           )
//                                       //         : Icon(
//                                       //             Icons.favorite_border,
//                                       //             color: Theme.of(context)
//                                       //                 .textTheme
//                                       //                 .titleMedium
//                                       //                 ?.color,
//                                       //             size: 20,
//                                       //           ),
//                                       //     const SizedBox(width: 6),
//                                       //     Text(
//                                       //       "${r.likeCount} ${context.tr.likes}",
//                                       //       style: const TextStyle(
//                                       //         fontSize: 12,
//                                       //       ),
//                                       //     ),
//                                       //   ],
//                                       // ),
//                                       Row(
//   children: [
//     AnimatedSwitcher(
//       duration: const Duration(milliseconds: 200),
//       transitionBuilder: (child, anim) =>
//           ScaleTransition(scale: anim, child: child),
//       child: Icon(
//         _isLiked(r) ? Icons.favorite : Icons.favorite_border,
//         key: ValueKey(_isLiked(r)),
//         color: _isLiked(r)
//             ? Colors.red
//             : Theme.of(context).textTheme.titleMedium?.color,
//         size: 20,
//       ),
//     ),
//     const SizedBox(width: 6),
//     Text(
//       "${_likeCount(r)} ${context.tr.likes}",
//       style: const TextStyle(fontSize: 12),
//     ),
//   ],
// ),
//                                       const Spacer(),
//                                       Text(
//                                         "${r.commentCount} ${context.tr.comments}",
//                                         style: const TextStyle(fontSize: 12),
//                                       ),
//                                       const Spacer(),
//                                       Text(
//                                         "${r.shareCount} ${context.tr.shares}",
//                                         style: const TextStyle(fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const Divider(height: 1, thickness: 0.5),

//                                 // Action Buttons
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16.0,
//                                     vertical: 8.0,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                      TextButton.icon(
//                                     onPressed: () => _onLikeTapped(r),
//                                     icon: Icon(
//                                       _isLiked(r) ? Icons.favorite : Icons.favorite_border,
//                                       color: _isLiked(r)
//                                           ? Colors.red
//                                           : Theme.of(context).textTheme.titleMedium?.color,
//                                       size: 20,
//                                     ),
//                                     label: Text(
//                                       context.tr.like,
//                                       style: TextStyle(
//                                         color: _isLiked(r)
//                                             ? Colors.red
//                                             : Theme.of(context).textTheme.titleMedium?.color,
//                                         fontWeight: _isLiked(r) ? FontWeight.w600 : FontWeight.normal,
//                                       ),
//                                     ),
//                                   ),
//                                       const VerticalDivider(
//                                         width: 1,
//                                         indent: 8,
//                                         endIndent: 8,
//                                       ),
//                                       TextButton.icon(
//                                         onPressed: () {
//                                           showModalBottomSheet(
//                                             context: context,
//                                             isScrollControlled: true,
//                                             backgroundColor: Colors.transparent,
//                                             enableDrag: true,
//                                             isDismissible: true,
//                                             builder: (context) =>
//                                                 CommentsBottomSheet(
//                                                   eventId: r.id!,
//                                                 ),
//                                           );
//                                         },
//                                         icon: Icon(
//                                           Icons.comment_outlined,
//                                           color: Theme.of(
//                                             context,
//                                           ).textTheme.titleMedium?.color,
//                                           size: 20,
//                                         ),
//                                         label: Text(
//                                           context.tr.comment,
//                                           style: TextStyle(
//                                             color: Theme.of(
//                                               context,
//                                             ).textTheme.titleMedium?.color,
//                                           ),
//                                         ),
//                                       ),
//                                       const VerticalDivider(
//                                         width: 1,
//                                         indent: 8,
//                                         endIndent: 8,
//                                       ),
//                                       // TextButton.icon(
//                                       //   onPressed: () {
//                                       //     print('Start share');
//                                       //     shareEvent(r.id!);
//                                       //   },
//                                       //   icon: Icon(
//                                       //     Icons.share_outlined,
//                                       //     color: Theme.of(
//                                       //       context,
//                                       //     ).textTheme.titleMedium?.color,
//                                       //     size: 20,
//                                       //   ),
//                                       //   label: Text(
//                                       //     context.tr.share,
//                                       //     style: TextStyle(
//                                       //       color: Theme.of(
//                                       //         context,
//                                       //       ).textTheme.titleMedium?.color,
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                       TextButton.icon(
//   onPressed: () async {
//     try {
//       debugPrint('Start share for event id=${r.id}');
//       await shareEvent(r.id!);
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Share sheet opened')),
//       );
//     } catch (e, st) {
//       debugPrint('Share failed: $e\n$st');
//       print('Share failed: $e');
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Share failed: $e'),
//           backgroundColor: Colors.black,
//         ),
//       );
//     }
//   },
//   icon: Icon(
//     Icons.share_outlined,
//     color: Theme.of(context).textTheme.titleMedium?.color,
//     size: 20,
//   ),
//   label: Text(
//     context.tr.share,
//     style: TextStyle(
//       color: Theme.of(context).textTheme.titleMedium?.color,
//     ),
//   ),
// ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // --- FILTER DROPDOWN & TITLE ---
            SliverToBoxAdapter(
              child: Padding(
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
            ),

            // --- MAIN LIST STATES ---
            if (_isLoading && _allEvents.isEmpty)
              // Loading State
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null && _allEvents.isEmpty)
              // Error State (Shimmer)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  height: 270,
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).cardColor,
                    highlightColor:
                        Theme.of(context).cardColor.withOpacity(0.5),
                    enabled: true,
                    child: ListView.builder(
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
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
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 10,
                              ),
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
                ),
              )
            else if (_displayedEvents.isEmpty)
              // Empty State
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    context.tr.noPostsFound,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              // --- EVENT LIST ---
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Loading indicator at the bottom
                    if (index >= _displayedEvents.length) {
                      return _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox(height: 50);
                    }

                    final r = _displayedEvents[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 9,
                      ),
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
                          // Header (Organizer)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                r.organizer!.picture != null &&
                                        r.organizer!.picture!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          r.organizer!.picture!,
                                        ),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      )
                                    : CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Center(
                                          child: Text(
                                            r.organizer!.name?.isNotEmpty ==
                                                    true
                                                ? r.organizer!.name![0]
                                                    .toUpperCase()
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.organizer!.name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            r.organizer!.typeBusiness!.name!,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            ". ${timeago.format(r.createdAt!)}",
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
                                IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                  onPressed: () async {
                                    final selected = await showMenu<String>(
                                      context: context,
                                      position:
                                          const RelativeRect.fromLTRB(
                                            1000,
                                            100,
                                            0,
                                            0,
                                          ),
                                      items: const [
                                        PopupMenuItem(
                                          value: 'report',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.flag_outlined,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Report Post'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );

                                    if (selected == 'report') {
                                      await bottomshetReportPost(
                                          context, r.id!);
                                    }
                                  },
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

                          // Event Text Details
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 16.0,
                            ),
                            child: ReadMoreText(
                              r.description!,
                              trimMode: TrimMode.Line,
                              trimLines: 2,
                              colorClickableText:
                                  Theme.of(context).primaryColor,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),

                          // Engagement Stats
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                          milliseconds: 200),
                                      transitionBuilder: (child, anim) =>
                                          ScaleTransition(
                                              scale: anim, child: child),
                                      child: Icon(
                                        _isLiked(r)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        key: ValueKey(_isLiked(r)),
                                        color: _isLiked(r)
                                            ? Colors.red
                                            : Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${_likeCount(r)} ${context.tr.likes}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  "${r.commentCount} ${context.tr.comments}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                Text(
                                  "${r.shareCount} ${context.tr.shares}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1, thickness: 0.5),

                          // Action Buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _onLikeTapped(r),
                                  icon: Icon(
                                    _isLiked(r)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isLiked(r)
                                        ? Colors.red
                                        : Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color,
                                    size: 20,
                                  ),
                                  label: Text(
                                    context.tr.like,
                                    style: TextStyle(
                                      color: _isLiked(r)
                                          ? Colors.red
                                          : Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color,
                                      fontWeight: _isLiked(r)
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 1,
                                  indent: 8,
                                  endIndent: 8,
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: true,
                                      isDismissible: true,
                                      builder: (context) =>
                                          CommentsBottomSheet(
                                        eventId: r.id!,
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.comment_outlined,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color,
                                    size: 20,
                                  ),
                                  label: Text(
                                    context.tr.comment,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color,
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 1,
                                  indent: 8,
                                  endIndent: 8,
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    try {
                                      debugPrint(
                                          'Start share for event id=${r.id}');
                                      await shareEvent(r.id!);
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Share sheet opened')),
                                      );
                                    } catch (e, st) {
                                      debugPrint('Share failed: $e\n$st');
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Share failed: $e'),
                                          backgroundColor: Colors.black,
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.share_outlined,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color,
                                    size: 20,
                                  ),
                                  label: Text(
                                    context.tr.share,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  // +1 for the loading footer
                  childCount: _displayedEvents.length + 1,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

  // --- Sidebar Drawer ---
  Widget _buildSidebar() {
    // Copy your existing Sidebar code here
    return Drawer(child: Center(child: Text("Sidebar")));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
// ================================================================
//  REPORT POST BOTTOM SHEET
// ================================================================
Future<void> bottomshetReportPost(BuildContext context, int id) async {
  final theme = Theme.of(context);
  final bool isDark = theme.brightness == Brightness.dark;

  // -------- reason options --------
  final List<_ReportReason> reasons = const [
    _ReportReason('spam',        'Spam or misleading',      Icons.report_gmailerrorred_rounded),
    _ReportReason('harassment',  'Harassment or bullying',  Icons.person_off_rounded),
    _ReportReason('hate',        'Hate speech',             Icons.block_rounded),
    _ReportReason('violence',    'Violence or dangerous',   Icons.warning_amber_rounded),
    _ReportReason('nudity',      'Nudity or sexual content',Icons.no_adult_content_rounded),
    _ReportReason('false_info',  'False information',       Icons.fact_check_outlined),
    _ReportReason('other',       'Something else',          Icons.more_horiz_rounded),
  ];

  String? selectedReason;
  final TextEditingController noteController = TextEditingController();
  bool isSubmitting = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    builder: (sheetCtx) {
      return StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final double bottomInset = MediaQuery.of(sheetCtx).viewInsets.bottom;

          return Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetCtx).size.height * 0.9,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ---------- grip ----------
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // ---------- header ----------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(isDark ? 0.18 : 0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report Post',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                  color: theme.textTheme.titleMedium?.color,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Post #$id',   // <-- shows the post id
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(sheetCtx).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.dividerColor.withOpacity(0.3),
                  ),

                  // ---------- reasons list (scrollable) ----------
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Column(
                        children: reasons.map((r) {
                          final bool selected = selectedReason == r.key;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => setSheetState(() {
                                selectedReason = r.key;
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? theme.primaryColor.withOpacity(
                                          isDark ? 0.18 : 0.08,
                                        )
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? theme.primaryColor.withOpacity(0.35)
                                        : theme.dividerColor.withOpacity(0.25),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      r.icon,
                                      size: 20,
                                      color: selected
                                          ? theme.primaryColor
                                          : theme.textTheme.bodyMedium?.color
                                              ?.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        r.label,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: selected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: selected
                                              ? theme.primaryColor
                                              : theme.textTheme.bodyMedium
                                                  ?.color,
                                        ),
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      opacity: selected ? 1 : 0,
                                      duration:
                                          const Duration(milliseconds: 150),
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // ---------- note + submit ----------
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor.withOpacity(
                        isDark ? 0.4 : 0.5,
                      ),
                      border: Border(
                        top: BorderSide(
                          color: theme.dividerColor.withOpacity(0.25),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Note label
                        Row(
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              size: 18,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Add a note (optional)',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Note input
                        TextField(
                          controller: noteController,
                          maxLines: 3,
                          minLines: 2,
                          maxLength: 300,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Tell us more about the issue (max 300 characters)…',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.45),
                            ),
                            filled: true,
                            fillColor: theme.cardColor,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            counterStyle: TextStyle(
                              fontSize: 11,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.dividerColor.withOpacity(0.35),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.dividerColor.withOpacity(0.35),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.primaryColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Submit
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: (selectedReason == null || isSubmitting)
                                ? null
                                : () async {
                                    setSheetState(() => isSubmitting = true);

                                    try {
                                      // 🔌 TODO: replace with your real API call
                                     await ApiService().reportPost(
                                              postId: id,
                                              reason: selectedReason!,
                                              note:   noteController.text.trim(),
                                            );

                                      await Future.delayed(
                                        const Duration(milliseconds: 700),
                                      );

                                      if (!sheetCtx.mounted) return;
                                      Navigator.of(sheetCtx).pop();

                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  'Thanks — your report has been submitted.',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              Colors.green.shade700,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          duration: const Duration(
                                            seconds: 3,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!sheetCtx.mounted) return;
                                      setSheetState(() => isSubmitting = false);
                                      ScaffoldMessenger.of(sheetCtx)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Could not submit report: $e',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          backgroundColor: Colors.red.shade700,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            icon: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.send_rounded,
                                    size: 18,
                                  ),
                            label: Text(
                              isSubmitting ? 'Submitting…' : 'Submit report',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  Colors.red.withOpacity(0.3),
                              disabledForegroundColor:
                                  Colors.white.withOpacity(0.7),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// ================================================================
//  SMALL MODEL — reason option
// ================================================================
class _ReportReason {
  final String key;
  final String label;
  final IconData icon;

  const _ReportReason(this.key, this.label, this.icon);
}
// --- API SERVICE FOR EVENTS ---
class ApiService {
Future<void> reportPost({
  required int postId,
  required String reason,
  String note = '',
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final res = await http.post(
    Uri.parse('https://qopera.app/prof/api/reports/'),
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    },
    body: json.encode({
      'post':   postId,
      'reason': reason,
      'note':   note,
    }),
  );

  final body = json.decode(utf8.decode(res.bodyBytes));

  if (res.statusCode == 201) {
    return; // success
  }
  if (res.statusCode == 409) {
    throw Exception(body['error'] ?? 'You already reported this post.');
  }
  throw Exception(body['error'] ?? 'Report failed (${res.statusCode})');
}
  Future<List<ResultEvent>> fetchEventsByDate(int pageNumber) async {
    final ref = await SharedPreferences.getInstance();
    String? token = ref.getString('token');
    try {
      String url = 'https://qopera.app/api/events/?page=$pageNumber';
      final response = await http.get(Uri.parse(url), headers: {
        token?.isNotEmpty == true
            ? 'Authorization': 'Token $token'
            : ?null,
        'Content-Type': 'application/json',
      });
      print(url);
      if (response.statusCode == 200) {
        var map = jsonDecode(utf8.decode(response.bodyBytes));
        return EventList.fromJson(map).results!;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ResultEvent>> fetchEventsByPopularity(int pageNumber) async {
    final ref = await SharedPreferences.getInstance();
    String? token = ref.getString('token');

    try {
      String url =
          'https://qopera.app/api/events/?sort_by=likes&page=$pageNumber';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        token?.isNotEmpty == true
            ? 'Authorization': 'Token $token'
            : ?null,
      });
      print(url);
      if (response.statusCode == 200) {
        var map = jsonDecode(utf8.decode(response.bodyBytes));
        return EventList.fromJson(map).results!;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

// --- Helper Functions (Toggle Like & Share) ---
Future<bool> toggleEventLike(int eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  try {
    final response = await http.post(
      Uri.parse('https://qopera.app/api/events/$eventId/like/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Like toggled: $data');
      return data['liked'];
    } else {
      throw Exception('Failed to toggle like: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error toggling like: $e');
  }
}

Future<void> shareEventx(int eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  try {
    final response = await http.post(
      Uri.parse('https://qopera.app/api/events/$eventId/share/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'platform': 'mobile'}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String shareText = data['description'] ?? 'Check out this event!';
      final String shareUrl = data['share_url'] ?? '';
      final String shareImageUrl = data['images']['image'][0] ?? '';
      final String shareDate = data['date'] ?? '';
      final String eventTitle = data['title'] ?? 'Event';
      print('Event shared: $data');
      print('Sharing: $shareText, $shareUrl, $shareImageUrl, $shareDate');
      await Share.share(
        '$shareImageUrl\n$shareDate\n\n$shareText\n\n$shareUrl',
        subject: eventTitle,
      );
    } else {
      throw Exception('Failed to share event: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error sharing event: $e');
  }
}

Future<void> shareEvent(int eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('User not authenticated. Please login first.');
  }

  try {
    final response = await http.post(
      Uri.parse('https://qopera.app/api/events/$eventId/share/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'platform': 'mobile'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      print(data);
      // Extract data from the correct JSON structure
      final eventData =
          data['event'] ?? data; // Handle both nested and flat response

      // Get event details
      final String eventTitle = eventData['title'] ?? 'Event';
      final String eventDescription =
          eventData['description'] ?? 'Check out this event!';
      final String eventDate = eventData['date'] ?? '';
      final String eventLocation = eventData['location'] ?? '';
      final String eventImage = eventData['image'] ?? '';

      // Get organizer info
      final organizer = eventData['organizer'];
      final String organizerName = organizer != null
          ? organizer['name'] ?? ''
          : '';

      // Get share count from response
      final int shareCount = data['share_count'] ?? 0;

      // Build share message
      String shareMessage = '';

      // Add image if available
      if (eventImage.isNotEmpty) {
        shareMessage += '$eventImage\n\n';
      }

      // Add event details
      shareMessage += '📅 $eventTitle\n';
      if (eventDate.isNotEmpty) {
        shareMessage += '📆 Date: $eventDate\n';
      }
      if (eventLocation.isNotEmpty) {
        shareMessage += '📍 Location: $eventLocation\n';
      }
      if (organizerName.isNotEmpty) {
        shareMessage += '👤 Organizer: $organizerName\n';
      }
      shareMessage += '\n$eventDescription\n';

      // Add share count if > 0
      if (shareCount > 0) {
        shareMessage += '\n🔁 Shared $shareCount times';
      }

      // Add the event ID or URL for tracking
      shareMessage += '\n\n🎉 Event ID: $eventId';

      print('Event shared successfully!');
      print('Share count: $shareCount');

      // Share the message
      await Share.share(shareMessage, subject: 'Check out: $eventTitle');
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['error'] ?? 'Unknown error occurred';
      throw Exception(
        'Failed to share event: ${response.statusCode} - $errorMessage',
      );
    }
  } catch (e) {
    print('Error sharing event: $e');
    throw Exception('Error sharing event: $e');
  }
}

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
            // ---------- PageView of zoomable images ----------
            PageView.builder(
              controller: _pageController,
              itemCount: total,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) {
                return _ZoomableImage(
                  imageUrl: widget.images[i],
                  heroTag: 'event-image-$i-${widget.images[i]}',
                );
              },
            ),

            // ---------- Top bar ----------
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  // Close
                  _CircleIconButton(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  // Counter
                  if (total > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
                  // Spacer placeholder so counter stays centered
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // ---------- Title ----------
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

            // ---------- Page dots ----------
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

// ---------- Small round icon button ----------
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
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.close, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// ---------- Zoomable image ----------
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
      final double scale = 2.5;
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
                child: Icon(Icons.broken_image_outlined,
                    color: Colors.white54, size: 60),
              ),
            ),
          ),
        ),
      ),
    );
  }
}