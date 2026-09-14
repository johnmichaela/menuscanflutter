// import 'dart:convert';
// import 'package:ballon/comments.dart';
// import 'package:ballon/core/services/services_locator.dart';
// import 'package:ballon/models/event.dart'; // Ensure this matches your do.txt model
// import 'package:ballon/multipleImage.dart';
// import 'package:ballon/pagination/data/data_source/urls.dart';
// import 'package:ballon/pagination/ui/bloc/pagination_bloc.dart';
// import 'package:ballon/shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:readmore/readmore.dart';

// // --- THE MODEL YOU PROVIDED (do.txt) ---
// // Paste your entire EventList/ResultEvent classes here.
// // (I am omitting it for brevity, but use the exact code from your do.txt)

// class EventScreen extends StatefulWidget {
//   const EventScreen({super.key});

//   @override
//   State<EventScreen> createState() => _EventScreenState();
// }

// class _EventScreenState extends State<EventScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   bool isLoading = false;
//   bool isSubmitting = false;
//   bool hasMore = true;
//   int currentPage = 1;

//   // *** FETCH EVENTS WITH SEARCH ***
//   Future<void> _fetchEvents({int page = 1, String? searchQuery}) async {
//     if (isLoading) return;
//     setState(() => isLoading = true);

//     try {
//       // Build the URL with search query
//       String url = 'http://192.168.1.115:8000/api/events/?page=$page';
//       if (searchQuery != null && searchQuery.isNotEmpty) {
//         url += '&search=$searchQuery';
//       }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json;charset=UTF-8',
//           'Accept': '*/*',
//         },
//       );

//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseData = json.decode(response.body);
//         EventList eventList = EventList.fromJson(responseData);

//         setState(() {
//           if (page == 1) {
//             // Replace logic with your Bloc or local state
//             context.read<PaginationBlocEvent>().posts = eventList.results ?? [];
//           } else {
//             context.read<PaginationBlocEvent>().posts.addAll(eventList.results ?? []);
//           }
//           hasMore = responseData['next'] != null;
//           currentPage = page;
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load events');
//       }
//     } catch (e) {
//       print('Error fetching events: $e');
//       setState(() => isLoading = false);
//       _showSnackBar('Failed to load events', Colors.red);
//     }
//   }

//   // Toggle like for an event
//   Future<bool> toggleEventLike(int eventId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.115:8000/api/events/$eventId/like/'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['liked'] ?? false;
//       } else {
//         throw Exception('Failed to toggle like: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error toggling like: $e');
//     }
//   }

//   // Share an event
//   Future<void> shareEvent(int eventId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.115:8000/api/events/$eventId/share/'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({'platform': 'mobile'}),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final String shareText = data['description'] ?? 'Check out this event!';
//         final String shareUrl = data['share_url'] ?? '';
//         final String shareImageUrl = data['images']['image'][0] ?? '';
//         final String shareDate = data['date'] ?? '';
//         final String eventTitle = data['title'] ?? 'Event';

//         await Share.share(
//           '$shareImageUrl\n$shareDate\n\n$shareText\n\n$shareUrl',
//           subject: eventTitle,
//         );
//       } else {
//         throw Exception('Failed to share event: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error sharing event: $e');
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Trigger initial load or Bloc here
//     // _fetchEvents(page: 1);
    
