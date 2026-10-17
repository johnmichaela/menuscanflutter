
import 'package:ballon/categorydetail.dart';
import 'package:ballon/core/services/services_locator.dart';
import 'package:ballon/helper.dart';
import 'package:ballon/models/bussinesstype.dart';
import 'package:ballon/models/resturants.dart';
import 'package:ballon/pages/notification_page.dart';
import 'package:ballon/pagination/ui/bloc/pagination_bloc.dart';
import 'package:ballon/screens/sub/screens.dart';
import 'package:ballon/search_screen.dart';
import 'package:ballon/seeallscreen.dart';
import 'package:ballon/shimmer.dart';
import 'package:ballon/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_state.dart';
import 'models.dart';
import 'widgets.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final app = Provider.of<AppState>(context);
    final nearby = app.allRestaurants.take(5).toList();
    final String imageUrl = 'https://qopera.app';
    
    return  MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) =>
                appServiceLocator<PaginationBlocBusinessType>()..add(const LoadPageEvent()),
          ),
          BlocProvider(
            lazy: false,
            create: (_) => appServiceLocator<PaginationBlocReviews>()
              ..add(const LoadPageEvent()),
          ),
           BlocProvider(
            lazy: false,
            create: (_) => appServiceLocator<PaginationBlocDistance>()
              ..add(const LoadPageEvent()),
          )
        ],
        child:Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
     
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 17, 17),
        toolbarHeight: 80,
        elevation: 0,
        
  iconTheme: IconThemeData(color: Colors.white),
        actions: [
           IconButton(onPressed: (){
            
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );

           }, icon: Icon(Icons.notifications,color:Colors.white))
        ],
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           
             Image.asset('assets/img/white.png',height: 190,width: 190,),
          
           
          ],
        ),
      ),
      drawer: SidebarWidget(),
      // _buildSidebar(),
      body: CustomScrollView(
        slivers: [
         
       SliverPadding(
         padding: const EdgeInsets.only(top: 16, bottom: 10),
        
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),
          //               // --- Search Bar (Integrated in Header) ---
                       GestureDetector(
  onTap: () {
    // Navigate to search screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            margin: EdgeInsets.symmetric(horizontal: 20),
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
                        ),
                        // const SizedBox(height: 16),
              ]))),
                // Featured Section
          // --- Categories Sliver ---
          SliverPersistentHeader(
            pinned: false,
            delegate: _SliverCategoriesDelegate(
              child: BlocBuilder<PaginationBlocBusinessType, PaginationState>(
                      builder: (context, state) {
                    if (context.read<PaginationBlocBusinessType>().posts.isEmpty) {
                      if (state == PaginationLoadingState()) {
                        return 
                       Container(
                                   color: const Color(0xFFF8F9FA),
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  height:120,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 8,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 100,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                        
                      } else if (state == PaginationErrorState()) {
                      // raisederror();
                        return
                         Container(
                                  height: 120,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 8,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 100,
                                              width: 90,
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
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: context.read<PaginationBlocBusinessType>().posts.length +
                              (context.read<PaginationBlocBusinessType>().isLastPage ? 0 : 1),
                          itemBuilder: (context, index) {
                            // request more data when the user has reached the trigger point.
                            context
                                .read<PaginationBlocBusinessType>()
                                .add(CheckIfNeedMoreDataEvent(index: index));
                            // when the user gets to the last item in the list, check whether
                            // there is an error, otherwise, render a progress indicator.
                            if (index ==
                                context.read<PaginationBlocBusinessType>().posts.length) {
                              if (state == PaginationErrorState()) {
                                return Container(
                                  height: 120,
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
                                              height: 100,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                               
                              } else {
                                return 
                                Container(
                                  height: 120,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 8,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              height: 100,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                               
                              }
                            }
          
                            final Datum data =
                                context.read<PaginationBlocBusinessType>().posts[index];
                            return 
                            // _bannerAd == null?
                              _buildCategoryCard(
                               data,
                            );
                            // : AdWidget(ad: _bannerAd!);
                          }),
                    );
                  }),
              // child: Container(
              //   color: const Color(0xFFF8F9FA),
              //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   height:40,

              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       _buildCategoryCard(Icons.rice_bowl, "Restaurants", const Color(0xFFFFEBEE), const Color(0xFFD32F2F)),
              //       _buildCategoryCard(Icons.local_bar, "Bars", const Color(0xFFF3E5F5), const Color(0xFF8E24AA)),
              //       _buildCategoryCard(Icons.bed, "Lounges", const Color(0xFFE8F5E9), const Color(0xFF388E3C)),
              //       _buildCategoryCard(Icons.local_cafe, "Cafes", const Color(0xFFFFF3E0), const Color(0xFFE65100)),
              //       _buildCategoryCard(Icons.fastfood, "Fast Food", const Color(0xFFFFEBEE), const Color(0xFFC62828)),
              //       _buildCategoryCard(Icons.icecream, "Desserts", const Color(0xFFFCE4EC), const Color(0xFFAD1457)),
              //       _buildCategoryCard(Icons.restaurant, "Fine Dining", const Color(0xFFE8EAF6), const Color(0xFF283593)),
              //       _buildCategoryCard(Icons.coffee, "Coffee Shops", const Color(0xFFEFEBE9), const Color(0xFF4E342E)),
              //       _buildCategoryCard(Icons.liquor, "Pubs", const Color(0xFFE0F2F1), const Color(0xFF00695C)),
              //       _buildCategoryCard(Icons.bakery_dining, "Bakeries", const Color(0xFFFFF8E1), const Color(0xFFF57F17)),
              //       _buildCategoryCard(Icons.local_pizza_rounded, "Pizza", const Color(0xFFFFF3E0), const Color(0xFFBF360C)),
              //       _buildCategoryCard(Icons.ramen_dining, "Asian", const Color(0xFFF1F8E9), const Color(0xFF33691E)),
              //       _buildCategoryCard(Icons.emoji_food_beverage, "Sushi", const Color(0xFFE0F7FA), const Color(0xFF006064)),
              //       _buildCategoryCard(Icons.takeout_dining, "Takeaway", const Color(0xFFFFFDE7), const Color(0xFFF9A825)),
              //       _buildCategoryCard(Icons.breakfast_dining, "Breakfast", const Color(0xFFFFF3E0), const Color(0xFFE65100)),
              //       _buildCategoryCard(Icons.dinner_dining, "Dinner", const Color(0xFFFBE9E7), const Color(0xFFBF360C)),
              //       _buildCategoryCard(Icons.brunch_dining, "Brunch", const Color(0xFFF1F8E9), const Color(0xFF33691E)),
              //       _buildCategoryCard(Icons.sports_bar, "Sports Bars", const Color(0xFFE3F2FD), const Color(0xFF0D47A1)),
              //       _buildCategoryCard(Icons.nightlife, "Nightlife", const Color(0xFFF3E5F5), const Color(0xFF4A148C)),
              //       _buildCategoryCard(Icons.music_note, "Live Music", const Color(0xFFFFEBEE), const Color(0xFFB71C1C)),
              //     ],
              //   ),
              // ),
            ),
          ),

          // --- Content Sliver ---
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, bottom: 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Featured Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: Color(0xFFC62828), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Featured",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SeeAllScreen()),
                          );
                        },
                        child: const Text(
                          "See all",
                          style: TextStyle(
                            color: Color(0xFFC62828),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Featured Horizontal Cards
                 BlocBuilder<PaginationBlocReviews, PaginationState>(
                      builder: (context, state) {
                    if (context.read<PaginationBlocReviews>().posts.isEmpty) {
                      if (state == PaginationLoadingState()) {
                        return Container(
                                  height: 200,
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
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                        // const Center(
                        //     child: Padding(
                        //   padding: EdgeInsets.all(8),
                        //   child: CircularProgressIndicator(),
                        // ));
                      } else if (state == PaginationErrorState()) {
                        return Container(
                                  height: 200,
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
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                        // Center(
                        //     child: errorDialog(
                        //         size: 20,
                        //         onPressed: () {
                        //           context
                        //               .read<PaginationBlocRecent>()
                        //               .add(const LoadPageEvent());
                        //         }));
                      }
                    }
                    return Container(
                      height: 230,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              context.read<PaginationBlocReviews>().posts.length +
                                  (context.read<PaginationBlocReviews>().isLastPage
                                      ? 0
                                      : 1),
                          itemBuilder: (context, index) {
                            // request more data when the user has reached the trigger point.
                            context
                                .read<PaginationBlocReviews>()
                                .add(CheckIfNeedMoreDataEvent(index: index));
                            // when the user gets to the last item in the list, check whether
                            // there is an error, otherwise, render a progress indicator.
                            if (index ==
                                context
                                    .read<PaginationBlocReviews>()
                                    .posts
                                    .length) {
                              if (state == PaginationErrorState()) {
                                return Container(
                                  height: 200,
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
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                                // Center(
                                //     child: errorDialog(
                                //         size: 15,
                                //         onPressed: () {
                                //           context
                                //               .read<PaginationBlocRecent>()
                                //               .add(const LoadPageEvent());
                                //         }));
                              } else {
                                return Container(
                                  height: 200,
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
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            );
                                          }))),
                                );
                                // const Center(
                                //     child: Padding(
                                //   padding: EdgeInsets.all(8),
                                //   child: CircularProgressIndicator(),
                                // ));
                              }
                            }
          
                            final Result data =
                                context.read<PaginationBlocReviews>().posts[index];
                            return 
                            // _bannerAd == null?
                            _buildFeaturedCard(
                               data,
                            );
                            // : AdWidget(ad: _bannerAd!);
                          }),
                    );
                  }),
                // SizedBox(
                //   height: 200,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                    
                //       itemCount: nearby.length,
                //       itemBuilder: (context, i) =>  _buildFeaturedCard( 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop',
                //         'Spice Villa',
                //         '4.7 (128 reviews)',
                //         const Color(0xFFC62828),),
                //     ),
                   
                  
                // ),

                const SizedBox(height: 24),

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
                          Text(
                            "Near You",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SeeAllScreen()),
                          );
                        },
                        child: const Text(
                          "See all",
                          style: TextStyle(
                            color: Color(0xFFC62828),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),


 BlocBuilder<PaginationBlocDistance, PaginationState>(
                      builder: (context, state) {
                    if (context.read<PaginationBlocDistance>().posts.isEmpty) {
                      if (state == PaginationLoadingState()) {
                        return Container(
                                  height: MediaQuery.of(context).size.height-400,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                           physics: const NeverScrollableScrollPhysics(),
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
                                  height: MediaQuery.of(context).size.height-400,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                          physics: const NeverScrollableScrollPhysics(),
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
                       height: MediaQuery.of(context).size.height-300,
                      child: ListView.builder(
                         physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount:
                              context.read<PaginationBlocDistance>().posts.length +
                                  (context.read<PaginationBlocDistance>().isLastPage
                                      ? 0
                                      : 1),
                          itemBuilder: (context, index) {
                            // request more data when the user has reached the trigger point.
                            context
                                .read<PaginationBlocDistance>()
                                .add(CheckIfNeedMoreDataEvent(index: index));
                            // when the user gets to the last item in the list, check whether
                            // there is an error, otherwise, render a progress indicator.
                            if (index ==
                                context
                                    .read<PaginationBlocDistance>()
                                    .posts
                                    .length) {
                              if (state == PaginationErrorState()) {
                                return Container(
                                  height: MediaQuery.of(context).size.height-400,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                            physics: const NeverScrollableScrollPhysics(),
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
                               
                              } else {
                                return Container(
                                   height: MediaQuery.of(context).size.height-400,
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      enabled: true,
                                      child: ListView.builder(
                                          itemCount: 4,
                                           physics: const NeverScrollableScrollPhysics(),
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
          
                            final Result data =
                                context.read<PaginationBlocDistance>().posts[index];
                            return 
                            // _bannerAd == null?
                            _buildListingCard(
                               data: data,
                            );
                            // Text(data.name ?? 'No Name');
                            // : AdWidget(ad: _bannerAd!);
                          }),
                    );
                  }),

                //   SizedBox(
                //   height: MediaQuery.of(context).size.height-400,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                    
                //       itemCount: nearby.length,
                //       itemBuilder: (context, i) =>   _buildListingCard(data:nearby[i], 
                  
                // ),
                //     ),
                   
                  
                // ),
                // Listing Cards
                // _buildListingCard(
                //   imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop',
                //   tag: "RESTAURANT",
                //   tagColor: const Color(0xFFC62828),
                //   title: "Spice Villa Restaurant",
                //   desc: "Delicious meals, great ambiance and excellent service.",
                //   rating: 4.7,
                //   reviews: 128,
                //   distance: "0.4 km",
                //   isOpen: true,
                // ),
                // _buildListingCard(
                //   imageUrl: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=1000&auto=format&fit=crop',
                //   tag: "BAR",
                //   tagColor: const Color(0xFF8E24AA),
                //   title: "Ocean View Bar",
                //   desc: "Chill vibes, refreshing drinks and live music.",
                //   rating: 4.5,
                //   reviews: 86,
                //   distance: "0.6 km",
                //   isOpen: true,
                // ),
                // _buildListingCard(
                //   imageUrl: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=1000&auto=format&fit=crop',
                //   tag: "LODGE",
                //   tagColor: const Color(0xFF388E3C),
                //   title: "Sea Breeze Lodge",
                //   desc: "Comfortable rooms with stunning sea views.",
                //   rating: 4.8,
                //   reviews: 64,
                //   distance: "1.2 km",
                //   isOpen: true,
                // ),
                // _buildListingCard(
                //   imageUrl: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=1000&auto=format&fit=crop',
                //   tag: "RESTAURANT",
                //   tagColor: const Color(0xFFC62828),
                //   title: "Taste of India",
                //   desc: "Authentic Indian cuisine with rich flavors.",
                //   rating: 4.6,
                //   reviews: 97,
                //   distance: "0.8 km",
                //   isOpen: false,
                // ),
                // _buildListingCard(
                //   imageUrl: 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?q=80&w=1000&auto=format&fit=crop',
                //   tag: "LOUNGE",
                //   tagColor: const Color(0xFF388E3C),
                //   title: "Sky Lounge",
                //   desc: "Rooftop lounge with panoramic city views.",
                //   rating: 4.9,
                //   reviews: 156,
                //   distance: "1.5 km",
                //   isOpen: true,
                // ),
                // _buildListingCard(
                //   imageUrl: 'https://images.unsplash.com/photo-1559339352-11dcd2f54a5a?q=80&w=1000&auto=format&fit=crop',
                //   tag: "CAFE",
                //   tagColor: const Color(0xFFE65100),
                //   title: "Coffee House",
                //   desc: "Specialty coffee and fresh pastries.",
                //   rating: 4.4,
                //   reviews: 73,
                //   distance: "0.3 km",
                //   isOpen: true,
                // ),
              ]),
            ),
          ),
        ],
      ),
    ));
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
Widget _buildFeaturedCard(Result data) {
  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  return GestureDetector(
    onTap: () => Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: data))
    ),
    child: Container(
      width: 150,
      margin: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(data.banner ?? ''),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: getColorFromHex(data.typeBusiness?.textColor ?? '#C62828'),  // ✅ Fix
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                data.typeBusiness?.name ?? "Category",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                       fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                         data.rating?.toStringAsFixed(1) ?? '0.0', // ✅ Handle null
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: data.isOpen == true ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data.isOpen == true ? "Open" : "Closed",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  // --- Featured Card ---
  Widget _buildFeaturedCardx(Result data) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: data))),
      
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(data.banner!),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Color(data.typeBusiness! as int),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data.typeBusiness!.name ?? "Category",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                           data.rating?.toStringAsFixed(1) ?? '0.0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:data.isOpen == true ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            data.isOpen == true ? "Open" : "Closed",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---
 
  Widget _buildCategoryCardx( Datum data
    ) {
      
      // IconData icon, String label, Color bgColor, Color iconColor
      final IconData icon=data.icon as IconData;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      //  width: 80,
      // height: 50,
      decoration: BoxDecoration(
        color: Color(data.color! as int),
        borderRadius: BorderRadius.circular(10),
        boxShadow:[ BoxShadow(
          color: Colors.black.withOpacity(0.09),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Color(data.textColor! as int ), size: 24),
          const SizedBox(width: 4),
          Text(
            data.name!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  Widget _buildCategoryCard(Datum data) {
  Color getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.white;
    }

    String hex = hexColor.replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    try {
      return Color(int.parse('0x$hex'));
    } catch (_) {
      return Colors.white;
    }
  }

  final cardColor = getColorFromHex(data.color ?? '#FFFFFF');
  final iconColor = getColorFromHex(data.textColor ?? '#E31B23');

  return Material(
    color: Colors.transparent,
    // elevation: 1.5,
    // shadowColor: Colors.black.withOpacity(0.08),
    // borderRadius: BorderRadius.circular(22),
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(datum: data,typeId: data.id ?? 0),
          ),
        );
        // Handle category click here
        // Example:
        // print(data.name);
      },
      child: Container(
        width: 85,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // =========================
            // ICON CIRCLE
            // =========================
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  data.icon?.toIconData() ?? Icons.restaurant,
                  color: iconColor,
                  size: 26,
                ),
              ),
            ),

            const SizedBox(height: 3),

            // =========================
            // CATEGORY NAME
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                data.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF151515),
                ),
              ),
            ),

            // const SizedBox(height: 7),

            // =========================
            // COUNT
            // =========================
            // if (data != null)
            //   Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 11,
            //       vertical: 3,
            //     ),
            //     decoration: BoxDecoration(
            //       color: const Color(0xFFF0F0F3),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Text(
            //       '${data.id}+',
            //       style: const TextStyle(
            //         fontSize: 11,
            //         fontWeight: FontWeight.w700,
            //         color: Color(0xFF252535),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    ),
  );
}
Widget _buildCategoryCardsee(Datum data) {
  // Parse color from hex string
  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    height: 50,
    decoration: BoxDecoration(
      color: getColorFromHex(data.color ?? '#FFFFFF'),  // ✅ Parse hex string
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.09),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(data.icon?.toIconData() ?? Icons.restaurant, color: getColorFromHex(data.textColor ?? '#000000'), size: 24),
          // ignore: non_const_argument_for_const_parameter
          // IconData(int.parse(data.icon?.codeUnits.join() ?? '0x0000'), fontFamily: 'MaterialIcons'),
          // color: getColorFromHex(data.textColor ?? '#000000'),  // ✅ Parse hex string
          // size: 24,
        // ),
        const SizedBox(width: 4),
        Text(
          data.name ?? '',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
  
  Widget _buildListingCard({required Result data}) {
  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  return GestureDetector(
    onTap: () => Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: data))
    ),
    child: Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                data.banner ?? '',
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
                            color: getColorFromHex(data.typeBusiness?.textColor ?? '#C62828'),  // ✅ Fix
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            data.typeBusiness?.name ?? "Category",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // const Icon(Icons.favorite_border, color: Colors.grey, size: 20),
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
                           data.rating?.toStringAsFixed(1) ?? '0.0',
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
                          data.distance?.toString() ?? '0 km',
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
  Widget _buildListingCardx({
    // BuildContext context, 
    required Result data
    // required String imageUrl,
    // required String tag,
    // required Color tagColor,
    // required String title,
    // required String desc,
    // required double rating,
    // required int reviews,
    // required String distance,
    // required bool isOpen,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: data))),
      child:  Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  data.banner!,
                  width: 120,
                  fit: BoxFit.cover,
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
                              color: Color(0xFFC62828),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              data.typeBusiness!.name!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.name!,
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
                        data.bio!,
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
                             data.rating?.toStringAsFixed(1) ?? '0.0',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " (${data.reviews} reviews)",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            data.distance,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const Spacer(),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: data.isOpen! ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.isOpen! ? "Open" : "Closed",
                            style: TextStyle(
                              fontSize: 12,
                              color: data.isOpen! ? Colors.green : Colors.red,
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

// --- Custom SliverPersistentHeaderDelegate ---
class _SliverCategoriesDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverCategoriesDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 106;

  @override
  double get minExtent => 106;

  @override
  bool shouldRebuild(_SliverCategoriesDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}