// import 'package:ballon/models/profilebytype.dart';
// import 'package:ballon/screens.dart';
// import 'package:flutter/material.dart';


// class CategoryDetailScreen extends StatefulWidget {
//   const CategoryDetailScreen({super.key});

//   @override
//   State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
// }

// class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
//   int _selectedIndex = 2; // Default to the center '+' button

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFCFBFE),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//         title: const Text(
//           'Balloon',
//           style: TextStyle(
//             color: Color(0xFF8B5CF6),
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.black),
//             onPressed: () {},
//           ),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications_none, color: Colors.black),
//                 onPressed: () {},
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF8B5CF6),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   constraints: const BoxConstraints(
//                     minWidth: 14,
//                     minHeight: 14,
//                   ),
//                   child: const Text(
//                     '3',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             // Header Section
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF8B5CF6),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: const Icon(Icons.code, color: Colors.white, size: 30),
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Programming & Tech',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       const Text(
//                         'Build websites, mobile apps, software and more with top tech professionals.',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                           height: 1.3,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           const Icon(Icons.calendar_today_outlined,
//                               size: 16, color: Color(0xFF8B5CF6)),
//                           const SizedBox(width: 5),
//                           const Text('128 Services',
//                               style: TextStyle(
//                                   fontSize: 13, fontWeight: FontWeight.w500)),
//                           const SizedBox(width: 15),
//                           const Icon(Icons.group_outlined,
//                               size: 16, color: Color(0xFF8B5CF6)),
//                           const SizedBox(width: 5),
//                           const Text('2.4k Freelancers',
//                               style: TextStyle(
//                                   fontSize: 13, fontWeight: FontWeight.w500)),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // Filter and Sort Row
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF3E8FF), // Light purple background
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Row(
//                     children: [
//                       Icon(Icons.filter_list, size: 18, color: Color(0xFF8B5CF6)),
//                       SizedBox(width: 5),
//                       Text(
//                         'Filter',
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF8B5CF6)),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Row(
//                     children: [
//                       Text(
//                         'Sort by: Popular',
//                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(width: 5),
//                       Icon(Icons.keyboard_arrow_down, size: 18),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // Service Cards
//             const ServiceCard(
//               title: 'Full Stack Web Development',
//               description: 'Modern, responsive websites and web applications.',
//               imageUrl: 'https://images.unsplash.com/photo-1547658719-da2b51169166?auto=format&fit=crop&q=80&w=400',
//               personName: 'John Deo',
//               rating: 4.9,
//               reviews: 124,
//               duration: '3 - 7 days',
//               price: '250,000',
//             ),
//             const ServiceCard(
//               title: 'Mobile App Development',
//               description: 'iOS & Android apps built with modern technology.',
//               imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&q=80&w=400',
//               personName: 'Grace M.',
//               rating: 4.8,
//               reviews: 98,
//               duration: '5 - 10 days',
//               price: '300,000',
//             ),
//             const ServiceCard(
//               title: 'API Development & Integration',
//               description: 'Custom APIs and third-party integrations.',
//               imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&q=80&w=400',
//               personName: 'Peter J.',
//               rating: 4.9,
//               reviews: 76,
//               duration: '2 - 5 days',
//               price: '180,000',
//             ),
//             const ServiceCard(
//               title: 'UI/UX Design',
//               description: 'Beautiful and user-friendly UI/UX designs.',
//               imageUrl: 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?auto=format&fit=crop&q=80&w=400',
//               personName: 'Aisha K.',
//               rating: 4.9,
//               reviews: 110,
//               duration: '3 - 6 days',
//               price: '200,000',
//             ),
//           ],
//         ),
//       ),
     
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(top: 10),
//         height: 60,
//         width: 60,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: const LinearGradient(
//             colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF8B5CF6).withOpacity(0.4),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.add, color: Colors.white, size: 30),
//           onPressed: () {
//             setState(() {
//               _selectedIndex = 2;
//             });
//           },
//         ),
//       ),
//     );
//   }
//     Widget _buildListingCard({required Result data}) {
//   Color getColorFromHex(String hexColor) {
//     hexColor = hexColor.replaceAll('#', '');
//     if (hexColor.length == 6) {
//       hexColor = 'FF$hexColor';
//     }
//     return Color(int.parse('0x$hexColor'));
//   }

//   return GestureDetector(
//     onTap: (){},
//     //  => Navigator.push(
//     //   context, 
//       // MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: data))
//     // ),
//     child: Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//               child: Image.network(
//                 data.banner ?? '',
//                 width: 120,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   width: 120,
//                   color: Colors.grey[300],
//                   child: const Icon(Icons.image_not_supported),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(12),
//                     bottomRight: Radius.circular(12),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.08),
//                       blurRadius: 15,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                           decoration: BoxDecoration(
//                             color: getColorFromHex(data.typeBusinessDetails?.textColor ?? '#C62828'),  // ✅ Fix
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             data.typeBusinessDetails?.name ?? "Category",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         // const Icon(Icons.favorite_border, color: Colors.grey, size: 20),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       data.name ?? '',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Color(0xFF333333),
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       data.bio ?? '',
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                         height: 1.3,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.star, size: 14, color: Colors.amber),
//                         const SizedBox(width: 4),
//                         Text(
//                            data.rating?.toStringAsFixed(1) ?? '0.0',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           " (${data.reviews ?? 0} reviews)",
//                           style: const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         const SizedBox(width: 12),
//                         const Icon(Icons.location_on, size: 14, color: Colors.grey),
//                         const SizedBox(width: 2),
//                         Text(
//                           data.distance?.toString() ?? '0 km',
//                           style: const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         const Spacer(),
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: data.isOpen == true ? Colors.green : Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           data.isOpen == true ? "Open" : "Closed",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: data.isOpen == true ? Colors.green : Colors.red,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// }

