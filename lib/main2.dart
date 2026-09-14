import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Discovery App',
      theme: ThemeData(
        fontFamily: 'Roboto', // System default usually
        primaryColor: const Color(0xFFC62828),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // --- Custom Curved Header ---
      body: Stack(
        children: [
          // Red Background with custom curve
          Container(
            height: 290,
            decoration: const BoxDecoration(
              color: Color(0xFFC62828),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
          ),
          // Hot Air Balloon Image (Approximated with Icon + Flare for visual appeal)
          Positioned(
            right: -10,
            top: 20,
            child: Transform.rotate(
              angle: -0.05,
              child: Icon(Icons.air, size: 160, color: Colors.red[900]),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // --- Top Navigation Bar ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          const Text(
                            "Dar es Salaam",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              const Icon(Icons.notifications_none, color: Colors.white, size: 30),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text("3", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // --- Greeting Text ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back!",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Discover great places, food & events\naround you.",
                        style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- Search Bar ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Search restaurants, bars, lodges...",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        Icon(Icons.tune, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Categories Row ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryCard(Icons.rice_bowl, "Restaurants", const Color(0xFFFFEBEE), const Color(0xFFD32F2F)),
                      _buildCategoryCard(Icons.local_bar, "Bars", const Color(0xFFF3E5F5), const Color(0xFF8E24AA)),
                      _buildCategoryCard(Icons.bed, "Lodges", const Color(0xFFE8F5E9), const Color(0xFF388E3C)),
                      _buildCategoryCard(Icons.qr_code_scanner, "Scan QR Code", const Color(0xFFFFF3E0), const Color(0xFFFF8F00)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // --- Scrollable List Content ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Near You Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.near_me, color: Color(0xFFC62828), size: 20),
                                  SizedBox(width: 8),
                                  Text("Near You", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                                ],
                              ),
                              const Text("See all", style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Listing Cards
                        _buildListingCard(
                          imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop',
                          tag: "RESTAURANT",
                          tagColor: const Color(0xFFC62828),
                          title: "Spice Villa Restaurant",
                          desc: "Delicious meals, great ambiance and excellent service.",
                          rating: 4.7,
                          reviews: 128,
                          distance: "0.4 km",
                          isOpen: true,
                        ),
                        _buildListingCard(
                          imageUrl: 'https://images.unsplash.com/photo-1574672400128-c818a5c5301f?q=80&w=1000&auto=format&fit=crop',
                          tag: "BAR",
                          tagColor: const Color(0xFF8E24AA),
                          title: "Ocean View Bar",
                          desc: "Chill vibes, refreshing drinks and live music.",
                          rating: 4.5,
                          reviews: 86,
                          distance: "0.6 km",
                          isOpen: true,
                        ),
                        _buildListingCard(
                          imageUrl: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=1000&auto=format&fit=crop',
                          tag: "LODGE",
                          tagColor: const Color(0xFF388E3C),
                          title: "Sea Breeze Lodge",
                          desc: "Comfortable rooms with stunning sea views.",
                          rating: 4.8,
                          reviews: 64,
                          distance: "1.2 km",
                          isOpen: true,
                        ),

                        const SizedBox(height: 16),

                        // Bottom Large Banner
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC62828),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFFC62828).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Scan QR Code", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text("Scan a restaurant QR code\nto view menu & order", style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFC62828)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // --- Bottom Navigation Bar (Custom Design) ---
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left items
            _buildBottomNavItem(Icons.home, "Home", 0),
            _buildBottomNavItem(Icons.location_on_outlined, "Near You", 1),

            // Center Pill Scan Button
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFC62828),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
                  const SizedBox(height: 2),
                  const Text("Scan", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            // Right items
            _buildBottomNavItem(Icons.bookmark_border, "Saved", 3),
            _buildBottomNavItem(Icons.person_outline, "Profile", 4),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildCategoryCard(IconData icon, String label, Color bgColor, Color iconColor) {
    return Container(
      width: 80,
      height: 90,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard({
    required String imageUrl,
    required String tag,
    required Color tagColor,
    required String title,
    required String desc,
    required double rating,
    required int reviews,
    required String distance,
    required bool isOpen,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF333333)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text("$rating", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const Text(" (2)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(distance, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOpen ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOpen ? "Open" : "Closed",
                      style: TextStyle(
                        fontSize: 12,
                        color: isOpen ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
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

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFC62828) : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? const Color(0xFFC62828) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 2),
            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFC62828),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ] else ...[
            const SizedBox(height: 5),
          ]
        ],
      ),
    );
  }
}