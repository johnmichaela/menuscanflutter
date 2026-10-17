
import 'dart:convert';

import 'package:ballon/comments.dart';
import 'package:ballon/core/services/services_locator.dart';
import 'package:ballon/models/comment.dart';
import 'package:ballon/models/event.dart';
import 'package:ballon/multipleImage.dart';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/pagination/ui/bloc/pagination_bloc.dart';
import 'package:ballon/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:readmore/readmore.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ResultComment> comments = [];
  bool isLoading = false;
  bool isSubmitting = false;
  bool hasMore = true;
  int currentPage = 1;
  String? currentUserId; // Set this from your auth
 
 // Toggle like for an event
  Future<bool> toggleEventLike(int eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/api/events/$eventId/like/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Assuming the API returns { "liked": true/false }
        return data['liked'] ?? false;
      } else {
        throw Exception('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }
  
  // Share an event
  Future<void> shareEvent(int eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/api/events/$eventId/share/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          // Add any required data for sharing
          'platform': 'mobile',
        }),
      );
      
      if (response.statusCode == 200) {
 
        final data= json.decode(response.body);
        final String shareText = data['description'] ?? 'Check out this event!';
        final String shareUrl = data['share_url'] ?? '';
        final String shareImageUrl = data['images']['image'][0] ?? '';
        final String shareDate = data['date'] ?? '';
        final String eventTitle = data['title'] ?? 'Event';
        
        // Use share_plus to share
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
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchComments();
  //   _setupScrollListener();
  // }

  // void _setupScrollListener() {
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels >=
  //         _scrollController.position.maxScrollExtent - 200) {
  //       if (!isLoading && hasMore) {
  //         _fetchComments(page: currentPage + 1);
  //       }
  //     }
  //   });
  // }

  // // ============================================
  // // FETCH COMMENTS
  // // ============================================
  // Future<void> _fetchComments({int page = 1,int eventId}) async {
  //   if (isLoading) return;
  //   setState(() => isLoading = true);

  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //         'https://qopera.app/api/events/${eventId}/comments/?page=$page',
  //       ),
  //       headers: {
  //         'Content-Type': 'application/json;charset=UTF-8',
  //         'Accept': '*/*',
  //         // if (widget.token != null) 'Authorization': 'Token ${widget.token}',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = json.decode(response.body);

  //       List<ResultComment> fetchedComments = [];
  //       if (responseData.containsKey('results')) {
  //         List<dynamic> results = responseData['results'] ?? [];
  //         fetchedComments =
  //             results.map((item) => ResultComment.fromJson(item)).toList();
  //         hasMore = responseData['next'] != null;
  //         currentPage = page;
  //       } else if (responseData is List) {
  //         fetchedComments =
  //             responseData.map((item) => ResultComment.fromJson(item)).toList();
  //         hasMore = false;
  //       }

  //       setState(() {
  //         if (page == 1) {
  //           comments = fetchedComments;
  //         } else {
  //           comments.addAll(fetchedComments);
  //         }
  //         isLoading = false;
  //       });
  //     } else {
  //       throw Exception('Failed to load comments');
  //     }
  //   } catch (e) {
  //     print('Error fetching comments: $e');
  //     setState(() => isLoading = false);
  //     _showSnackBar('Failed to load comments', Colors.red);
  //   }
  // }

  // // ============================================
  // // ADD COMMENT
  // // ============================================
  // Future<void> _addComment() async {
  //   if (_commentController.text.trim().isEmpty) return;
  //   if (isSubmitting) return;

  //   setState(() => isSubmitting = true);

  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //         'https://qopera.app/api/events/${widget.eventId}/comments/',
  //       ),
  //       headers: {
  //         'Content-Type': 'application/json;charset=UTF-8',
  //         'Accept': '*/*',
  //         // if (widget.token != null) 'Authorization': 'Token ${widget.token}',
  //       },
  //       body: json.encode({
  //         'text': _commentController.text.trim(),
  //         'event': widget.eventId,
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       Map<String, dynamic> newCommentData = json.decode(response.body);
  //       ResultComment newComment = ResultComment.fromJson(newCommentData);

  //       setState(() {
  //         comments.insert(0, newComment);
  //         _commentController.clear();
  //         isSubmitting = false;
  //       });

  //       // Notify parent
  //       widget.onCommentAdded?.call(newComment);

  //       _scrollController.animateTo(
  //         0,
  //         duration: Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );

  //       _showSnackBar('Comment added!', Colors.green);
  //     } else {
  //       throw Exception('Failed to add comment');
  //     }
  //   } catch (e) {
  //     print('Error adding comment: $e');
  //     setState(() => isSubmitting = false);
  //     _showSnackBar('Failed to add comment', Colors.red);
  //   }
  // }

  // // ============================================
  // // DELETE COMMENT
  // // ============================================
  // Future<void> _deleteComment(int commentId) async {
  //   try {
  //     final response = await http.delete(
  //       Uri.parse(
  //         'https://qopera.app/api/events/${widget.eventId}/comments/$commentId/',
  //       ),
  //       headers: {
  //         'Content-Type': 'application/json;charset=UTF-8',
  //         // if (widget.token != null) 'Authorization': 'Token ${widget.token}',
  //       },
  //     );

  //     if (response.statusCode == 204) {
  //       setState(() {
  //         comments.removeWhere((comment) => comment.id == commentId);
  //       });

  //       // Notify parent
  //       widget.onCommentDeleted?.call(commentId);

  //       _showSnackBar('Comment deleted', Colors.green);
  //     } else {
  //       throw Exception('Failed to delete comment');
  //     }
  //   } catch (e) {
  //     print('Error deleting comment: $e');
  //     _showSnackBar('Failed to delete comment', Colors.red);
  //   }
  // }

  // // ============================================
  // // EDIT COMMENT
  // // ============================================
  // Future<void> _editComment(int commentId, String newText) async {
  //   if (newText.trim().isEmpty) return;

  //   try {
  //     final response = await http.patch(
  //       Uri.parse(
  //         'https://qopera.app/api/events/${widget.eventId}/comments/$commentId/',
  //       ),
  //       headers: {
  //         'Content-Type': 'application/json;charset=UTF-8',
  //         if (widget.token != null) 'Authorization': 'Token ${widget.token}',
  //       },
  //       body: json.encode({
  //         'text': newText.trim(),
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> updatedData = json.decode(response.body);
  //       Comment updatedComment = Comment.fromJson(updatedData);

  //       setState(() {
  //         int index = comments.indexWhere((c) => c.id == commentId);
  //         if (index != -1) {
  //           comments[index] = updatedComment;
  //         }
  //       });

  //       _showSnackBar('Comment updated', Colors.green);
  //     } else {
  //       throw Exception('Failed to update comment');
  //     }
  //   } catch (e) {
  //     print('Error editing comment: $e');
  //     _showSnackBar('Failed to update comment', Colors.red);
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) =>
                appServiceLocator<PaginationBlocEvent>()..add(const LoadPageEvent()),
          ),
          
        ],
        child:Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 17, 17),
        toolbarHeight: 80,
        elevation: 0,
        
  iconTheme: IconThemeData(color: Colors.white),
        actions: [
           IconButton(onPressed: (){}, icon: Icon(Icons.notifications,color:Colors.white))
        ],
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           
             Image.asset('assets/img/white.png',height: 190,width: 190,),
          
           
          ],
        ),
      ),
      drawer: _buildSidebar(),
     
      body: CustomScrollView(
        slivers: [
          // 1. Sticky App Bar / Header
          // SliverAppBar(
          //   expandedHeight: 80.0,
          //   floating: false,
          //   pinned: true,
          //   backgroundColor: const Color(0xFFC62828),
          //   flexibleSpace: FlexibleSpaceBar(
          //     centerTitle: true,
          //     title: const Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           "Events",
          //           style: TextStyle(
          //             fontSize: 22,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //         // Text(
          //         //   "Discover amazing events near you",
          //         //   style: TextStyle(
          //         //     fontSize: 12,
          //         //     fontWeight: FontWeight.w400,
          //         //     color: Colors.white70,
          //         //   ),
          //         // ),
          //       ],
          //     ),
          //     background: Stack(
          //       children: [
          //         // Placeholder for the Hot Air Balloon
          //         // Positioned(
          //         //   right: -20,
          //         //   top: -10,
          //         //   child: Icon(Icons.air, size: 130, color: Colors.red[900]),
          //         // ),
          //       ],
          //     ),
          //   ),
          //   leading: IconButton(
          //     icon: const Icon(Icons.menu, color: Colors.white),
          //     onPressed: () {},
          //   ),
          //   actions: [
          //     // Placeholder to balance space on the right
          //     const SizedBox(width: 50),
          //   ],
          // ),

          // 2. The Feed Content
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              
 BlocBuilder<PaginationBlocEvent, PaginationState>(
                      builder: (context, state) {
                    if (context.read<PaginationBlocEvent>().posts.isEmpty) {
                      if (state == PaginationLoadingState()) {
                        return Container(
                                  height: MediaQuery.of(context).size.height-40,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 170,
                                              width: 220,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                       
                      } else if (state == PaginationErrorState()) {
                        return Container(
                                  height: MediaQuery.of(context).size.height-40,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 170,
                                              width: 220,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                       
                      }
                    }
                    return Container(
                       height: MediaQuery.of(context).size.height-40,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount:
                              context.read<PaginationBlocEvent>().posts.length +
                                  (context.read<PaginationBlocEvent>().isLastPage
                                      ? 0
                                      : 1),
                          itemBuilder: (context, index) {
                            // request more data when the user has reached the trigger point.
                            context
                                .read<PaginationBlocEvent>()
                                .add(CheckIfNeedMoreDataEvent(index: index));
                            // when the user gets to the last item in the list, check whether
                            // there is an error, otherwise, render a progress indicator.
                            if (index ==
                                context
                                    .read<PaginationBlocEvent>()
                                    .posts
                                    .length) {
                              if (state == PaginationErrorState()) {
                                return Container(
                                  height: MediaQuery.of(context).size.height-40,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 170,
                                              width: 220,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                               
                              } else {
                                return Container(
                                   height: MediaQuery.of(context).size.height-40,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 170,
                                              width: 220,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                                
                              }
                            }
          
                            final ResultEvent data =
                                context.read<PaginationBlocEvent>().posts[index];
                            return 
                            // _bannerAd == null?
                            buildingCard(data);
                            // : AdWidget(ad: _bannerAd!);
                          }),
                    );
                  }),
             
              // --- Profile Header ---
            
            ]),
          ),
        ],
      ),),
    );
  }

  // --- Sidebar Drawer ---
  Widget _buildSidebar() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC62828),
                  Color(0xFFE53935),
                ],
              ),
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(30),
              //   bottomRight: Radius.circular(30),
              // ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "John Doe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "john.doe@email.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Premium Member",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  title: "Home",
                  onTap: () {
                    Navigator.pop(context);
                  },
                  isSelected: true,
                ),
                _buildDrawerItem(
                  icon: Icons.search_outlined,
                  title: "Search",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_border,
                  title: "Favorites",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_bag_outlined,
                  title: "Orders",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.event_outlined,
                  title: "Events",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 1),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: "Profile",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 1),
                _buildDrawerItem(
                  icon: Icons.logout_outlined,
                  title: "Logout",
                  onTap: () {
                    Navigator.pop(context);
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFFC62828),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Scan QR Code",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Scan to view menu & order",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC62828).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : (isSelected ? const Color(0xFFC62828) : Colors.grey.shade700),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : (isSelected ? const Color(0xFFC62828) : Colors.grey.shade800),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFC62828),
                borderRadius: BorderRadius.circular(2),
              ),
            )
          : (isLogout ? const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 14) : null),
      onTap: onTap,
      tileColor: isSelected ? const Color(0xFFC62828).withOpacity(0.05) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // --- Helper Widgets ---
