// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:renthome/component/post.dart';
// import 'package:renthome/component/src/like_button.dart';
// import 'package:renthome/component/src/utils/like_button_model.dart';
// import 'package:renthome/core/services/services_locator.dart';
// import 'package:renthome/model/product.dart';

// // import '../../data/model/post.dart';
// import '../bloc/pagination_bloc.dart';
// import '../widgets/error_dialog.dart';
// import '../widgets/post_item.dart';

// class PostsOverviewScreen extends StatelessWidget {
//   const PostsOverviewScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           appServiceLocator<PaginationBloc>()..add(const LoadPageEvent()),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Blog App"),
//           centerTitle: true,
//         ),
//         body: BlocBuilder<PaginationBloc, PaginationState>(
//           builder: (context, state) {
//             if (context.read<PaginationBloc>().posts.isEmpty) {
//               if (state == PaginationLoadingState()) {
//                 return const Center(
//                     child: Padding(
//                   padding: EdgeInsets.all(8),
//                   child: CircularProgressIndicator(),
//                 ));
//               } else if (state == PaginationErrorState()) {
//                 return Center(
//                     child: errorDialog(
//                         size: 20,
//                         onPressed: () {
//                           context
//                               .read<PaginationBloc>()
//                               .add(const LoadPageEvent());
//                         }));
//               }
//             }
//             return ListView.builder(
//                 itemCount: context.read<PaginationBloc>().posts.length +
//                     (context.read<PaginationBloc>().isLastPage ? 0 : 1),
//                 itemBuilder: (context, index) {
//                   // request more data when the user has reached the trigger point.
//                   context
//                       .read<PaginationBloc>()
//                       .add(CheckIfNeedMoreDataEvent(index: index));
//                   // when the user gets to the last item in the list, check whether
//                   // there is an error, otherwise, render a progress indicator.
//                   if (index == context.read<PaginationBloc>().posts.length) {
//                     if (state == PaginationErrorState()) {
//                       return Center(
//                           child: errorDialog(
//                               size: 15,
//                               onPressed: () {
//                                 context
//                                     .read<PaginationBloc>()
//                                     .add(const LoadPageEvent());
//                               }));
//                     } else {
//                       return const Center(
//                           child: Padding(
//                         padding: EdgeInsets.all(8),
//                         child: CircularProgressIndicator(),
//                       ));
//                     }
//                   }

//                   final Result data =
//                       context.read<PaginationBloc>().posts[index];
//                   return Post(
//                     time: data.timestamp!,
//                     share: data.share.toString(),
//                     like: data.likec.toString(),
//                     views: data.views.toString(),
//                     comments: data.comments.toString(),
//                     cimg: data.cname!.pic!,
//                     cname: data.cname!.name!,
//                     dis: data.discription!,
//                     id: data.pk!.toString(),
//                     imgs: data.image!,
//                     name: data.pname!,
//                     price: data.price!,
//                     status: data.status!,
//                     location: data.location!,
//                     office: data.cname!.office!,
//                     phone: data.phone!,
//                     savefunc: () {},
//                     likefunc: () {},
//                     savewidget: LikeButton(
//                       isLiked: true,
//                       circleColor: CircleColor(
//                         start: Colors.redAccent[100]!,
//                         end: Colors.redAccent[400]!,
//                       ),
//                       bubblesColor: BubblesColor(
//                         dotPrimaryColor: Colors.red[300]!,
//                         dotSecondaryColor: Colors.red[200]!,
//                       ),
//                       likeBuilder: (bool isSaved) {
//                         if (isSaved) {
//                           return const Icon(
//                             Icons.bookmark,
//                             size: 26,
//                             color: Color.fromARGB(255, 61, 61, 61),
//                             // size: buttonSize,
//                           );
//                         } else {
//                           return const Icon(
//                             Icons.bookmark_outline,
//                             size: 26,
//                             color: Color.fromARGB(255, 56, 56, 56),
//                             // size: buttonSize,
//                           );
//                         }
//                       },
//                       likeCount: data.savepd!.length,
//                       countBuilder: (int? count, bool isLiked, String text) {
//                         return Text(
//                           count == 0 ? 'Save' : 'Save',
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: const Color.fromARGB(255, 53, 52, 52)),
//                         );
//                       },
//                       likeCountPadding: const EdgeInsets.only(left: 15.0),
//                       onTap: (isLiked) async {
//                         /// send your request here
//                         // final bool success =
//                         //     (await createSave(data.pk));

