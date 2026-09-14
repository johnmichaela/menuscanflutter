// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'app_state.dart';
// import 'models.dart';
// import 'event_create_screen.dart';
// import 'dashboard.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   @override

//   void initState() {
//     super.initState();
//     // Load events from the backend to display them in the app.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final app = Provider.of<AppState>(context, listen: false);
//       app.loadEvents();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final app = Provider.of<AppState>(context);
//     // Show demo events while the app is still loading from the backend.
//     final isLoading = !app.eventsLoaded;
//     final events = isLoading ? _demoEvents() : app.events;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FB),
//       body: Stack(
//         children: [
//           // 1. MAIN SCROLLABLE CONTENT (with pull-to-refresh)
//           RefreshIndicator(
//             onRefresh: () async => await app.loadEvents(),
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.only(bottom: 120), // Space for floating nav
//               child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeaderSection(
//                   onCreate: app.isLoggedIn
//                       ? () => _openCreateEvent(context)
//                       : () => _promptLogin(context),
//                 ),
//                 const SizedBox(height: 16),
//                 // 2. FILTER BAR
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: _buildFilterBar(),
//                 ),
//                 const SizedBox(height: 24),
//                 // My Events shortcut
//                 if (app.isLoggedIn) ...[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: _buildMyEventsStrip(context),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//                 // 3. EVENTS LIST
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                       children: [
//                         if (isLoading)
//                           const SizedBox(
//                             height: 200,
//                             child: Center(child: CircularProgressIndicator()),
//                           ),
//                         if (!isLoading)
//                           if (events.isEmpty)
//                             _buildEmptyState(context)
//                           else
//                             for (int i = 0; i < events.length; i++) ...[
//                               _buildEventCard(
//                                 event: events[i],
//                                 index: i,
//                                 onCreate: app.isLoggedIn
//                                     ? () => _openCreateEvent(context)
//                                     : () => _promptLogin(context),
//                               ),
//                               const SizedBox(height: 20),
//                             ],
//                       ],
//                   ),
//                 ),
//               ],
//               ),
//             ),
//           ),

//           // 4. FLOATING BOTTOM NAVIGATION (WITH CUSTOM PAINTER FOR THE GAP)
//           // Positioned(
//           //   bottom: 30,
//           //   left: 20,
//           //   right: 20,
//           //   child: Container(
//           //     height: 75,
//           //     decoration: BoxDecoration(
//           //       color: Colors.white,
//           //       borderRadius: BorderRadius.circular(30),
//           //       boxShadow: [
//           //         BoxShadow(
//           //           color: Colors.black.withOpacity(0.06),
//           //           blurRadius: 20,
//           //           offset: const Offset(0, 10),
//           //         ),
//           //       ],
//           //     ),
//           //     child: Stack(
//           //       clipBehavior: Clip.none,
//           //       children: [
//           //         // The background shape with a cutout for the plus button
//           //         Positioned.fill(
//           //           child: CustomPaint(
//           //             painter: BottomNavPainter(),
//           //           ),
//           //         ),
//           //         // Navigation Items Row
//           //         Row(
//           //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //           children: [
//           //             _buildNavItem(Icons.home_rounded, 'Home', 0, isActive: true),
//           //             _buildNavItem(Icons.explore_outlined, 'Explore', 1),
//           //             const SizedBox(width: 40), // Gap for the button
//           //             _buildNavItem(Icons.bookmarks_outlined, 'Bookmarks', 2),
//           //             _buildNavItem(Icons.person_outline, 'Profile', 3),
//           //           ],
//           //         ),
//           //         // The Big Red Plus Button
//           //         Positioned(
//           //           top: -20,
//           //           left: 0,
//           //           right: 0,
//           //           child: Center(
//           //             child: GestureDetector(
//           //               onTap: app.isLoggedIn
//           //                   ? () => _openCreateEvent(context)
//           //                   : () => _promptLogin(context),
//           //               child: Container(
//           //                 width: 65,
//           //                 height: 65,
//           //                 decoration: BoxDecoration(
//           //                   color: const Color(0xFFE53935),
//           //                   shape: BoxShape.circle,
//           //                   boxShadow: [
//           //                     BoxShadow(
//           //                       color: const Color(0xFFE53935).withOpacity(0.3),
//           //                       blurRadius: 10,
//           //                       offset: const Offset(0, 5),
//           //                     ),
//           //                   ],
//           //                 ),
//           //                 child: const Icon(Icons.add, color: Colors.white, size: 35),
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   void _openCreateEvent(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const EventCreateScreen()),
//     );
//   }

//   void _promptLogin(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please login to create an event')),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index, {bool isActive = false}) {
//     return GestureDetector(
//       onTap: () => setState(() => _selectedIndex = index),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: (isActive || _selectedIndex == index) ? const Color(0xFFE53935) : Colors.grey[400],
//             size: 26,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: (isActive || _selectedIndex == index) ? const Color(0xFFE53935) : Colors.grey[400],
//               fontSize: 12,
//               fontWeight: (isActive || _selectedIndex == index) ? FontWeight.w600 : FontWeight.w400,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderSection({required VoidCallback onCreate}) {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 30),
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/img/background.png'), // Faint crowd background
//           fit: BoxFit.cover,
//           // opacity: 0.08,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top Right Icons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Events",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w800,
//                   color: Color(0xFF0D1B3E),
//                 ),
//               ),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen())),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//                           child: const Icon(Icons.notifications_none_rounded, size: 26, color: Color(0xFF0D1B3E)),
//                         ),
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
//                             child: const Text('6', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const CircleAvatar(
//                     radius: 20,
//                     backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Text(
//             "",
//             style: TextStyle(
//               fontSize: 26,
//               fontWeight: FontWeight.w800,
//               // color: const Color.fromARGB(255, 249, 249, 250),
//               height: 1.1,
//               letterSpacing: -0.5,
//               foreground:  Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2                  // Thickness of the outline
//           ..color = const Color.fromARGB(255, 251, 252, 253),
//             ),
//           ),
//           const Text.rich(
//             TextSpan(
//               children: [
//                 TextSpan(text: "", style: TextStyle(color: Color.fromARGB(255, 242, 243, 245), fontSize: 14, height: 1.6, fontWeight: FontWeight.w400)),
//               ],
//             ),
//           ),
//           // Hot Air Balloon Graphic (Overlapping)
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Transform.translate(
//               offset: const Offset(0, -50),
//               child: Image.asset('assets/img/white-logo.png', // Balloon icon
//                 height: 60,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 6)),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on_outlined, color: Color(0xFF0D1B3E), size: 20),
//           const SizedBox(width: 6),
//           const Text("All Locations", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0D1B3E))),
//           const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF0D1B3E)),
//           const Spacer(),
//           // Active Button (Red)
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE53935),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Text("All Events", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
//           ),
//           const SizedBox(width: 16),
//           // Category Buttons
//           const Icon(Icons.person_outline, size: 22, color: Color(0xFF0D1B3E)),
//           const SizedBox(width: 16),
//           const Icon(Icons.face, size: 22, color: Color(0xFF0D1B3E)),
//           const SizedBox(width: 16),
//           const Icon(Icons.group_outlined, size: 22, color: Color(0xFF0D1B3E)),
//           const SizedBox(width: 16),
//           // Filter Button
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.white,
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.filter_list, size: 18, color: Color(0xFF0D1B3E)),
//                 SizedBox(width: 6),
//                 Text("Filter", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0D1B3E))),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildMyEventsStrip(BuildContext context) {
//     return GestureDetector(
//       onTap: () => ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Your events')),
//       ),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
//         ),
//         child: const Row(
//           children: [
//             Icon(Icons.event_note, color: Color(0xFFE53935)),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 "My Events",
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF0D1B3E)),
//               ),
//             ),
//             Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     final app = Provider.of<AppState>(context, listen: false);
//     return Container(
//       padding: const EdgeInsets.all(32),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.event_busy, size: 60, color: Colors.grey),
//           const SizedBox(height: 16),
//           const Text(
//             'No events yet',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0D1B3E)),
//           ),
//           const SizedBox(height: 6),
//           const Text(
//             'Be the first to create an event! Tap the + button.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Color(0xFF6C757D), fontSize: 14),
//           ),
//           const SizedBox(height: 12),
//           if (app.eventsLoaded)
//             ElevatedButton.icon(
//               onPressed: () async => await app.loadEvents(),
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventCard({
//     required EventModel event,
//     required int index,
//     required VoidCallback onCreate,
//   }) {
//     final defaultImages = [
//       'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=1000&auto=format&fit=crop',
//       'https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=1000&auto=format&fit=crop',
//       'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=1000&auto=format&fit=crop',
//     ];
//     final imageUrl = event.image.isNotEmpty ? event.image : defaultImages[index % defaultImages.length];

//     return Container(
//       decoration: BoxDecoration(
//         // color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6)),
//         ],
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image Section
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: SizedBox(
//               width: 180,
//               height: 160,
//               child: Stack(
//                 children: [
//                   Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey)))),
//                   // Tag
//                   if (event.isFeatured)
//                     Positioned(
//                       top: 10,
//                       left: 10,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE53935),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.star_rounded, color: Colors.white, size: 12),
//                             SizedBox(width: 4),
//                             Text('Featured', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   // Date Box
//                   Positioned(
//                     top: 10,
//                     right: 10,
//                     child: Container(
//                       width: 44,
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
//                       ),
//                       child: Column(
//                         children: [
//                           Text(event.dateDay, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0D1B3E))),
//                           Text(event.dateMonth, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           // Content Section
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(event.category, style: const TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w700, fontSize: 13)),
//                     const Icon(Icons.favorite_border_rounded, color: Color(0xFF0D1B3E), size: 24),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(event.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Color(0xFF0D1B3E))),
//                 const SizedBox(height: 8),
//                 // Info Rows
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF0D1B3E)),
//                     const SizedBox(width: 4),
//                     Expanded(child: Text(event.location.isNotEmpty ? event.location : 'Venue TBD', style: const TextStyle(color: Color(0xFF6C757D), fontSize: 12))),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF0D1B3E)),
//                     const SizedBox(width: 4),
//                     Text(event.time.isNotEmpty ? event.time : 'All day', style: const TextStyle(color: Color(0xFF6C757D), fontSize: 12)),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(event.description, style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D), height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 12),
//                 // Attendees
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 50, height: 20,
//                       child: Stack(
//                         children: [
//                           const Positioned(left: 0, child: CircleAvatar(radius: 10, backgroundColor: Colors.redAccent)),
//                           const Positioned(left: 14, child: CircleAvatar(radius: 10, backgroundColor: Colors.blueAccent)),
//                           const Positioned(left: 28, child: CircleAvatar(radius: 10, backgroundColor: Colors.greenAccent)),
//                           Positioned(left: 42, child: CircleAvatar(radius: 10, backgroundColor: Colors.grey[200], child: const Icon(Icons.add, size: 12, color: Colors.grey))),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text('+${event.attendees} going', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF6C757D))),
//                      InkWell(
//                       onTap: () => _onAttend(context, event),
//                       borderRadius: BorderRadius.circular(8),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
//                         child: Row(
//                           children: [
//                             Icon(
//                               event.isAttending ? Icons.event_available : Icons.event_outlined,
//                               size: 20,
//                               color: event.isAttending ? const Color(0xFFE53935) : const Color(0xFF0D1B3E),
//                             ),
//                             const SizedBox(width: 6),
//                             Text('${event.attendeeCount}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0D1B3E))),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Action Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () => _onLike(context, event),
//                       borderRadius: BorderRadius.circular(8),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
//                         child: Row(
//                           children: [
//                             Icon(
//                               event.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
//                               size: 20,
//                               color: event.isLiked ? const Color(0xFFE53935) : const Color(0xFF0D1B3E),
//                             ),
//                             const SizedBox(width: 6),
//                             Text('${event.likeCount}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0D1B3E))),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     InkWell(
//                       onTap: () => _openComments(context, event),
//                       borderRadius: BorderRadius.circular(8),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Color(0xFF0D1B3E)),
//                             const SizedBox(width: 6),
//                             Text('${event.commentCount}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0D1B3E))),
//                           ],
//                         ),
//                       ),
//                     ),
// const SizedBox(width: 16),
                   
