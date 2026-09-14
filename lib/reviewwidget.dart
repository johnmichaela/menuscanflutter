// import 'package:ballon/services/prof_review.dart';
// import 'package:flutter/material.dart';

// class ReviewWidget extends StatefulWidget {
//   final int profileId;
  
//   const ReviewWidget({Key? key, required this.profileId}) : super(key: key);
  
//   @override
//   State<ReviewWidget> createState() => _ReviewWidgetState();
// }

// class _ReviewWidgetState extends State<ReviewWidget> {
//   final ProfileService _profileService = ProfileService(
//      // Replace with your API URL
//   );
  
//   double _currentRating = 0.0;
//   int _reviewCount = 0;
//   bool _isLoading = false;
//   double? _userRating;
  
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileReviews();
//   }
  
//   Future<void> _loadProfileReviews() async {
//     setState(() => _isLoading = true);
    
//     try {
//       final response = await _profileService.getProfileReviews(
//         profileId: widget.profileId,
//       );
      
//       if (response['success']) {
//         setState(() {
//           _currentRating = response['profile']['rating'].toDouble();
//           _reviewCount = response['profile']['reviews'];
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
  
//   Future<void> _submitReview(double rating) async {
//     setState(() => _isLoading = true);
    
//     try {
//       // If user already rated, update their rating
//       if (_userRating != null) {
//         await _profileService.updateReview(
//           profileId: widget.profileId,
//           oldRating: _userRating!,
//           newRating: rating,
//         );
//       } else {
//         await _profileService.addReview(
//           profileId: widget.profileId,
//           rating: rating,
//         );
//       }
      
//       setState(() {
//         _userRating = rating;
//       });
      
//       await _loadProfileReviews(); // Refresh data
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Review submitted successfully!')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
  
//   Future<void> _deleteReview() async {
//     if (_userRating == null) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       await _profileService.removeReview(
//         profileId: widget.profileId,
//         oldRating: _userRating!,
//       );
      
//       setState(() {
//         _userRating = null;
//       });
      
//       await _loadProfileReviews(); // Refresh data
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Review removed successfully!')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display current rating
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Rating: ${_currentRating.toStringAsFixed(1)} ★',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '$_reviewCount reviews',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
            
//             // Star rating input
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) {
//                 final starNumber = index + 1;
//                 return IconButton(
//                   icon: Icon(
//                     (_userRating != null && starNumber <= _userRating!) ||
//                         (_userRating == null && starNumber <= _currentRating.round())
//                         ? Icons.star
//                         : Icons.star_border,
//                     color: (_userRating != null && starNumber <= _userRating!) ||
//                         (_userRating == null && starNumber <= _currentRating.round())
//                         ? Colors.amber
//                         : Colors.grey,
//                     size: 40,
//                   ),
//                   onPressed: _isLoading ? null : () => _submitReview(starNumber.toDouble()),
//                 );
//               }),
//             ),
            
//             if (_userRating != null) ...[
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Your rating: ${_userRating!.toStringAsFixed(1)} ★',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   TextButton(
//                     onPressed: _isLoading ? null : _deleteReview,
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.red,
//                     ),
//                     child: const Text('Remove'),
//                   ),
//                 ],
//               ),
//             ],
            
//             if (_isLoading)
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:ballon/services/prof_review.dart';
import 'package:flutter/material.dart';
import 'package:ballon/l10n/app_strings.dart';

class ReviewWidget extends StatefulWidget {
  final int profileId;
  
  const ReviewWidget({
    Key? key, 
    required this.profileId,
  }) : super(key: key);
  
  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  late final ProfileService _profileService;
  
  double _currentRating = 0.0;
  int _reviewCount = 0;
  bool _isLoading = false;
  double? _userRating;
  bool _hasUserRated = false;
  
  // Safe conversion helpers
  double _safeDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    if (value is num) return value.toDouble();
    return defaultValue;
  }
  
  int _safeInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    if (value is num) return value.toInt();
    return defaultValue;
  }
  
  @override
  void initState() {
    super.initState();
    _profileService = ProfileService();
    _loadProfileReviews();
  }
  
  Future<void> _loadProfileReviews() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final response = await _profileService.getProfileReviews(
        profileId: widget.profileId,
      );
      
      if (!mounted) return;
      
      if (response['success'] == true) {
        final profile = response['profile'] as Map<String, dynamic>? ?? {};
        
        setState(() {
          _currentRating = _safeDouble(profile['rating']);
          _reviewCount = _safeInt(profile['reviews']);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text( 'Error loading reviews: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _submitReview(double rating) async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      if (_hasUserRated && _userRating != null) {
        // Update existing review
        await _profileService.updateReview(
          profileId: widget.profileId,
          oldRating: _userRating!,
          newRating: rating,
        );
      } else {
        // Add new review
        await _profileService.addReview(
          profileId: widget.profileId,
          rating: rating,
        );
      }
      
      if (mounted) {
        setState(() {
          _userRating = rating;
          _hasUserRated = true;
        });
        
        await _loadProfileReviews(); // Refresh data
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _deleteReview() async {
    if (_userRating == null || _isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      await _profileService.removeReview(
        profileId: widget.profileId,
        oldRating: _userRating!,
      );
      
      if (mounted) {
        setState(() {
          _userRating = null;
          _hasUserRated = false;
        });
        
        await _loadProfileReviews(); // Refresh data
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review removed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Show stars based on current rating
                    Row(
                      children: List.generate(5, (index) {
                        final starNumber = index + 1;
                        final isFilled = starNumber <= _currentRating.round();
                        return Icon(
                          isFilled ? Icons.star : Icons.star_border,
                          color: isFilled ? Colors.amber : Colors.grey.shade400,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentRating.toStringAsFixed(1)}',
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$_reviewCount ${context.tr.reviews}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.titleMedium?.color,

                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Divider
            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),
            
            const SizedBox(height: 10),
            
            // Rating input label
            Text(
              _hasUserRated ?  'Update your rating' : 'Rate this profile',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:  Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Star rating input - Interactive stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNumber = index + 1;
                final isSelected = _userRating != null && starNumber <= _userRating!;
                final isHovered = false; // Could add hover effect if needed
                
                return InkWell(
                  onTap: _isLoading ? null : () => _submitReview(starNumber.toDouble()),
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      isSelected ? Icons.star : Icons.star_border,
                      color: isSelected ? Colors.amber : Colors.grey.shade400,
                      size: 30,
                    ),
                  ),
                );
              }),
            ),
            
            // Show user rating info
            if (_hasUserRated && _userRating != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your rating: ${_userRating!.toStringAsFixed(1)} ★',
                      style:  TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color:Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _isLoading ? null : _deleteReview,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}