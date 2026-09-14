
class ProfileReview {
  final int id;
  final String name;
  final double rating;
  final int reviews;
  final String ratingDisplay;
  
  ProfileReview({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.ratingDisplay,
  });
  
  factory ProfileReview.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    return ProfileReview(
      id: profile['id'],
      name: profile['name'],
      rating: profile['rating'].toDouble(),
      reviews: profile['reviews'],
      ratingDisplay: profile['rating_display'] ?? '${profile['rating'].toStringAsFixed(1)} ★',
    );
  }
}