//                     const Spacer(),
//                     TextButton.icon(
//                       onPressed: () => _shareEvent(context, event),
//                       icon: const Icon(Icons.share_outlined, size: 16, color: Color(0xFF0D1B3E)),
//                       label: const Text("Share", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0D1B3E))),
//                       style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Toggles the like state of an event. Prompts login if the user is not
//   /// logged in.
//   void _onLike(BuildContext context, EventModel event) {
//     final app = Provider.of<AppState>(context, listen: false);
//     if (!app.isLoggedIn) {
//       _promptLogin(context);
//       return;
//     }
//     app.toggleEventLike(event);
//   }

//   /// Toggles the logged-in user's attendance for an event.
//   void _onAttend(BuildContext context, EventModel event) {
//     final app = Provider.of<AppState>(context, listen: false);
//     if (!app.isLoggedIn) {
//       _promptLogin(context);
//       return;
//     }
//     app.toggleEventAttend(event);
//   }

//   /// Opens a bottom sheet listing comments and allowing the user to add one.
//   void _openComments(BuildContext context, EventModel event) {
//     final app = Provider.of<AppState>(context, listen: false);
//     // Load fresh comments from the backend.
//     app.loadEventComments(event);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => CommentSheet(eventId: event.id),
//     );
//   }