// class ServiceCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String imageUrl;
//   final String personName;
//   final double rating;
//   final int reviews;
//   final String duration;
//   final String price;

//   const ServiceCard({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.personName,
//     required this.rating,
//     required this.reviews,
//     required this.duration,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   imageUrl,
//                   width: 90,
//                   height: 90,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: 90,
//                     height: 90,
//                     color: Colors.grey.shade200,
//                     child: const Icon(Icons.image, color: Colors.grey),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       description,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade600,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.favorite_border, color: Color(0xFF8B5CF6)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               const CircleAvatar(
//                 radius: 12,
//                 backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder avatar
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 personName,
//                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(width: 10),
//               const Icon(Icons.star, size: 14, color: Color(0xFF8B5CF6)),
//               const SizedBox(width: 2),
//               Text(
//                 rating.toString(),
//                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(width: 2),
//               Text(
//                 '(${reviews})',
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
//                   const SizedBox(width: 5),
//                   Text(
//                     duration,
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                   ),
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     'From\n',
//                     style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//                     textAlign: TextAlign.right,
//                   ),
//                   Text(
//                     'TZS $price',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF8B5CF6),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:ballon/categoryresturantdetail.dart';
import 'package:ballon/helper.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:http/http.dart' as http;
import 'package:ballon/models/profilebytype.dart';
import 'package:ballon/screens.dart';
import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatefulWidget {
  int typeId;Datum? datum;
  CategoryDetailScreen({super.key, required this.typeId, required this.datum});

  // const CategoryDetailScreen({super.key});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  int _selectedIndex = 2; // Default to the center '+' button
  
  // State variables for API data
  bool _isLoading = true;
  String? _errorMessage;
  List<Result> _profiles = [];

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Note: Android emulator uses 10.0.2.2 to access localhost of the host machine.
    // If testing on a physical device, use your computer's LAN IP (e.g., 192.168.1.115).
    // If using iOS simulator, localhost usually works.
    final uri = Uri.parse('http://192.168.1.115:8000/prof/restaurants-by-type/?type_id=${widget.typeId}');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = Profilebytype.fromJson(decoded);

        setState(() {
          _profiles = data.data?.results ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data (Status code: ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController? _searchController;
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Color.fromARGB(255, 199, 17, 17),
        toolbarHeight: 80,
        elevation: 0,
       iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Text(widget.datum?.name ?? 'Category Name', style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
            //  Image.asset('assets/img/white.png',height: 190,width: 190,),
          
           
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: const Color(0xFFFCFBFE),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 10),
            // Header Section (Keep as is)
            // Container(
            //   padding: const EdgeInsets.all(15),
            //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: Colors.white,

            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.1),
            //         blurRadius: 15,
            //         offset: const Offset(0, 5),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         width: 60,
            //         height: 60,
            //         decoration: BoxDecoration(
            //           color: widget.datum?.color != null
            //               ? Color(int.parse('0xFF${widget.datum!.color!.replaceAll('#', '')}'))
            //               : const Color.fromARGB(255, 235, 29, 29),
            //           borderRadius: BorderRadius.circular(16),
            //         ),
            //         child:  Icon( widget.datum?.icon?.toIconData() ?? Icons.restaurant,
            //         color: widget.datum?.textColor != null
            //             ? Color(int.parse('0xFF${widget.datum!.textColor!.replaceAll('#', '')}'))
            //             : const Color.fromARGB(255, 235, 29, 29),
            //         size: 26,),
            //       ),
            //       const SizedBox(width: 15),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //              Text(
            //               widget.datum?.name ?? 'Category Name',
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.black,
            //               ),
            //             ),
            //             const SizedBox(height: 5),
            //              Text(
            //              widget.datum?.description ?? 'Category description goes here.',
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 color: Colors.grey,
            //                 height: 1.3,
            //               ),
            //             ),
            //             // const SizedBox(height: 10),
            //             // Row(
            //             //   children: [
            //             //     const Icon(Icons.calendar_today_outlined,
            //             //         size: 16, color: Color(0xFF8B5CF6)),
            //             //     const SizedBox(width: 5),
            //             //     const Text('128 Services',
            //             //         style: TextStyle(
            //             //             fontSize: 13, fontWeight: FontWeight.w500)),
            //             //     const SizedBox(width: 15),
            //             //     const Icon(Icons.group_outlined,
            //             //         size: 16, color: Color(0xFF8B5CF6)),
            //             //     const SizedBox(width: 5),
            //             //     const Text('2.4k Freelancers',
            //             //         style: TextStyle(
            //             //             fontSize: 13, fontWeight: FontWeight.w500)),
            //             //   ],
            //             // )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 10),
             Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: "Search restaurants, bars, lodges...",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onSubmitted: (value) {
                                    // Handle search
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC62828),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

            // Filter and Sort Row (Keep as is)
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF3E8FF),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: const Row(
            //         children: [
            //           Icon(Icons.filter_list, size: 18, color: Color(0xFF8B5CF6)),
            //           SizedBox(width: 5),
            //           Text(
            //             'Filter',
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w600,
            //                 color: Color(0xFF8B5CF6)),
            //           ),
            //         ],
            //       ),
            //     ),
            //     const Spacer(),
            //     Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.grey.shade300),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: const Row(
            //         children: [
            //           Text(
            //             'Sort by: Popular',
            //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            //           ),
            //           SizedBox(width: 5),
            //           Icon(Icons.keyboard_arrow_down, size: 18),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text( "Available ${widget.datum?.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.left,)),
            const SizedBox(height: 10),

            // Dynamic API Data Section
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchProfiles,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_profiles.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No profiles found for this category.'),
                ),
              )
            else
              // Map through API results using _buildListingCard
              ..._profiles.map((profile) => _ListingCard(data: profile)),
          ],
        ),
      ),
     
      
    );
  }
}

// Converted _buildListingCard into a separate StatelessWidget class
class _ListingCard extends StatelessWidget {
  final Result data;

  const _ListingCard({required this.data});

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantTypeScreen(restaurant: data)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical:5), // Removed extra padding since parent has it
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 27, 27, 27).withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  data.picture ?? '', // Fixed: Changed from data.banner to data.picture
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: getColorFromHex(data.typeBusinessDetails?.textColor ?? '#C62828'),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              data.typeBusinessDetails?.name ?? "Category",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.bio ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            data.rating ?.toStringAsFixed(1) ?? '0.0',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " (${data.reviews ?? 0} reviews)",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            data.distance ?? '0 km',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const Spacer(),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: data.isOpen == true ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.isOpen == true ? "Open" : "Closed",
                            style: TextStyle(
                              fontSize: 12,
                              color: data.isOpen == true ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}