//     // Setup search listener
//     _searchController.addListener(() {
//       if (_searchController.text.length > 2 || _searchController.text.isEmpty) {
//         _fetchEvents(page: 1, searchQuery: _searchController.text);
//       }
//     });
    
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         if (!isLoading && hasMore) {
//           _fetchEvents(page: currentPage + 1, searchQuery: _searchController.text);
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           lazy: false,
//           create: (_) => appServiceLocator<PaginationBlocEvent>()..add(const LoadPageEvent()),
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(255, 199, 17, 17),
//           toolbarHeight: 80,
//           elevation: 0,
//           iconTheme: const IconThemeData(color: Colors.white),
//           title: Row(
//             children: [
//               Image.asset('assets/img/white.png', height: 190, width: 190),
//               const Spacer(),
//             ],
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.notifications, color: Colors.white),
//             )
//           ],
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(60.0),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
//               child: Container(
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: const InputDecoration(
//                     hintText: 'Search events...',
//                     prefixIcon: Icon(Icons.search, color: Colors.grey),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         drawer: _buildSidebar(),
//         body: BlocBuilder<PaginationBlocEvent, PaginationState>(
//           builder: (context, state) {
//             // Simplified mock state logic based on your original code
//             if (context.read<PaginationBlocEvent>().posts.isEmpty) {
//               if (state == PaginationLoadingState()) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (state == PaginationErrorState()) {
//                 return const Center(child: Text('Error loading events'));
//               }
//             }
            
//             return ListView.builder(
//               controller: _scrollController,
//               itemCount: context.read<PaginationBlocEvent>().posts.length + (context.read<PaginationBlocEvent>().isLastPage ? 0 : 1),
//               itemBuilder: (context, index) {
//                 // Trigger more data
//                 context.read<PaginationBlocEvent>().add(CheckIfNeedMoreDataEvent(index: index));

//                 if (index == context.read<PaginationBlocEvent>().posts.length) {
//                   if (state == PaginationErrorState()) {
//                     return const Center(child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Text('Error loading more'),
//                     ));
//                   } else {
//                     return const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                 }

//                 final ResultEvent data = context.read<PaginationBlocEvent>().posts[index];
//                 return buildingCard(data);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSidebar() {
//     // ... (Copy your exact _buildSidebar code here)
//     return Drawer(child: Center(child: Text("Sidebar")));
//   }

//   Widget buildingCard(ResultEvent data) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 data.organizer!.picture != null && data.organizer!.picture!.isNotEmpty
//                     ? CircleAvatar(
//                         radius: 25,
//                         backgroundImage: NetworkImage(data.organizer!.picture!),
//                         backgroundColor: const Color(0xFFB71C1C),
//                         onBackgroundImageError: (exception, stackTrace) {
//                           // Handle error
//                         },
//                       )
//                     : CircleAvatar(
//                         radius: 25,
//                         backgroundColor: const Color(0xFFB71C1C),
//                         child: Center(
//                           child: Text(
//                             data.organizer!.name?.isNotEmpty == true ? data.organizer!.name![0].toUpperCase() : '?',
//                             style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(data.organizer!.name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Text(data.organizer!.typeBusiness!.name!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
//                           Text(". ${timeago.format(data.createdAt!)}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                           const SizedBox(width: 8),
//                           const Icon(Icons.public, size: 14, color: Colors.grey),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(Icons.more_vert, color: Colors.grey),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           MultipleImageWidget(
//             imageUrls: data.images ?? [],
//             mainTitle: data.title!,
//             mainSubtitle: data.description!,
//             showFeatured: false,
//             height: 280,
//             spacing: 4,
//             borderRadius: 12,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(children: [const Icon(Icons.calendar_today_outlined, size: 16, color: Theme.of(context).primaryColor), const SizedBox(width: 6), Text(DateFormat('d MMMM yyyy').format(data.date!), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
//                     Row(children: [Icon(Icons.access_time, size: 16, color: Theme.of(context).primaryColor), SizedBox(width: 6), Text(data.time!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
//                     Row(children: [Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).primaryColor), SizedBox(width: 6), Text(data.location!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 ReadMoreText(
//                   data.description!,
//                   trimMode: TrimMode.Line,
//                   trimLines: 2,
//                   colorClickableText: constTheme.of(context).primaryColor,
//                   trimCollapsedText: 'Show more',
//                   trimExpandedText: 'Show less',
//                   moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Theme.of(context).primaryColor),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//             child: Row(
//               children: [
//                 Row(children: [const Icon(Icons.thumb_up, size: 16, color: Colors.blue), const SizedBox(width: 2), const Icon(Icons.favorite, size: 16, color: Colors.red), const SizedBox(width: 6), Text("${data.likeCount} Likes", style: const TextStyle(fontSize: 12))]),
//                 const Spacer(),
//                 Text("${data.commentCount} Comments", style: const TextStyle(fontSize: 12)),
//                 const Spacer(),
//                 Text("${data.shareCount} Shares", style: const TextStyle(fontSize: 12)),
//               ],
//             ),
//           ),
//           const Divider(height: 1, thickness: 0.5),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton.icon(
//                   onPressed: () {
//                     toggleEventLike(data.id!);
//                   },
//                   icon: const Icon(Icons.favorite_border, color: Theme.of(context).primaryColor, size: 20),
//                   label: const Text("Like", style: TextStyle(color: Theme.of(context).primaryColor)),
//                 ),
//                 const VerticalDivider(width: 1, indent: 8, endIndent: 8),
//                 TextButton.icon(
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       backgroundColor: Colors.transparent,
//                       enableDrag: true,
//                       isDismissible: true,
//                       builder: (context) => CommentsBottomSheet(eventId: data.id!),
//                     );
//                   },
//                   icon: const Icon(Icons.comment_outlined, color: Theme.of(context).primaryColor, size: 20),
//                   label: const Text("Comment", style: TextStyle(color: Theme.of(context).primaryColor)),
//                 ),
//                 const VerticalDivider(width: 1, indent: 8, endIndent: 8),
//                 TextButton.icon(
//                   onPressed: () {
//                     shareEvent(data.id!);
//                   },
//                   icon: const Icon(Icons.share_outlined, color: Theme.of(context).primaryColor, size: 20),
//                   label: const Text("Share", style: TextStyle(color: Theme.of(context).primaryColor)),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:ballon/comments.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/multipleImage.dart';
import 'package:ballon/qr_scanner_screen.dart';
import 'package:ballon/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filterEvents);
  }

  Future<void> _loadEvents() async {
    setState(() { _isLoading = true; _errorMessage = null; });

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
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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
            const Text("Scan QR Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Integrate your mobile_scanner package here", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dark theme matching restaurant page
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 199, 17, 17),
      //   toolbarHeight: 80,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   title: Row(
      //     children: [
      //       Image.asset('assets/img/white.png', height: 190, width: 190),
      //       const Spacer(),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: _openQrScanner,
      //       icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
      //     ),
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.notifications, color: Colors.white),
      //     )
      //   ],
      //   bottom: PreferredSize(
      //     preferredSize: const Size.fromHeight(60.0),
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      //       child: Container(
      //         height: 44,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //         child: TextField(
      //           controller: _searchController,
      //           decoration: const InputDecoration(
      //             hintText: 'Search events...',
      //             prefixIcon: Icon(Icons.search, color: Colors.grey),
      //             border: InputBorder.none,
      //             contentPadding: EdgeInsets.symmetric(vertical: 12),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      drawer: _buildSidebar(),
      body:SafeArea(
        child: Column(
          children: [
              // --- SEARCH BAR AND QR ICON ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Search Input
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style:  TextStyle(color: Colors.white),
                                decoration:  InputDecoration(
                                  hintText: context.tr.searchPostsOrPlaces,
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () => _searchController.clear(),
                                child: const Icon(Icons.close, color: Colors.grey, size: 20),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // QR Scanner Button
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerScreen())),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
        
            // --- FILTER DROPDOWN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(context.tr.events, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                  DropdownButton<String>(
                    value: _currentSort,
                    dropdownColor: Theme.of(context).cardColor,
                    icon:  Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
                    underline: const SizedBox(),
                    style:  TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14),
                    items:  [
                      DropdownMenuItem(value: 'date', child: Text(context.tr.byDate)),
                      DropdownMenuItem(value: 'popularity', child: Text(context.tr.byPopularity)),
                    ],
                    onChanged: _changeSort,
                  ),
                ],
              ),
            ),
        
            // --- MAIN LIST ---
            Expanded(
              child: _isLoading && _allEvents.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null && _allEvents.isEmpty
                      ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        height: 270,
                          child:  Shimmer.fromColors(
                                      baseColor: Theme.of(context).cardColor,
                                      highlightColor: Theme.of(context).cardColor.withOpacity(0.5),
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                           physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: ((context, index) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children:[
                                                    Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(70)),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  height: 30,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                ),
                                                ]),
                                                ]),
                                                 Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  height: 90,
                                                  width: 250,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                )
                                              ],
                                            );
                                          }))),
                        )
                      : _displayedEvents.isEmpty
                          ?  Center(child: Text(context.tr.noPostsFound, style: TextStyle(color: Colors.grey)))
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              color: Theme.of(context).primaryColor,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.separated(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: _displayedEvents.length + 1,
                                separatorBuilder: (ctx, i) => const Divider(color: Color.fromARGB(0, 158, 158, 158), height: 0, thickness: 0.5),
                                itemBuilder: (context, index) {
                                  if (index >= _displayedEvents.length) {
                                    return _isLoading 
                                        ? const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Center(child: CircularProgressIndicator()),
                                          )
                                        : const SizedBox(height: 50);
                                  }
        
                                  final r = _displayedEvents[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
                                    ),
                                    child: Column(
                                      children: [
                                        // Header (Organizer)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              r.organizer!.picture != null && r.organizer!.picture!.isNotEmpty
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
                                                          r.organizer!.name?.isNotEmpty == true ? r.organizer!.name![0].toUpperCase() : '?',
                                                          style:  TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(r.organizer!.name!, style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color:Theme.of(context).textTheme.titleMedium?.color)),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Text(r.organizer!.typeBusiness!.name!, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14)),
                                                        Text(". ${timeago.format(r.createdAt!)}", style:  TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12)),
                                                        const SizedBox(width: 8),
                                                         Icon(Icons.public, size: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
  icon: Icon(
    Icons.more_vert,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  ),
  onPressed: () async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 100, 0, 0),
      items: const [
        PopupMenuItem(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.flag_outlined, size: 18),
              SizedBox(width: 8),
              Text('Report Post'),
            ],
          ),
        ),
      ],
    );

    if (selected == 'report') {
      // _showReportDialog(context);

      
    }
  },
),
                                            ],
                                          ),
                                        ),
                                        
                                        // Images
                                        MultipleImageWidget(
                                          imageUrls: r.images ?? [],
                                          mainTitle: r.title!,
                                          mainSubtitle: r.description!,
                                          showFeatured: false,
                                          height: 250,
                                          spacing: 4,
                                          borderRadius: 0,
                                        ),
                                        
                                        // Event Text Details
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(children: [ Icon(Icons.calendar_today_outlined, size: 16, color: Theme.of(context).primaryColor), const SizedBox(width: 6), Text(DateFormat('d MMMM yyyy').format(r.date!), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
                                                  Row(children: [Icon(Icons.access_time, size: 16, color: Theme.of(context).primaryColor), SizedBox(width: 6), Text(r.time!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
                                                  Row(children: [Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).primaryColor), SizedBox(width: 6), Text(r.location!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              ReadMoreText(
                                                r.description!,
                                                trimMode: TrimMode.Line,
                                                trimLines: 2,
                                                colorClickableText: Theme.of(context).primaryColor,
                                                trimCollapsedText: 'Show more',
                                                trimExpandedText: 'Show less',
                                                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Theme.of(context).primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
        
                                        // Engagement Stats
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                          child: Row(
                                            children: [
                                              Row(children: [ r.isLiked ? Icon( Icons.favorite, color: Colors.red, size: 20):Icon( Icons.favorite_border, color: Theme.of(context).textTheme.titleMedium?.color, size: 20), const SizedBox(width: 6), Text("${r.likeCount} ${context.tr.likes}", style: const TextStyle(fontSize: 12))]),
                                              const Spacer(),
                                              Text("${r.commentCount} ${context.tr.comments}", style: const TextStyle(fontSize: 12)),
                                              const Spacer(),
                                              Text("${r.shareCount} ${context.tr.shares}", style: const TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1, thickness: 0.5),
        
                                        // Action Buttons
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton.icon(
                                                onPressed: () { toggleEventLike(r.id!); },
                                                icon:  r.isLiked ? Icon( Icons.favorite, color: Colors.red, size: 20):Icon( Icons.favorite_border, color: Theme.of(context).textTheme.titleMedium?.color, size: 20),
                                                label:  Text(context.tr.like, style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
                                              ),
                                              const VerticalDivider(width: 1, indent: 8, endIndent: 8),
                                              TextButton.icon(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor: Colors.transparent,
                                                    enableDrag: true,
                                                    isDismissible: true,
                                                    builder: (context) => CommentsBottomSheet(eventId: r.id!),
                                                  );
                                                },
                                                icon:  Icon(Icons.comment_outlined, color: Theme.of(context).textTheme.titleMedium?.color, size: 20),
                                                label:  Text(context.tr.comment, style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
                                              ),
                                              const VerticalDivider(width: 1, indent: 8, endIndent: 8),
                                              TextButton.icon(
                                                onPressed: () { shareEvent(r.id!); },
                                                icon:  Icon(Icons.share_outlined, color: Theme.of(context).textTheme.titleMedium?.color, size: 20),
                                                label:  Text(context.tr.share, style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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

// --- API SERVICE FOR EVENTS ---
class ApiService {
  Future<List<ResultEvent>> fetchEventsByDate(int pageNumber) async {
    try {
      String url = 'http://192.168.1.115:8000/api/events/?page=$pageNumber';
      final response = await http.get(Uri.parse(url));
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
    try {
      String url = 'http://192.168.1.115:8000/api/events/?sort_by=likes&page=$pageNumber';
      final response = await http.get(Uri.parse(url));
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
      Uri.parse('http://192.168.1.115:8000/api/events/$eventId/like/'),
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
      Uri.parse('http://192.168.1.115:8000/api/events/$eventId/share/'),
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
      Uri.parse('http://192.168.1.115:8000/api/events/$eventId/share/'),
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
      final eventData = data['event'] ?? data; // Handle both nested and flat response
      
      // Get event details
      final String eventTitle = eventData['title'] ?? 'Event';
      final String eventDescription = eventData['description'] ?? 'Check out this event!';
      final String eventDate = eventData['date'] ?? '';
      final String eventLocation = eventData['location'] ?? '';
      final String eventImage = eventData['image'] ?? '';
      
      // Get organizer info
      final organizer = eventData['organizer'];
      final String organizerName = organizer != null ? organizer['name'] ?? '' : '';
      
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
      await Share.share(
        shareMessage,
        subject: 'Check out: $eventTitle',
      );
      
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['error'] ?? 'Unknown error occurred';
      throw Exception('Failed to share event: ${response.statusCode} - $errorMessage');
    }
  } catch (e) {
    print('Error sharing event: $e');
    throw Exception('Error sharing event: $e');
  }
}