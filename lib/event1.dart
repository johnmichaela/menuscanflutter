import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Primary brand color from the image
    const Color brandRed = Color(0xFFE23030);
    const Color darkText = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER (App Bar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Icon
                  const Icon(Icons.menu_rounded, size: 28, color: darkText),
                  
                  // Logo
                  Row(
                    children: [
                      // Simplified balloon icon
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 16,
                                height: 14,
                                decoration: const BoxDecoration(
                                  color: brandRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 4,
                                height: 6,
                                color: Colors.brown.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Balloon",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: brandRed,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  // Notification Bell
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_none_rounded, size: 28, color: darkText),
                      Positioned(
                        right: 0,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: brandRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search_rounded, color: Color(0xFFA0A0A0), size: 24),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Search events, concerts, festivals...",
                        style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 14),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                        color: brandRed,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.search_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. FEATURED MUSIC CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/img/bg.png',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Color.fromARGB(170, 230, 16, 16), // Dark overlay for text readability
                      BlendMode.darken,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Gradient to make text pop
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                          stops: [0.4, 1.0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "LIVE CONCERT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Music Night\n2026",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "24 July 2026\nDar es Salaam",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: darkText,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Book Now",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 4. CAROUSEL DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 24, height: 6, decoration: BoxDecoration(color: brandRed, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 6),
                Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle)),
              ],
            ),

            const SizedBox(height: 20),

            // 5. POPULAR EVENTS HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular Events",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: brandRed,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 6. POPULAR EVENTS LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildPopularEvent(
                    day: "25",
                    month: "JUL",
                    title: "Beach Festival",
                    location: "Coco Beach, DSM",
                    attendees: "1.2K",
                    color: brandRed,
                  ),
                  const SizedBox(height: 12),
                  _buildPopularEvent(
                    day: "02",
                    month: "AUG",
                    title: "Comedy Night",
                    location: "Alliance Française",
                    attendees: "850",
                    color: brandRed,
                  ),
                  const SizedBox(height: 12),
                  _buildPopularEvent(
                    day: "15",
                    month: "AUG",
                    title: "Food & Drinks Expo",
                    location: "Mlimani City",
                    attendees: "1.5K",
                    color: brandRed,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 7. BOTTOM NAVIGATION BAR
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.04),
      //         blurRadius: 10,
      //         offset: const Offset(0, -4),
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //     elevation: 0,
      //     backgroundColor: Colors.transparent,
      //     selectedItemColor: brandRed,
      //     unselectedItemColor: Colors.grey.shade400,
      //     selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      //     unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      //     currentIndex: _selectedIndex,
      //     onTap: (index) => setState(() => _selectedIndex = index),
      //     type: BottomNavigationBarType.fixed,
      //     items: const [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home_rounded),
      //         label: 'Discover',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.grid_view_rounded),
      //         label: 'Categories',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.confirmation_number_outlined),
      //         label: 'Tickets',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.favorite_border_rounded),
      //         label: 'Favorites',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person_outline_rounded),
      //         label: 'Profile',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // Helper widget for Popular Event rows
  Widget _buildPopularEvent({
    required String day,
    required String month,
    required String title,
    required String location,
    required String attendees,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  month,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Event Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Stats & Heart
          Row(
            children: [
              const Icon(Icons.people_outline_rounded, size: 16, color: Color(0xFFA0A0A0)),
              const SizedBox(width: 4),
              Text(
                attendees,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.favorite_border_rounded, size: 20, color: Color(0xFFA0A0A0)),
            ],
          ),
        ],
      ),
    );
  }
}