//                         // /// if failed, you can do nothing
//                         // return success ? isLiked : !isLiked;

//                         return !isLiked;
//                         // createLike(data.pk);
//                       },
//                     ),

//                     // GestureDetector(
//                     //   onTap: () {
//                     //     print(data.savepd!);

//                     //     // createSave(data.pk);
//                     //     bool iscase=isSaved;
//                     //     iscase=createSave(data.pk) as bool;
//                     //     setState(() {
//                     //      isSaved=iscase;
//                     //     });
//                     //   },
//                     //   child: isSaved
//                     //       ? Icon(
//                     //           Icons.bookmark,
//                     //           color: Theme.of(context).primaryColor,
//                     //         )
//                     //       : Icon(Icons.bookmark_border),
//                     // ),
//                     likewidget: LikeButton(
//                       isLiked: true,
//                       circleColor: CircleColor(
//                         start: Colors.redAccent[100]!,
//                         end: Colors.redAccent[400]!,
//                       ),
//                       bubblesColor: BubblesColor(
//                         dotPrimaryColor: Colors.red[300]!,
//                         dotSecondaryColor: Colors.red[200]!,
//                       ),
//                       likeBuilder: (bool isLiked) {
//                         if (isLiked) {
//                           return const Icon(
//                             Icons.favorite_rounded,
//                             size: 26,
//                             color: Colors.red,
//                             // size: buttonSize,
//                           );
//                         } else {
//                           return const Icon(
//                             Icons.favorite_border,
//                             size: 26,
//                             color: Color.fromARGB(255, 65, 64, 64),
//                             // size: buttonSize,
//                           );
//                         }
//                       },
//                       likeCount: data.likec,
//                       countBuilder: (int? count, bool isLiked, String text) {
//                         return Text(
//                           count == 0 ? 'Favorite' : 'Favorite',
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: const Color.fromARGB(255, 53, 52, 52)),
//                         );
//                       },
//                       likeCountPadding: const EdgeInsets.only(left: 15.0),
//                       onTap: (isLiked) async {
//                         /// send your request here
//                         // print(ids);
//                         // print('show prof id from ' + ids.toString());
//                         // final bool success =
//                         //     (await createLike(data.pk));

//                         // /// if failed, you can do nothing
//                         // return success ? isLiked : !isLiked;

//                         return !isLiked;
//                         // createLike(data.pk);
//                       },
//                     ),
//                     down: Container(),
//                     // down: DropdownButton(
//                     //   items: items.map((String items) {
//                     //     return DropdownMenuItem(
//                     //         value: items,
//                     //         child: Text(
//                     //           items,
//                     //           style: const TextStyle(
//                     //               color: Colors.black,
//                     //               fontSize: 13,
//                     //               fontWeight: FontWeight.w400),
//                     //         ));
//                     //   }).toList(),
//                     //   // value: dropdownvalue,
//                     //   underline: const SizedBox(),
//                     //   icon: const Icon(
//                     //     Icons.more_vert,
//                     //     size: 28,
//                     //     color: Colors.black,
//                     //   ),
//                     //   onChanged: (String? newValue) {
//                     //     setState(() {
//                     //       dropdownvalue = newValue!;
//                     //       if (newValue == 'Call') {
//                     //         print('call');
//                     //         _callNumber(data.phone!);
//                     //       }
//                     //       if (newValue == 'Favourite') {
//                     //         print('Favourite');
//                     //         createLike(data.pk);
//                     //         // removePref();
//                     //       }
//                     //       if (newValue == 'Save') {
//                     //         print('save');
//                     //         createSave(data.pk);
//                     //         // deletePost(datap.pk);
//                     //       }
//                     //     });
//                     //   },
//                     // ))
//                   );
//                 });
//           },
//         ),
//       ),
//     );
//   }
// }
