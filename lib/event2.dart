import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'app_state.dart';
import 'models.dart';
import 'event_create_screen.dart';
import 'dashboard.dart';
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml for date formatting

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final app = Provider.of<AppState>(context, listen: false);
      app.loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final isLoading = !app.eventsLoaded;
    final events = isLoading ? [] : app.events;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Stack(
        children: [
          // 1. MAIN SCROLLABLE CONTENT
          RefreshIndicator(
            onRefresh: () async => await app.loadEvents(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 16),
                  // 2. FILTER BAR
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildFilterBar(),
                  ),
                  const SizedBox(height: 24),
                  // 3. EVENTS LIST
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        if (isLoading)
                          const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (!isLoading)
                          if (events.isEmpty)
                            _buildEmptyState(context)
                          else
                            for (int i = 0; i < events.length; i++) ...[
                              _buildSocialPostCard(
                                event: events[i],
                                index: i,
                              ),
                              const SizedBox(height: 20),
                            ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. FLOATING BOTTOM NAVIGATION
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BottomNavPainter(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.home_rounded, 'Home', 0),
                      _buildNavItem(Icons.explore_outlined, 'Explore', 1),
                      const SizedBox(width: 40),
                      _buildNavItem(Icons.bookmarks_outlined, 'Bookmarks', 2),
                      _buildNavItem(Icons.person_outline, 'Profile', 3),
                    ],
                  ),
                  Positioned(
                    top: -20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: app.isLoggedIn
                            ? () => _openCreateEvent(context)
                            : () => _promptLogin(context),
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE53935).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 35),
                        ),
                      ),
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

  void _openCreateEvent(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => const EventCreateScreen()),
    // );
  }

  void _promptLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please login to create an event')),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFE53935) : Colors.grey[400],
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFE53935) : Colors.grey[400],
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 40),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Right Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen())),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.notifications_none_rounded, size: 26, color: Color(0xFF0D1B3E)),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                        child: const Text('6', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Discover",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0D1B3E),
              height: 1.1,
            ),
          ),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Amazing ",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B3E),
                    height: 1.1,
                  ),
                ),
                TextSpan(
                  text: "Events",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE53935),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Find events happening around you\nand join the excitement!",
            style: TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: const Offset(20, -30),
              child: Image.asset(
                'assets/img/white-logo.png',
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFF0D1B3E), size: 20),
          const SizedBox(width: 6),
          const Text("All Locations", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0D1B3E))),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF0D1B3E)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("All Events", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.person_outline, size: 22, color: Color(0xFF0D1B3E)),
          const SizedBox(width: 16),
          const Icon(Icons.face, size: 22, color: Color(0xFF0D1B3E)),
          const SizedBox(width: 16),
          const Icon(Icons.group_outlined, size: 22, color: Color(0xFF0D1B3E)),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: const Row(
              children: [
                Icon(Icons.filter_list, size: 18, color: Color(0xFF0D1B3E)),
                SizedBox(width: 6),
                Text("Filter", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0D1B3E))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No events yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0D1B3E)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Be the first to create an event! Tap the + button.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6C757D), fontSize: 14),
          ),
          const SizedBox(height: 12),
          if (app.eventsLoaded)
            ElevatedButton.icon(
              onPressed: () async => await app.loadEvents(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            ),
        ],
      ),
    );
  }

  // Helper to format "X days ago"
  String _timeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Just now';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // PROFESSIONAL SOCIAL MEDIA POST
  Widget _buildSocialPostCard({
    required EventModel event,
    required int index,
  }) {
    final defaultImages = [
      'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=1000&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=1000&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=1000&auto=format&fit=crop',
    ];
    final imageUrl = event.image.isNotEmpty ? event.image : defaultImages[index % defaultImages.length];

    // Get organizer details
    final organizer = event.organizer;
    final organizerName = organizer.name.isNotEmpty ? organizer.name : 'Unknown Organizer';
    final organizerPicture = organizer.picture.isNotEmpty ? organizer.picture : '';
    final organizerPlace = organizer.place.isNotEmpty ? organizer.place : 'No location set';
    
    // Parse date for "time ago"
    DateTime? eventDate;
    if (event.date != null && event.date!.isNotEmpty) {
      try {
        eventDate = DateTime.parse(event.date!);
      } catch (_) {
        eventDate = DateTime.now().subtract(const Duration(days: 2)); // Fallback
      }
    } else {
      eventDate = DateTime.now().subtract(const Duration(days: 2));
    }
    
    final timeAgo = _timeAgo(eventDate);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- PROFESSIONAL ORGANIZER HEADER ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                // Organizer Profile Picture
                Hero(
                  tag: 'organizer_${event.id}',
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFF0F0F0),
                    backgroundImage: organizerPicture.isNotEmpty
                        ? NetworkImage(organizerPicture)
                        : null,
                    child: organizerPicture.isEmpty
                        ? Text(
                            organizerName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF0D1B3E),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                // Organizer Name & Place & Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            organizerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF0D1B3E),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Organizer',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            organizerPlace,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Small menu icon (optional professional touch)
                const Icon(
                  Icons.more_horiz,
                  color: Color(0xFF6C757D),
                  size: 20,
                ),
              ],
            ),
          ),

          // Subtle divider between header and image
          Divider(height: 0, thickness: 0.5, color: Colors.grey.shade200),

          // ---- IMAGE SECTION (Full width) ----
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey, size: 48),
                    ),
                  ),
                ),
              ),
              // Heart Icon - Top Right Corner with professional styling
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    color: Color(0xFF0D1B3E),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          // ---- CONTENT SECTION ----
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with professional spacing
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Color(0xFF0D1B3E),
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                    height: 1.6,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // Location & Time with professional icons
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Color(0xFF0D1B3E),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.location.isNotEmpty ? event.location : 'Venue TBD',
                              style: TextStyle(
                                color: Color(0xFF0D1B3E),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: Color(0xFF0D1B3E),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.time.isNotEmpty ? event.time : 'All day',
                            style: TextStyle(
                              color: Color(0xFF0D1B3E),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ---- INTERACTION ROW ----
                const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Like
                    InkWell(
                      onTap: () => _onLike(context, event),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              event.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                              size: 20,
                              color: event.isLiked ? const Color(0xFFE53935) : const Color(0xFF6C757D),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${event.likeCount}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D1B3E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Comment
                    InkWell(
                      onTap: () => _openComments(context, event),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Color(0xFF6C757D)),
                            const SizedBox(width: 6),
                            Text(
                              '${event.commentCount}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D1B3E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Attend
                    InkWell(
                      onTap: () => _onAttend(context, event),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              event.isAttending ? Icons.event_available : Icons.event_outlined,
                              size: 20,
                              color: event.isAttending ? const Color(0xFFE53935) : const Color(0xFF6C757D),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${event.attendeeCount}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D1B3E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Share
                    InkWell(
                      onTap: () => _shareEvent(context, event),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.share_outlined, size: 20, color: Color(0xFF6C757D)),
                            const SizedBox(width: 6),
                            const Text(
                              "Share",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D1B3E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                // ---- GOING AVATARS ----
                Row(
                  children: [
                    SizedBox(
                      width: 72,
                      height: 26,
                      child: Stack(
                        children: [
                          const Positioned(left: 0, child: CircleAvatar(radius: 13, backgroundColor: Colors.redAccent)),
                          const Positioned(left: 18, child: CircleAvatar(radius: 13, backgroundColor: Colors.blueAccent)),
                          const Positioned(left: 36, child: CircleAvatar(radius: 13, backgroundColor: Colors.greenAccent)),
                          Positioned(
                            left: 54,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '+${event.attendees > 3 ? event.attendees - 3 : ''}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${event.attendees} people going',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onLike(BuildContext context, EventModel event) {
    final app = Provider.of<AppState>(context, listen: false);
    if (!app.isLoggedIn) {
      _promptLogin(context);
      return;
    }
    app.toggleEventLike(event);
  }

  void _onAttend(BuildContext context, EventModel event) {
    final app = Provider.of<AppState>(context, listen: false);
    if (!app.isLoggedIn) {
      _promptLogin(context);
      return;
    }
    app.toggleEventAttend(event);
  }

  void _openComments(BuildContext context, EventModel event) {
    final app = Provider.of<AppState>(context, listen: false);
    app.loadEventComments(event);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CommentSheet(eventId: event.id),
    );
  }

  Future<void> _shareEvent(BuildContext context, EventModel event) async {
    final app = Provider.of<AppState>(context, listen: false);
    final message = [
      event.title,
      if (event.location.isNotEmpty) '📍 ${event.location}',
      if (event.time.isNotEmpty) '🕒 ${event.time}',
      if (event.date != null && event.date!.isNotEmpty) '📅 ${event.date}',
      if (event.description.isNotEmpty) event.description,
    ].join('\n');
    try {
      await Share.share(message);
      if (app.isLoggedIn) {
        app.shareEvent(event, shareMethod: 'system');
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to share event')),
      );
    }
  }
}

// Custom Painter for floating bottom nav cutout
class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double center = size.width / 2;
    final double radius = 32.0;

    path.moveTo(0, 20);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
    path.lineTo(center + radius, 0);
    path.quadraticBezierTo(center, 20, center - radius, 0);
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Comment Sheet
class CommentSheet extends StatefulWidget {
  final int eventId;

  const CommentSheet({super.key, required this.eventId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final _commentCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final app = Provider.of<AppState>(context, listen: false);
    if (!app.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to comment')),
      );
      return;
    }
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    final event = app.events.firstWhere(
      (e) => e.id == widget.eventId,
      orElse: () => app.events.isNotEmpty ? app.events.first : EventModel(
        id: widget.eventId, 
        title: '', 
        organizer: OrganizerModel(
          pk: 0,
          user: 0,
          name: 'Unknown',
          activity: '',
          place: '',
          picture: '',
          phoneNumber: 0,
          email: '',
          bio: '',
          birthday: null,
        ),
      ),
    );
    await app.addEventComment(event, text);
    _commentCtrl.clear();
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final event = app.events.firstWhere(
      (e) => e.id == widget.eventId,
      orElse: () => EventModel(
        id: widget.eventId, 
        title: '', 
        organizer: OrganizerModel(
          pk: 0,
          user: 0,
          name: 'Unknown',
          activity: '',
          place: '',
          picture: '',
          phoneNumber: 0,
          email: '',
          bio: '',
          birthday: null,
        ),
      ),
    );
    final comments = event.comments;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Comments (${event.commentCount})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0D1B3E)),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: comments.isEmpty
                  ? const Center(
                      child: Text(
                        'No comments yet. Be the first!',
                        style: TextStyle(color: Color(0xFF6C757D)),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (_, i) {
                        final c = comments[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFFE53935),
                                child: c.authorName.isNotEmpty
                                    ? Text(c.authorName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14))
                                    : const Icon(Icons.person, size: 18, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.authorName.isNotEmpty ? c.authorName : 'User',
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0D1B3E)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      c.text,
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A)),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sending ? null : _submit,
                  icon: _sending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded, color: Color(0xFFE53935)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}