// import 'package:ballon/models/resturants.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'app_state.dart';
// import 'screens.dart';

// /// Search tab — lets the user search restaurants by name.
// /// The list stays empty until the user starts typing in the search bar.
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _controller = TextEditingController();
//   String _query = '';

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

// List<Result> _filtered(AppState app) {
//     final q = _query.trim().toLowerCase();
//     if (q.isEmpty) return [];
//     return app.allRestaurants
//         .where((r) => r.name!.toLowerCase().contains(q))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final app = Provider.of<AppState>(context);
//     final results = _filtered(app);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//         appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 199, 17, 17),
//         toolbarHeight: 80,
//         elevation: 0,
        
//   iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//            IconButton(onPressed: (){}, icon: Icon(Icons.notifications,color:Colors.white))
//         ],
        
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
           
//              Image.asset('assets/img/white.png',height: 190,width: 190,),
          
           
//           ],
//         ),
//       ),
//       drawer: _buildSidebar(),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: TextField(
//                 controller: _controller,
//                 autofocus: true,
//                 onChanged: (v) => setState(() => _query = v),
//                 decoration: InputDecoration(
//                   hintText: 'Search restaurants by name...',
//                   prefixIcon: const Icon(Icons.search, color: Color(0xFFE71D36)),
//                   suffixIcon: _query.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () {
//                             _controller.clear();
//                             setState(() => _query = '');
//                           },
//                         )
//                       : null,
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _query.trim().isEmpty
//                 ? _emptyState()
//                 : results.isEmpty
//                     ? _noResults()
//                     : ListView.builder(
//                         padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                         itemCount: results.length,
//                         itemBuilder: (context, i) => _resultCard(context, results[i]),
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _emptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 90,
//             height: 90,
//             decoration: BoxDecoration(
//               color: const Color(0xFFE71D36).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.search, size: 44, color: Color(0xFFE71D36)),
//           ),
//           const SizedBox(height: 20),
//           const Text('Find a restaurant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//           const SizedBox(height: 6),
//           Text(
//             'Type the name of a restaurant to search',
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _noResults() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
//           const SizedBox(height: 14),
//           const Text('No restaurants found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 4),
//           Text('Try a different name', style: TextStyle(color: Colors.grey.shade600)),
//         ],
//       ),
//     );
//   }

