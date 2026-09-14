import 'dart:convert';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ProfileService {

  
  ProfileService();
  
  // Add a review
  Future<Map<String, dynamic>> addReview({
    required int profileId,
    required double rating,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/prof/api/profile/$profileId/add-review/'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication token if needed
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'rating': rating,
        }),
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['error'] ?? 'Failed to add review');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding review: $e');
      }
      rethrow;
    }
  }
  
  // Update an existing review
  Future<Map<String, dynamic>> updateReview({
    required int profileId,
    required double oldRating,
    required double newRating,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Urls.baseUrl}/prof/api/profile/$profileId/update-review/'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'old_rating': oldRating,
          'new_rating': newRating,
        }),
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['error'] ?? 'Failed to update review');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating review: $e');
      }
      rethrow;
    }
  }
  
  // Remove a review
  Future<Map<String, dynamic>> removeReview({
    required int profileId,
    required double oldRating,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${Urls.baseUrl}/prof/api/profile/$profileId/remove-review/'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'old_rating': oldRating,
        }),
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['error'] ?? 'Failed to remove review');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing review: $e');
      }
      rethrow;
    }
  }
  
  // Get profile review information
  Future<Map<String, dynamic>> getProfileReviews({
    required int profileId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/prof/api/profile/$profileId/reviews/'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['error'] ?? 'Failed to get profile reviews');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting profile reviews: $e');
      }
      rethrow;
    }
  }
}