// /// Shares the event details via the native share sheet and records the share
// /// on the backend so the web admin can see who shared the event.
//   Future<void> _shareEvent(BuildContext context, EventModel event) async {
//     final app = Provider.of<AppState>(context, listen: false);
//     final message = [
//       event.title,
//       if (event.location.isNotEmpty) '📍 ${event.location}',
//       if (event.time.isNotEmpty) '🕒 ${event.time}',
//       if (event.date != null && event.date!.isNotEmpty) '📅 ${event.date}',
//       if (event.description.isNotEmpty) event.description,
//     ].join('\n');
// try {
//       await Share.share(message);
//       // Record the share on the backend so the web admin can see who shared.
//       if (app.isLoggedIn) {
//         app.shareEvent(event, shareMethod: 'system');
//       }
//     } catch (_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Unable to share event')),
//       );
//     }
//   }

//   /// Demo fallback events used when the backend is unreachable.
//   List<EventModel> _demoEvents() {
//     return [
//       EventModel(
//         id: 1,
//         title: 'Summer Beats Concert',
//         location: 'Mlimani City, Dar es Salaam',
//         time: '6:00 PM – 11:00 PM',
//         image: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=1000&auto=format&fit=crop',
//         category: 'Music',
//         description: 'An unforgettable night of live music featuring top local and international artists.',
//         attendees: 128,
//         isFeatured: true,
//         date: '2025-05-24',
//       ),
//       EventModel(
//         id: 2,
//         title: 'Kids Fun Carnival',
//         location: 'Botanical Gardens, Dar es Salaam',
//         time: '10:00 AM – 4:00 PM',
//         image: 'https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=1000&auto=format&fit=crop',
//         category: 'Family',
//         description: 'Fun games, face painting, magic shows and lots of surprises for the little ones!',
//         attendees: 89,
//         date: '2025-05-25',
//       ),
//       EventModel(
//         id: 3,
//         title: 'Street Food Festival',
//         location: 'Slipway, Dar es Salaam',
//         time: '4:00 PM – 10:00 PM',
//         image: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=1000&auto=format&fit=crop',
//         category: 'Food & Drink',
//         description: 'Taste the best street food from around the city with live entertainment!',
//         attendees: 156,
//         date: '2025-05-28',
//       ),
//     ];
//   }
// }