Widget buildingCard( ResultEvent data) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 9),
    padding: EdgeInsets.symmetric(vertical: 15,),
    decoration: BoxDecoration(
      color: Colors.white,
      // borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
    ),
    child: Column(children: [   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    // Fake Logo
                    data.organizer!.picture != null && data.organizer!.picture!.isNotEmpty
                        ?
                    CircleAvatar(
                      radius: 25, 
                      backgroundImage: NetworkImage(data.organizer!.picture!),
                      backgroundColor: const Color(0xFFB71C1C),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle image loading error
                        // take firt character of the name and display it as a placeholder
                        // put fake logo with first character of the name
                        Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB71C1C),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            data.organizer!.name?.isNotEmpty == true 
                ? data.organizer!.name![0].toUpperCase() 
                : '?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
                        
                      },
                    ):  CircleAvatar(
                      radius: 25, 
                      backgroundColor: const Color(0xFFB71C1C),child:Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB71C1C),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            data.organizer!.name?.isNotEmpty == true 
                ? data.organizer!.name![0].toUpperCase() 
                : '?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),)
      ),
                   
                    const SizedBox(width: 12),
                     Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.organizer!.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                         
                          SizedBox(height: 4),
                          Row(
                            children: [
                               Text(data.organizer!.typeBusiness!.name!, style: TextStyle(color: Colors.grey, fontSize: 14)),
                              Text(". ${timeago.format(data.createdAt!)}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              SizedBox(width: 8),
                              Icon(Icons.public, size: 14, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_vert, color: Colors.grey),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
               MultipleImageWidget(imageUrls: data.images ?? [],
                mainTitle: data.title!,
                mainSubtitle: data.description!,
                showFeatured: false,
                height: 280,
                spacing: 4,
                borderRadius: 12,),
              // --- Image Collage (Main + 3 side images) ---
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: SizedBox(
              //     height: 280,
              //     child: Row(
              //       children: [
              //         // Main Image with Overlay
              //         Expanded(
              //           flex: 2,
              //           child: Stack(
              //             children: [
              //               Container(
              //                 decoration: const BoxDecoration(
              //                   borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              //                   image: DecorationImage(
              //                     image: NetworkImage('https://images.unsplash.com/photo-1544148103-0773bf10d330?q=80&w=1000&auto=format&fit=crop'),
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //               // Dark Gradient overlay
              //               Container(
              //                 decoration: const BoxDecoration(
              //                   borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              //                   gradient: LinearGradient(
              //                     begin: Alignment.topCenter,
              //                     end: Alignment.bottomCenter,
              //                     colors: [Colors.transparent, Colors.black54],
              //                   ),
              //                 ),
              //               ),
              //               // "Featured" Tag
              //               const Positioned(
              //                 top: 12,
              //                 left: 12,
              //                 child: Row(
              //                   children: [
              //                     Icon(Icons.star, size: 16, color: Colors.yellow),
              //                     SizedBox(width: 4),
              //                     Text("Featured", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              //                   ],
              //                 ),
              //               ),
              //               // Event Title Overlay
              //               const Positioned(
              //                 bottom: 16,
              //                 left: 12,
              //                 right: 12,
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text("Summer BBQ Night 🔥", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
              //                     SizedBox(height: 4),
              //                     Text("Good food, great music & unforgettable moments. Join us this weekend!", style: TextStyle(color: Colors.white70, fontSize: 11)),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         const SizedBox(width: 4),
              //         // 3 Smaller Side Images
              //         Expanded(
              //           flex: 1,
              //           child: Column(
              //             children: [
              //               Expanded(child: _buildSideImage('https://images.unsplash.com/photo-1626202311610-954b13ce6a91?q=80&w=400&auto=format&fit=crop', topRadius: true)),
              //               const SizedBox(height: 4),
              //               Expanded(child: _buildSideImage('https://images.unsplash.com/photo-1546171753-97d7676e4602?q=80&w=400&auto=format&fit=crop')),
              //               const SizedBox(height: 4),
              //               Expanded(child: _buildSideImage('https://images.unsplash.com/photo-1563805042-7684c019e1cb?q=80&w=400&auto=format&fit=crop', bottomRadius: true)),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // --- Event Text Details ---
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFFD32F2F)), const SizedBox(width: 6), Text(DateFormat('d MMMM yyyy').format(data.date!), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
                         Row(children: [Icon(Icons.access_time, size: 16, color: Color(0xFFD32F2F)), SizedBox(width: 6),  Text(data.time!, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
                         Row(children: [Icon(Icons.location_on_outlined, size: 16, color: Color(0xFFD32F2F)), SizedBox(width: 6), Text(data.location!, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ReadMoreText(
                      data.description!,
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      colorClickableText: const Color.fromARGB(255, 231, 3, 22),
                      trimCollapsedText: 'Show more',
                      
                      trimExpandedText: 'Show less',
                      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 231, 3, 22)),
                    ),
                    
                  ],
                ),
              ),

              // --- Engagement Stats ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Row(children: [const Icon(Icons.thumb_up, size: 16, color: Colors.blue), const SizedBox(width: 2), const Icon(Icons.favorite, size: 16, color: Colors.red), const SizedBox(width: 6), Text("${data.likeCount} Likes", style: const TextStyle(fontSize: 12))]),
                    const Spacer(),
                     Text("${data.commentCount} Comments", style: TextStyle(fontSize: 12)),
                    const Spacer(),
                     Text("${data.shareCount} Shares", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 0.5),

              // --- Action Buttons (Like, Comment, Share) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(onPressed: () {
                      toggleEventLike(data.id!);
                    }, icon: const Icon(Icons.favorite_border, color: Color(0xFFD32F2F), size: 20), label: const Text("Like", style: TextStyle(color: Color(0xFFD32F2F)))),
                    const VerticalDivider(width: 1, indent: 8, endIndent: 8),
                    TextButton.icon(onPressed: () {
                      showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
                enableDrag: true, // explicitly enable drag
  isDismissible: true, // explicitly enable dismiss on drag down
              builder: (context) =>  CommentsBottomSheet( eventId:data.id!,),
            );
//             showModalBottomSheet(
//   context: context,
//   isScrollControlled: true,
//   backgroundColor: Colors.transparent,
//   enableDrag: true, // explicitly enable drag
//   isDismissible: true, // explicitly enable dismiss on drag down
//   builder: (context) => DraggableScrollableSheet(
//     initialChildSize: 0.95, // Near to the top
//     minChildSize: 0.5,
//     maxChildSize: 0.95,
//     expand: false,
//     builder: (context, scrollController) {
//       return CommentsBottomSheet();
//     },
//   ),
// );
                    }, icon: const Icon(Icons.comment_outlined, color: Color(0xFFD32F2F), size: 20), label: const Text("Comment", style: TextStyle(color: Color(0xFFD32F2F)))),
                    const VerticalDivider(width: 1, indent: 8, endIndent: 8),
                    TextButton.icon(onPressed: () {shareEvent(data.id!);}, icon: const Icon(Icons.share_outlined, color: Color(0xFFD32F2F), size: 20), label: const Text("Share", style: TextStyle(color: Color(0xFFD32F2F)))),
                  ],
                ),
              ),
              // const SizedBox(height: 40), // Bottom Padding 
              ],),);
}
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFFD32F2F) : Colors.grey,
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFFD32F2F) : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }

  Widget _buildSideImage(String url, {bool topRadius = false, bool bottomRadius = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius ? 12 : 0),
          bottom: Radius.circular(bottomRadius ? 12 : 0),
        ),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