//   Widget _resultCard(BuildContext context, Result r) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r)),
//       ),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
//           ],
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 '${r.banner}',
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   width: 60,
//                   height: 60,
//                   color: Colors.grey.shade200,
//                   child: const Icon(Icons.restaurant, color: Colors.grey),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(r.name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
//                   const SizedBox(height: 4),
//                   Text('${r.place} · ${r.typeBusiness!.name!.isEmpty ? 'Restaurant' : r.typeBusiness!.name}',
//                       style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Color(0xFFE71D36), size: 14),
//                       const SizedBox(width: 2),
//                       Text('${r.rating as double}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Sidebar Drawer ---
//   Widget _buildSidebar() {
//     return Drawer(
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFFC62828),
//                   Color(0xFFE53935),
//                 ],
//               ),
//               // borderRadius: BorderRadius.only(
//               //   bottomLeft: Radius.circular(30),
//               //   bottomRight: Radius.circular(30),
//               // ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: const CircleAvatar(
//                     radius: 48,
//                     backgroundImage: NetworkImage(
//                       'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   "John Doe",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "john.doe@email.com",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.star, color: Colors.amber, size: 16),
//                       SizedBox(width: 4),
//                       Text(
//                         "Premium Member",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerItem(
//                   icon: Icons.home_outlined,
//                   title: "Home",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   isSelected: true,
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.search_outlined,
//                   title: "Search",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.favorite_border,
//                   title: "Favorites",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.shopping_bag_outlined,
//                   title: "Orders",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.event_outlined,
//                   title: "Events",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 const Divider(height: 1),
//                 _buildDrawerItem(
//                   icon: Icons.person_outline,
//                   title: "Profile",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.settings_outlined,
//                   title: "Settings",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.help_outline,
//                   title: "Help & Support",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 const Divider(height: 1),
//                 _buildDrawerItem(
//                   icon: Icons.logout_outlined,
//                   title: "Logout",
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   isLogout: true,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               border: Border(
//                 top: BorderSide(color: Colors.grey.shade200),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFC62828).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.qr_code_scanner,
//                     color: Color(0xFFC62828),
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Scan QR Code",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         "Scan to view menu & order",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFC62828),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.white,
//                     size: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool isLogout = false,
//     bool isSelected = false,
//   }) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? const Color(0xFFC62828).withOpacity(0.1)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(
//           icon,
//           color: isLogout ? Colors.red : (isSelected ? const Color(0xFFC62828) : Colors.grey.shade700),
//           size: 22,
//         ),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isLogout ? Colors.red : (isSelected ? const Color(0xFFC62828) : Colors.grey.shade800),
//           fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//         ),
//       ),
//       trailing: isSelected
//           ? Container(
//               width: 4,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFC62828),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             )
//           : (isLogout ? const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 14) : null),
//       onTap: onTap,
//       tileColor: isSelected ? const Color(0xFFC62828).withOpacity(0.05) : null,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }

import 'package:ballon/models/resturants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'screens/sub/screens.dart';

/// Search tab — lets the user search restaurants by name.
/// The list stays empty until the user starts typing in the search bar.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Removed _filtered function. We are using the API to filter now.

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 199, 17, 17),
        toolbarHeight: 80,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/img/white.png', height: 190, width: 190),
          ],
        ),
      ),
      drawer: _buildSidebar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: (v) {
                  setState(() => _query = v);
                  // Fetch from API when the user types
                  app.searchRestaurants(v);
                },
                decoration: InputDecoration(
                  hintText: 'Search restaurants by name...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFE71D36)),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                            app.searchRestaurants(''); // Clear API results
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? _emptyState()
                : app.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : app.errorMessage != null
                        ? Center(child: Text(app.errorMessage!))
                        : app.allRestaurants.isEmpty
                            ? _noResults()
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                itemCount: app.allRestaurants.length,
                                itemBuilder: (context, i) =>
                                    _resultCard(context, app.allRestaurants[i]),
                              ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE71D36).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, size: 44, color: Color(0xFFE71D36)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Find a restaurant',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Type the name of a restaurant to search',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _noResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          const Text(
            'No restaurants found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text('Try a different name', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _resultCard(BuildContext context, Result r) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                r.picture ?? '', // Changed from banner to picture to match JSON
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.restaurant, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${r.place ?? ''} · ${r.typeBusiness?.name ?? 'Restaurant'}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFE71D36), size: 14),
                      const SizedBox(width: 2),
                      Text(
                        (r.rating ?? 0.0).toString(), // Fixed string interpolation
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- Sidebar Drawer (Kept intact from your original code) ---
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
                colors: [Color(0xFFC62828), Color(0xFFE53935)],
              ),
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
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "john.doe@email.com",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
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
                      Text("Premium Member", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
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
                _buildDrawerItem(icon: Icons.home_outlined, title: "Home", onTap: () => Navigator.pop(context), isSelected: true),
                _buildDrawerItem(icon: Icons.search_outlined, title: "Search", onTap: () => Navigator.pop(context)),
                _buildDrawerItem(icon: Icons.favorite_border, title: "Favorites", onTap: () => Navigator.pop(context)),
                _buildDrawerItem(icon: Icons.shopping_bag_outlined, title: "Orders", onTap: () => Navigator.pop(context)),
                _buildDrawerItem(icon: Icons.event_outlined, title: "Events", onTap: () => Navigator.pop(context)),
                const Divider(height: 1),
                _buildDrawerItem(icon: Icons.person_outline, title: "Profile", onTap: () => Navigator.pop(context)),
                _buildDrawerItem(icon: Icons.settings_outlined, title: "Settings", onTap: () => Navigator.pop(context)),
                _buildDrawerItem(icon: Icons.help_outline, title: "Help & Support", onTap: () => Navigator.pop(context)),
                const Divider(height: 1),
                _buildDrawerItem(icon: Icons.logout_outlined, title: "Logout", onTap: () => Navigator.pop(context), isLogout: true),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Color(0xFFC62828), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Scan QR Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("Scan to view menu & order", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
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
          color: isSelected ? const Color(0xFFC62828).withOpacity(0.1) : Colors.transparent,
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
}