// // Custom Painter to create the "cutout" shape in the floating navigation bar
// class BottomNavPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final Path path = Path();
//     final double center = size.width / 2;
//     final double radius = 32.0; // Radius of the cutout

//     // Draw the main rectangular bar with rounded corners
//     path.moveTo(0, 20);
//     path.lineTo(0, size.height);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 20);
//     path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
//     path.lineTo(center + radius, 0);

//     // Create the downward curve/indent for the center button
//     path.quadraticBezierTo(center, 20, center - radius, 0);

//     path.lineTo(20, 0);
//     path.quadraticBezierTo(0, 0, 0, 20);
//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// /// Bottom sheet that shows an event's comments and lets the user add one.
// class CommentSheet extends StatefulWidget {
//   final int eventId;

//   const CommentSheet({super.key, required this.eventId});

//   @override
//   State<CommentSheet> createState() => _CommentSheetState();
// }

// class _CommentSheetState extends State<CommentSheet> {
//   final _commentCtrl = TextEditingController();
//   bool _sending = false;

//   @override
//   void dispose() {
//     _commentCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     final app = Provider.of<AppState>(context, listen: false);
//     if (!app.isLoggedIn) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please login to comment')),
//       );
//       return;
//     }
//     final text = _commentCtrl.text.trim();
//     if (text.isEmpty) return;

//     setState(() => _sending = true);
//     // Find the current event in app state to attach the comment.
//     final event = app.events.firstWhere(
//       (e) => e.id == widget.eventId,
//       orElse: () => app.events.isNotEmpty ? app.events.first : EventModel(id: widget.eventId, title: ''),
//     );
//     await app.addEventComment(event, text);
//     _commentCtrl.clear();
//     if (mounted) setState(() => _sending = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final app = Provider.of<AppState>(context);
//     final event = app.events.firstWhere(
//       (e) => e.id == widget.eventId,
//       orElse: () => EventModel(id: widget.eventId, title: ''),
//     );
//     final comments = event.comments;

//     return Padding(
//       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.7,
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Comments (${event.commentCount})',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0D1B3E)),
//             ),
//             const SizedBox(height: 12),
//             Flexible(
//               child: comments.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No comments yet. Be the first!',
//                         style: TextStyle(color: Color(0xFF6C757D)),
//                       ),
//                     )
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: comments.length,
//                       itemBuilder: (_, i) {
//                         final c = comments[i];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CircleAvatar(
//                                 radius: 18,
//                                 backgroundColor: const Color(0xFFE53935),
//                                 child: c.authorName.isNotEmpty
//                                     ? Text(c.authorName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14))
//                                     : const Icon(Icons.person, size: 18, color: Colors.white),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       c.authorName.isNotEmpty ? c.authorName : 'User',
//                                       style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0D1B3E)),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       c.text,
//                                       style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A)),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentCtrl,
//                     decoration: const InputDecoration(
//                       hintText: 'Add a comment...',
//                       isDense: true,
//                       border: OutlineInputBorder(),
//                     ),
//                     onSubmitted: (_) => _submit(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   onPressed: _sending ? null : _submit,
//                   icon: _sending
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Icon(Icons.send_rounded, color: Color(0xFFE53935)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