// void _showCommentsBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => DraggableScrollableSheet(
//       initialChildSize: 0.9,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: CommentsBottomSheetWithScroll(
//             // data: data,
//             scrollController: scrollController,
//           ),
//         );
//       },
//     ),
//   );
// }
// Widget CommentsBottomSheetWithScroll({ required ScrollController scrollController}) {
//   return Column(
//     children: [
//       Container(
//         width: 40,
//         height: 4,
//         margin: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(2),
//         ),
//       ),
//       Expanded(
//         child: ListView.builder(
//           controller: scrollController,
//           itemCount: 6,
//           itemBuilder: (context, index) {
//             // final comment = data.comments![index];
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(comment.user!.picture!),
//               ),
//               title: Text(comment.user!.name!),
//               subtitle: Text(comment.content!),
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }

// -------------------------------------------------------------
//                   CORE WIDGET BOTTOMSHEET
// -------------------------------------------------------------
class CommentsBottomSheetx extends StatelessWidget {
  const CommentsBottomSheetx({super.key});

  final List<Map<String, dynamic>> _comments = const [
    {
      'name': 'David Mwangi',
      'time': '2h ago',
      'avatar': 'https://i.pravatar.cc/150?u=1',
      'text': 'This place looks amazing! 🤩',
      'likes': 12,
    },
    {
      'name': 'Emma Johnson',
      'time': '1h ago',
      'avatar': 'https://i.pravatar.cc/150?u=2',
      'text': 'I\'ve been here before, the food is 🔥',
      'likes': 8,
    },
    {
      'name': 'Alex Martin',
      'time': '50m ago',
      'avatar': 'https://i.pravatar.cc/150?u=3',
      'text': 'Nice ambiance and great service.',
      'likes': 5,
    },
    {
      'name': 'Faith Peter',
      'time': '30m ago',
      'avatar': 'https://i.pravatar.cc/150?u=4',
      'text': 'Adding this to my must-visit list! 🙌',
      'likes': 3,
    },
    {
      'name': 'Brian Otieno',
      'time': '10m ago',
      'avatar': 'https://i.pravatar.cc/150?u=5',
      'text': 'Do you have vegetarian options?',
      'likes': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments (24)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: _comments.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(comment['avatar']),
                      ),
                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  comment['time'],
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['text'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Reply',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Like button & count
                      Column(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 22,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${comment['likes']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom + 8,
              top: 8,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.camera_alt_outlined, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write a comment...',
                        isDense: true,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      size: 16,
                      color: Colors.white,
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
}